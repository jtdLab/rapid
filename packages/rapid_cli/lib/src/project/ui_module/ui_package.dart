part of '../project.dart';

/// {@template platform_ui_package}
/// Abstraction of the ui package of a Rapid project.
///
// TODO(jtdLab): more docs.
/// {@endtemplate}
class UiPackage extends DartPackage {
  /// {@macro ui_module}
  UiPackage({
    required this.projectName,
    required String path,
    required this.widget,
    required this.themedWidget,
  }) : super(path);

  /// Returns a [UiPackage] from given [projectName] and [projectPath].
  factory UiPackage.resolve({
    required String projectName,
    required String projectPath,
  }) {
    final path = p.join(
      projectPath,
      'packages',
      '${projectName}_ui',
      '${projectName}_ui',
    );
    Widget widget({required String name}) =>
        Widget(projectName: projectName, name: name, path: path);
    ThemedWidget themedWidget({required String name}) =>
        ThemedWidget(projectName: projectName, name: name, path: path);

    return UiPackage(
      projectName: projectName,
      path: path,
      widget: widget,
      themedWidget: themedWidget,
    );
  }

  /// The name of the project this package is part of.
  final String projectName;

  /// The `lib/<project-name>_ui.dart` file.
  DartFile get barrelFile =>
      DartFile(p.join(path, 'lib', '${projectName}_ui.dart'));

  /// The `lib/src/theme_extensions.dart` file.
  DartFile get themeExtensionsFile =>
      DartFile(p.join(path, 'lib', 'src', 'theme_extensions.dart'));

  /// The widget builder.
  final Widget Function({required String name}) widget;

  /// The themed widget builder.
  final ThemedWidget Function({required String name}) themedWidget;

  /// Generate this package on disk.
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
