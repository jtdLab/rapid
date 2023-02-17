import 'dart:io' as io;

import 'package:mason/mason.dart';
import 'package:path/path.dart' as p;
import 'package:rapid_cli/src/core/directory_impl.dart';
import 'package:rapid_cli/src/core/generator_builder.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/core/plist_file_impl.dart';
import 'package:rapid_cli/src/project/app_package/app_package.dart';

import 'android_native_directory_bundle.dart';
import 'ios_native_directory_bundle.dart';
import 'linux_native_directory_bundle.dart';
import 'macos_native_directory_bundle.dart';
import 'platform_native_directory.dart';
import 'web_native_directory_bundle.dart';
import 'windows_native_directory_bundle.dart';

class PlatformNativeDirectoryImpl extends DirectoryImpl
    implements PlatformNativeDirectory {
  PlatformNativeDirectoryImpl(
    this.platform, {
    required AppPackage appPackage,
    GeneratorBuilder? generator,
  })  : _appPackage = appPackage,
        _generator = generator ?? MasonGenerator.fromBundle,
        super(
          path: p.join(appPackage.path, platform.name),
        );

  final AppPackage _appPackage;
  final GeneratorBuilder _generator;

  @override
  final Platform platform;

  @override
  Future<void> create({
    String? description,
    String? orgName,
    String? language,
    required Logger logger,
  }) async {
    final projectName = _appPackage.project.name();

    late final MasonGenerator generator;
    if (platform == Platform.android) {
      generator = await _generator(androidNativeDirectoryBundle);
    } else if (platform == Platform.ios) {
      generator = await _generator(iosNativeDirectoryBundle);
    } else if (platform == Platform.linux) {
      generator = await _generator(linuxNativeDirectoryBundle);
    } else if (platform == Platform.macos) {
      generator = await _generator(macosNativeDirectoryBundle);
    } else if (platform == Platform.web) {
      generator = await _generator(webNativeDirectoryBundle);
    } else {
      generator = await _generator(windowsNativeDirectoryBundle);
    }

    await generator.generate(
      DirectoryGeneratorTarget(io.Directory(path)),
      vars: <String, dynamic>{
        'project_name': projectName,
        if (description != null) 'description': description,
        if (orgName != null) 'org_name': orgName,
        if (language != null) 'language': language, // TODO update ios template
      },
      logger: logger,
    );
  }
}

class IosNativeDirectoryImpl extends PlatformNativeDirectoryImpl
    implements IosNativeDirectory {
  IosNativeDirectoryImpl({
    required super.appPackage,
    super.generator,
    InfoPlistFile? infoPlistFile,
  }) : super(Platform.ios) {
    this.infoPlistFile =
        infoPlistFile ?? InfoPlistFile(iosNativeDirectory: this);
  }

  @override
  late final InfoPlistFile infoPlistFile;
}

class InfoPlistFileImpl extends PlistFileImpl implements InfoPlistFile {
  InfoPlistFileImpl({
    required this.iosNativeDirectory,
  }) : super(
          path: p.join(iosNativeDirectory.path, 'Runner'),
          name: 'Info',
        );

  @override
  final IosNativeDirectory iosNativeDirectory;

  @override
  void addLanguage({required String language}) {
    final dict = readDict();

    final languages =
        ((dict['CFBundleLocalizations'] ?? []) as List).cast<String>();
    if (!languages.contains(language)) {
      dict['CFBundleLocalizations'] = [...languages, language];
      setDict(dict);
    }
  }

  @override
  void removeLanguage({required String language}) {
    final dict = readDict();

    final languages =
        ((dict['CFBundleLocalizations'] ?? []) as List).cast<String>();
    if (languages.contains(language)) {
      dict['CFBundleLocalizations'] = languages..remove(language);
      setDict(dict);
    }
  }
}
