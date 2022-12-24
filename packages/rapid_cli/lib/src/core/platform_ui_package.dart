import 'platform.dart';
import 'project_package.dart';

/// {@template platform_ui_package}
/// Abstraction of the `packages/<NAME>_ui/<NAME>_ui_<PLATFORM>` package in a Rapid project.
/// {@endtemplate}
class PlatformUiPackage extends ProjectPackage {
  /// {@macro platform_ui_package}
  PlatformUiPackage(
    this.platform, {
    required super.project,
  }) : super(
          'packages/${project.melosFile.name}_ui/${project.melosFile.name}_ui_${platform.name}',
        );

  final Platform platform;
}
