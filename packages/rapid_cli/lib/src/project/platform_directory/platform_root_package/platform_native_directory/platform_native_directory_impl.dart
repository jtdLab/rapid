import 'package:mason/mason.dart';
import 'package:path/path.dart' as p;
import 'package:rapid_cli/src/core/directory_impl.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/core/plist_file_impl.dart';
import 'package:rapid_cli/src/project/core/generator_mixins.dart';
import 'package:rapid_cli/src/project/platform_directory/platform_root_package/platform_root_package.dart';

import 'android_native_directory_bundle.dart';
import 'ios_native_directory_bundle.dart';
import 'linux_native_directory_bundle.dart';
import 'macos_native_directory_bundle.dart';
import 'platform_native_directory.dart';
import 'web_native_directory_bundle.dart';
import 'windows_native_directory_bundle.dart';

abstract class PlatformNativeDirectoryImpl extends DirectoryImpl
    with OverridableGenerator, Generatable
    implements PlatformNativeDirectory {
  PlatformNativeDirectoryImpl({
    required PlatformRootPackage rootPackage,
  })  : _rootPackage = rootPackage,
        super(
          path: p.join(rootPackage.path, rootPackage.platform.name),
        );

  final PlatformRootPackage _rootPackage;
}

class NoneIosNativeDirectoryImpl extends PlatformNativeDirectoryImpl
    implements NoneIosNativeDirectory {
  NoneIosNativeDirectoryImpl({
    required super.rootPackage,
  }) : assert(rootPackage.platform != Platform.ios);

  @override
  Future<void> create({
    String? description,
    String? orgName,
    required Logger logger,
  }) async {
    final projectName = _rootPackage.project.name();
    final platform = _rootPackage.platform;

    late final MasonBundle bundle;
    if (platform == Platform.android) {
      bundle = androidNativeDirectoryBundle;
    } else if (platform == Platform.linux) {
      bundle = linuxNativeDirectoryBundle;
    } else if (platform == Platform.macos) {
      bundle = macosNativeDirectoryBundle;
    } else if (platform == Platform.web) {
      bundle = webNativeDirectoryBundle;
    } else {
      bundle = windowsNativeDirectoryBundle;
    }

    await generate(
      name: 'native directory (${platform.name})',
      bundle: bundle,
      vars: <String, dynamic>{
        'project_name': projectName,
        if (description != null) 'description': description,
        if (orgName != null) 'org_name': orgName,
      },
      logger: logger,
    );
  }
}

class IosNativeDirectoryImpl extends PlatformNativeDirectoryImpl
    implements IosNativeDirectory {
  IosNativeDirectoryImpl({
    required super.rootPackage,
  });

  InfoPlistFile get _infoPlistFile =>
      infoPlistFileOverrides ?? InfoPlistFile(iosNativeDirectory: this);

  @override
  InfoPlistFile? infoPlistFileOverrides;

  @override
  Future<void> create({
    required String orgName,
    required String language,
    required Logger logger,
  }) async {
    final projectName = _rootPackage.project.name();

    await generate(
      name: 'native directory (ios)',
      bundle: iosNativeDirectoryBundle,
      vars: <String, dynamic>{
        'project_name': projectName,
        'org_name': orgName,
        'language': language, // TODO update ios template
      },
      logger: logger,
    );
  }

  @override
  void addLanguage({required String language}) =>
      _infoPlistFile.addLanguage(language: language);

  @override
  void removeLanguage({required String language}) =>
      _infoPlistFile.removeLanguage(language: language);
}

class InfoPlistFileImpl extends PlistFileImpl implements InfoPlistFile {
  InfoPlistFileImpl({
    required IosNativeDirectory iosNativeDirectory,
  }) : super(
          path: p.join(iosNativeDirectory.path, 'Runner'),
          name: 'Info',
        );

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
