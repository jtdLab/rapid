import 'package:mason/mason.dart';
import 'package:path/path.dart' as p;
import 'package:rapid_cli/src/core/directory_impl.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/core/plist_file_impl.dart';
import 'package:rapid_cli/src/project/core/generator_mixins.dart';

import '../platform_root_package.dart';
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
  PlatformNativeDirectoryImpl({super.path});
}

class NoneIosNativeDirectoryImpl extends PlatformNativeDirectoryImpl
    implements NoneIosNativeDirectory {
  NoneIosNativeDirectoryImpl({
    required PlatformRootPackage rootPackage,
  })  : assert(rootPackage.platform != Platform.ios),
        _rootPackage = rootPackage,
        super(
          path: p.join(
            rootPackage.path,
            rootPackage.platform == Platform.mobile
                ? 'android'
                : rootPackage.platform.name,
          ),
        );

  final PlatformRootPackage _rootPackage; // TODO could be more specific type

  @override
  Future<void> create({
    String? description,
    String? orgName,
  }) async {
    final projectName = _rootPackage.project.name;
    final platform = _rootPackage.platform;

    late final MasonBundle bundle;
    if (platform == Platform.android || platform == Platform.mobile) {
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
      bundle: bundle,
      vars: <String, dynamic>{
        'project_name': projectName,
        if (description != null) 'description': description,
        if (orgName != null) 'org_name': orgName,
      },
    );
  }
}

class IosNativeDirectoryImpl extends PlatformNativeDirectoryImpl
    implements IosNativeDirectory {
  IosNativeDirectoryImpl({
    required PlatformRootPackage rootPackage,
  })  : _rootPackage = rootPackage,
        super(
          path: p.join(
            rootPackage.path,
            'ios',
          ),
        );

  final PlatformRootPackage _rootPackage; // TODO could be more specific type

  InfoPlistFile get _infoPlistFile =>
      infoPlistFileOverrides ?? InfoPlistFile(iosNativeDirectory: this);

  @override
  InfoPlistFile? infoPlistFileOverrides;

  @override
  Future<void> create({
    required String orgName,
    required String language,
  }) async {
    final projectName = _rootPackage.project.name;

    await generate(
      bundle: iosNativeDirectoryBundle,
      vars: <String, dynamic>{
        'project_name': projectName,
        'org_name': orgName,
        'language': language, // TODO update ios template
      },
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
