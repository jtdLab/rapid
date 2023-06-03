import 'package:meta/meta.dart';
import 'package:rapid_cli/src/core/dart_file.dart';
import 'package:rapid_cli/src/core/dart_package.dart';
import 'package:rapid_cli/src/core/file_system_entity_collection.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/project/core/generator_mixins.dart';

import '../../project.dart';
import 'platform_navigation_package_impl.dart';

typedef PlatformNavigationPackageBuilder = PlatformNavigationPackage Function(
  Platform platform, {
  required RapidProject project,
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
    required RapidProject project,
  }) =>
      PlatformNavigationPackageImpl(
        platform,
        project: project,
      );

  @visibleForTesting
  NavigatorBuilder? navigatorOverrides;

  @visibleForTesting
  PlatformNavigationPackageBarrelFileBuilder? barrelFileOverrides;

  PlatformNavigationPackageBarrelFile get barrelFile;

  Navigator navigator({required String name});

  Future<void> create();
}

typedef NavigatorBuilder = Navigator Function({
  required String name,
  required PlatformNavigationPackage navigationPackage,
});

/// {@template navigator}
/// Abstraction of a navigator of a platform navigation packaage of a Rapid project.
/// {@endtemplate}
abstract class Navigator
    implements FileSystemEntityCollection, OverridableGenerator {
  /// {@macro navigator}
  factory Navigator({
    required String name,
    required PlatformNavigationPackage platformNavigationPackage,
  }) =>
      NavigatorImpl(
        name: name,
        platformNavigationPackage: platformNavigationPackage,
      );

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
