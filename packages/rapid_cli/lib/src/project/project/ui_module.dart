part of '../project.dart';

class UiModule extends Directory {
  UiModule({
    required String path,
    required this.uiPackage,
    required this.platformUiPackage,
  }) : super(path);

  factory UiModule.resolve({
    required String projectName,
    required String projectPath,
  }) {
    final path = p.join(projectPath, 'packages', '${projectName}_ui');
    final uiPackage =
        UiPackage.resolve(projectName: projectName, projectPath: projectPath);

    platformUiPackage({required Platform platform}) =>
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

  final UiPackage uiPackage;

  final PlatformUiPackage Function({required Platform platform})
      platformUiPackage;
}
