part of '../project.dart';

// TODO(jtdLab): rethink abstraction of themed widget

/// {@template widget}
/// Abstraction of a widget of a Rapid project.
///
// TODO(jtdLab): more docs.
/// {@endtemplate}
class Widget extends FileSystemEntityCollection {
  /// {@macro widget}
  Widget({
    required this.projectName,
    required this.name,
    required this.path,
    this.platform,
  });

  /// The name of the project this widget is part of.
  final String projectName;

  /// The optional platform.
  final Platform? platform;

  /// The name of this widget.
  final String name;

  /// The path of the ui package this widget is part of.
  final String path;

  /// The `lib/src/<name>.dart` file.
  File get file => File(p.join(path, 'lib', 'src', '${name.snakeCase}.dart'));

  /// The `test/src/<name>_test.dart` file.
  File get testFile =>
      File(p.join(path, 'test', 'src', '${name.snakeCase}_test.dart'));

  @override
  Iterable<FileSystemEntity> get entities => {
        file,
        testFile,
      };

  /// Generate this widget on disk.
  Future<void> generate() async {
    await mason.generate(
      bundle: widgetBundle,
      target: Directory(path),
      vars: <String, dynamic>{
        'project_name': projectName,
        'name': name,
        ...platformVars(platform),
      },
    );
  }
}

/// {@template themed_widget}
/// Abstraction of a themed widget of a Rapid project.
///
// TODO(jtdLab): more docs.
/// {@endtemplate}
class ThemedWidget extends Widget {
  /// {@macro themed_widget}
  ThemedWidget({
    required super.projectName,
    required super.name,
    required super.path,
    super.platform,
  });

  /// The theme of this widget.
  Theme get theme => Theme(widgetName: name, path: path);

  @override
  Iterable<FileSystemEntity> get entities => {
        file,
        testFile,
        ...theme.entities,
      };

  @override
  Future<void> generate() async {
    await mason.generate(
      bundle: themedWidgetBundle,
      target: Directory(path),
      vars: <String, dynamic>{
        'project_name': projectName,
        'name': name,
        ...platformVars(platform),
      },
    );
  }
}

/// {@template theme}
/// Abstraction of a theme of a Rapid project.
///
// TODO(jtdLab): more docs.
/// {@endtemplate}
class Theme extends FileSystemEntityCollection {
  /// {@macro theme}
  Theme({
    required this.widgetName,
    required this.path,
  });

  /// The name of the widget this theme is part of.
  final String widgetName;

  /// The path of the ui package this theme is part of.
  final String path;

  /// The `lib/src/<widget-name>_theme.dart` file.
  File get file =>
      File(p.join(path, 'lib', 'src', '${widgetName.snakeCase}_theme.dart'));

  /// The `lib/src/<widget-name>_theme.tailor.dart` file.
  File get tailorFile => File(
        p.join(path, 'lib', 'src', '${widgetName.snakeCase}_theme.tailor.dart'),
      );

  /// The `test/src/<widget-name>_theme_test.dart` file.
  File get testFile => File(
        p.join(path, 'test', 'src', '${widgetName.snakeCase}_theme_test.dart'),
      );

  @override
  Iterable<FileSystemEntity> get entities => {
        file,
        tailorFile,
        testFile,
      };
}
