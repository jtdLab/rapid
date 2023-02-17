import 'package:mason/mason.dart';
import 'package:rapid_cli/src/core/directory.dart';
import 'package:rapid_cli/src/core/generator_builder.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/core/plist_file.dart';
import 'package:rapid_cli/src/project/app_package/app_package.dart';

import 'platform_native_directory_impl.dart';

/// {@template platform_native_directory}
/// Abstraction of a platform native directory of the app package of a Rapid project.
///
/// Location: `packages/<project name>/<project name>/<platform>`
/// {@endtemplate}
abstract class PlatformNativeDirectory implements Directory {
  /// {@macro platform_native_directory}
  factory PlatformNativeDirectory(
    Platform platform, {
    required AppPackage appPackage,
    GeneratorBuilder? generator,
  }) =>
      PlatformNativeDirectoryImpl(
        platform,
        appPackage: appPackage,
        generator: generator,
      );

  Platform get platform;

  Future<void> create({
    String? description,
    String? orgName,
    String? language,
    required Logger logger,
  });
}

/// {@template ios_native_directory}
/// Abstraction of the ios native directory of the app package of a Rapid project.
///
/// Location: `packages/<project name>/<project name>/ios`
/// {@endtemplate}
abstract class IosNativeDirectory implements PlatformNativeDirectory {
  /// {@macro ios_native_directory}
  factory IosNativeDirectory({
    required AppPackage appPackage,
    GeneratorBuilder? generator,
  }) =>
      IosNativeDirectoryImpl(
        appPackage: appPackage,
        generator: generator,
      );

  InfoPlistFile get infoPlistFile;
}

/// {@template info_plist_file}
/// Abstraction of the Info.plist file of the ios native directory of the app package of a Rapid project.
///
/// Location: `packages/<project name>/<project name>/ios/Runner/Info.plist`
/// {@endtemplate}
abstract class InfoPlistFile implements PlistFile {
  /// {@macro info_plist_file}
  factory InfoPlistFile({
    required IosNativeDirectory iosNativeDirectory,
  }) =>
      InfoPlistFileImpl(
        iosNativeDirectory: iosNativeDirectory,
      );

  IosNativeDirectory get iosNativeDirectory;

  void addLanguage({required String language});

  void removeLanguage({required String language});
}
