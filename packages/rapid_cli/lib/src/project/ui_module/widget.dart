part of '../project.dart';

// TODO rethink abstraction of themed widget

class Widget extends FileSystemEntityCollection {
  Widget({
    required this.projectName,
    this.platform,
    required this.name,
    required this.path,
  });

  final String projectName;

  final Platform? platform;

  final String name;

  final String path;

  File get file => File(p.join(path, 'lib', 'src', '${name.snakeCase}.dart'));

  File get testFile =>
      File(p.join(path, 'test', 'src', '${name.snakeCase}_test.dart'));

  @override
  Iterable<FileSystemEntity> get entities => {
        file,
        testFile,
      };

  Future<void> generate() async {
    await mason.generate(
      bundle: widgetBundle,
      target: Directory(path),
      vars: <String, dynamic>{
        'project_name': projectName,
        'name': name,
        'platform': platform?.name,
      },
    );
  }
}

class ThemedWidget extends Widget {
  ThemedWidget({
    required super.projectName,
    super.platform,
    required super.name,
    required super.path,
  });

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
        'platform': platform?.name,
      },
    );
  }
}

class Theme extends FileSystemEntityCollection {
  Theme({
    required this.widgetName,
    required this.path,
  });

  final String widgetName;

  final String path;

  File get file =>
      File(p.join(path, 'lib', 'src', '${widgetName.snakeCase}_theme.dart'));

  File get tailorFile => File(
      p.join(path, 'lib', 'src', '${widgetName.snakeCase}_theme.tailor.dart'));

  File get testFile => File(
      p.join(path, 'test', 'src', '${widgetName.snakeCase}_theme_test.dart'));

  @override
  Iterable<FileSystemEntity> get entities => {
        file,
        tailorFile,
        testFile,
      };
}
