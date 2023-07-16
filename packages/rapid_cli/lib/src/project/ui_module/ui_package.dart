part of '../project.dart';

class UiPackage extends DartPackage {
  UiPackage({
    required this.projectName,
    required String path,
    required this.widget,
    required this.themedWidget,
  }) : super(path);

  factory UiPackage.resolve({
    required String projectName,
    required String projectPath,
  }) {
    final path = p.join(
        projectPath, 'packages', '${projectName}_ui', '${projectName}_ui');
    widget({required String name}) =>
        Widget(projectName: projectName, name: name, path: path);
    themedWidget({required String name}) =>
        ThemedWidget(projectName: projectName, name: name, path: path);

    return UiPackage(
      projectName: projectName,
      path: path,
      widget: widget,
      themedWidget: themedWidget,
    );
  }

  final String projectName;

  DartFile get barrelFile =>
      DartFile(p.join(path, 'lib', '${projectName}_ui.dart'));

  DartFile get themeExtensionsFile =>
      DartFile(p.join(path, 'lib', 'src', 'theme_extensions.dart'));

  final Widget Function({required String name}) widget;

  final ThemedWidget Function({required String name}) themedWidget;

  Future<void> generate() async {
    await mason.generate(
      bundle: uiPackageBundle,
      target: this,
      vars: <String, dynamic>{
        'project_name': projectName,
      },
    );
  }
}
