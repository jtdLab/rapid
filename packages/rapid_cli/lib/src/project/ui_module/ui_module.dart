part of '../project.dart';

/// {@template platform_ui_module}
/// Abstraction of the platform ui module of a Rapid project.
///
// TODO(jtdLab): more docs.
/// {@endtemplate}
class UiModule extends Directory {
  /// {@macro platform_ui_module}
  UiModule({
    required String path,
    required this.uiPackage,
    required this.platformUiPackage,
  }) : super(path);

  /// Returns a [UiModule] from given [projectName] and [projectPath].
  factory UiModule.resolve({
    required String projectName,
    required String projectPath,
  }) {
    final path = p.join(projectPath, 'packages', '${projectName}_ui');
    final uiPackage =
        UiPackage.resolve(projectName: projectName, projectPath: projectPath);
    PlatformUiPackage platformUiPackage({required Platform platform}) =>
        PlatformUiPackage.resolve(
          projectName: projectName,
          projectPath: projectPath,
          platform: platform,
        );

    return UiModule(
      path: path,
      uiPackage: uiPackage,
      platformUiPackage: platformUiPackage,
    );
  }

  /// The ui package.
  final UiPackage uiPackage;

  /// The platform ui package builder for a given platform.
  final PlatformUiPackage Function({required Platform platform})
      platformUiPackage;
}
