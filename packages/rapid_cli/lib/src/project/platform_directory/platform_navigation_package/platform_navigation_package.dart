import 'package:mason/mason.dart';
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

  Future<void> create({
    required Logger logger,
  });
}
