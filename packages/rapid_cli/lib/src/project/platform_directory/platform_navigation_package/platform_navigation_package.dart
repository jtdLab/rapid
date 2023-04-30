import 'package:meta/meta.dart';
import 'package:rapid_cli/src/core/dart_file.dart';
import 'package:rapid_cli/src/core/dart_package.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/project/core/generator_mixins.dart';
import 'package:rapid_cli/src/project/project.dart';

import 'platform_navigation_package_impl.dart';

typedef PlatformNavigationPackageBuilder = PlatformNavigationPackage Function(
  Platform platform, {
  required Project project,
});

/// {@template platform_navigation_package}
/// Abstraction of a platform navigation package of a Rapid project.
///
/// Location: `packages/<project name>/<project name>_<platform>/<project name>_<platform>_navigation`
/// {@endtemplate}
abstract class PlatformNavigationPackage
    implements DartPackage, OverridableGenerator {
  /// {@macro platform_navigation_package}
  factory PlatformNavigationPackage(
    Platform platform, {
    required Project project,
  }) =>
      PlatformNavigationPackageImpl(
        platform,
        project: project,
      );

  @visibleForTesting
  PlatformNavigationPackageBarrelFileBuilder? barrelFileOverrides;

  PlatformNavigationPackageBarrelFile get barrelFile;

  Future<void> create();
}

typedef PlatformNavigationPackageBarrelFileBuilder
    = PlatformNavigationPackageBarrelFile Function({
  required PlatformNavigationPackage platformNavigationPackage,
});

/// {@template platform_ui_package_barrel_file}
/// Abstraction of the barrel file of a platform navigation package of a Rapid project.
///
/// Location: `packages/<project name>/<project name>_<platform>/<project name>_<platform>_navigation/lib/<project name>_<platform>_navigation.dart`
/// {@endtemplate}
abstract class PlatformNavigationPackageBarrelFile implements DartFile {
  /// {@macro platform_ui_package_barrel_file}
  factory PlatformNavigationPackageBarrelFile({
    required PlatformNavigationPackage platformNavigationPackage,
  }) =>
      PlatformNavigationPackageBarrelFileImpl(
        platformNavigationPackage: platformNavigationPackage,
      );
}
