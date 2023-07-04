part of '../../project.dart';

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

  File get file => File(p.join(path, 'lib', 'src', '$name.dart'));

  File get testFile => File(p.join(path, 'test', 'src', '$name.dart'));

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
        'platform': platform,
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

  File get themeFile => File(p.join(path, 'lib', 'src', '${name}_theme.dart'));

  File get themeTailorFile =>
      File(p.join(path, 'lib', 'src', '${name}_theme.tailor.dart'));

  File get themeTestFile =>
      File(p.join(path, 'test', 'src', '${name}_theme.dart'));

  @override
  Iterable<FileSystemEntity> get entities => {
        themeFile,
        themeTailorFile,
        file,
        testFile,
        themeTestFile,
      };

  @override
  Future<void> generate() async {
    await mason.generate(
      bundle: themedWidgetBundle,
      target: Directory(path),
      vars: <String, dynamic>{
        'project_name': projectName,
        'name': name,
        'platform': platform,
      },
    );
  }
}
