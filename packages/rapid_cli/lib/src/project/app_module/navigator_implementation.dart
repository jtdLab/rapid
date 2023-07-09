part of '../project.dart';

class NavigatorImplementation extends FileSystemEntityCollection {
  NavigatorImplementation({
    required this.projectName,
    required this.platform,
    required this.path,
    required this.name,
  });

  final String projectName;

  final Platform platform;

  final String path;

  final String name;

  File get file => File(p.join(path, 'lib', 'src', '$name.dart'));

  File get freezedFile =>
      File(p.join(path, 'lib', 'src', '$name.freezed.dart'));

  File get testFile => File(p.join(path, 'test', 'src', '${name}_test.dart'));

  @override
  Iterable<FileSystemEntity> get entities => {
        file,
        freezedFile,
        testFile,
      };

  Future<void> generate() async {
    await mason.generate(
      bundle: navigatorImplementationBundle,
      target: Directory(path),
      vars: <String, dynamic>{
        'project_name': projectName,
        'name': name,
        'platform': platform.name,
      },
    );
  }
}
