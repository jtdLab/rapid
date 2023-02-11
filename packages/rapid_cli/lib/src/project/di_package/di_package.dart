import 'package:mason/mason.dart';
import 'package:rapid_cli/src/core/dart_file.dart';
import 'package:rapid_cli/src/core/dart_package.dart';
import 'package:rapid_cli/src/core/generator_builder.dart';
import 'package:rapid_cli/src/project/di_package/di_package_impl.dart';
import 'package:rapid_cli/src/project/platform_directory/platform_feature_package/platform_feature_package.dart';
import 'package:rapid_cli/src/project/project.dart';

/// {@template di_package}
/// Abstraction of the di package of a Rapid project.
///
/// Location: `packages/<project name>/<project name>_di`
/// {@endtemplate}
abstract class DiPackage implements DartPackage {
  /// {@macro di_package}
  factory DiPackage({
    required Project project,
    PubspecFile? pubspecFile,
    InjectionFile? injectionFile,
    GeneratorBuilder? generator,
  }) =>
      DiPackageImpl(
        project: project,
        pubspecFile: pubspecFile,
        injectionFile: injectionFile,
        generator: generator,
      );

  Project get project;

  Future<void> create({
    required bool android,
    required bool ios,
    required bool linux,
    required bool macos,
    required bool web,
    required bool windows,
    required Logger logger,
  });

  Future<void> registerCustomFeaturePackage(
    PlatformCustomFeaturePackage customFeaturePackage, {
    required Logger logger,
  });

  Future<void> unregisterCustomFeaturePackages(
    Iterable<PlatformCustomFeaturePackage> customFeaturePackages, {
    required Logger logger,
  });
}

/// {@template injection_file}
/// Abstraction of the injection file in the di package of a Rapid project.
///
/// Location: `packages/<project name>/<project name>_di/lib/src/injection.dart`
/// {@endtemplate}
abstract class InjectionFile implements DartFile {
  /// {@macro injection_file}
  factory InjectionFile({
    required DiPackage diPackage,
  }) =>
      InjectionFileImpl(diPackage: diPackage);

  /// Adds [customFeaturePackage] to the injection file.
  void addCustomFeaturePackage(
    PlatformCustomFeaturePackage customFeaturePackage,
  );

  /// Removes [customFeaturePackage] from the injection file.
  void removeCustomFeaturePackage(
    PlatformCustomFeaturePackage customFeaturePackage,
  );
}
