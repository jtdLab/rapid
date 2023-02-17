import 'package:mason/mason.dart';
import 'package:rapid_cli/src/core/dart_file.dart';
import 'package:rapid_cli/src/core/dart_package.dart';
import 'package:rapid_cli/src/core/environment.dart';
import 'package:rapid_cli/src/core/generator_builder.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/project/app_package/platform_native_directory/platform_native_directory.dart';
import 'package:rapid_cli/src/project/project.dart';

import 'app_package_impl.dart';

/// Signature for method that returns the [PlatformNativeDirectory] for [platform].
typedef PlatformNativeDirectoryBuilder = PlatformNativeDirectory Function({
  required Platform platform,
});

/// {@template app_package}
/// Abstraction of the app package of a Rapid project.
///
/// Location: `packages/<project name>/<project name>`
/// {@endtemplate}
abstract class AppPackage implements DartPackage {
  /// {@macro app_package}
  factory AppPackage({
    required Project project,
    PubspecFile? pubspecFile,
    PlatformNativeDirectoryBuilder? platformNativeDirectory,
    Set<MainFile>? mainFiles,
    GeneratorBuilder? generator,
  }) =>
      AppPackageImpl(
        project: project,
        pubspecFile: pubspecFile,
        platformNativeDirectory: platformNativeDirectory,
        mainFiles: mainFiles,
        generator: generator,
      );

  Project get project;

  PlatformNativeDirectoryBuilder get platformNativeDirectory;

  Future<void> create({
    required String description,
    required String orgName,
    required String language,
    required bool android,
    required bool ios,
    required bool linux,
    required bool macos,
    required bool web,
    required bool windows,
    required Logger logger,
  });

  Future<void> addPlatform(
    Platform platform, {
    String? description,
    String? orgName,
    required Logger logger,
  });

  Future<void> removePlatform(
    Platform platform, {
    required Logger logger,
  });
}

/// {@template main_file}
/// Abstraction of a main file in the app package of a Rapid project.
///
/// Location: `packages/<project name>/<project name>/lib/main_<env>.dart`
/// {@endtemplate}
abstract class MainFile implements DartFile {
  /// {@macro main_file}
  factory MainFile(
    Environment environment, {
    required AppPackage appPackage,
  }) =>
      MainFileImpl(
        environment,
        appPackage: appPackage,
      );

  Environment get environment;

  void addSetupForPlatform(Platform platform);

  void removeSetupForPlatform(Platform platform);
}
