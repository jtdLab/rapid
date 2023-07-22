part of '../project.dart';

class Entity extends FileSystemEntityCollection {
  Entity({
    required this.projectName,
    required this.path,
    required this.name,
    this.subDomainName,
  });

  final String projectName;

  final String path;

  final String name;

  final String? subDomainName;

  File get file => File(p.join(path, 'lib', 'src', '${name.snakeCase}.dart'));

  File get freezedFile =>
      File(p.join(path, 'lib', 'src', '${name.snakeCase}.freezed.dart'));

  File get testFile =>
      File(p.join(path, 'test', 'src', '${name.snakeCase}_test.dart'));

  @override
  Iterable<FileSystemEntity> get entities => {
        file,
        freezedFile,
        testFile,
      };

  Future<void> generate() async {
    await mason.generate(
      bundle: entityBundle,
      target: Directory(path),
      vars: <String, dynamic>{
        'project_name': projectName,
        'name': name,
        'output_dir': '.', // TODO rm later
        'sub_domain_name': subDomainName,
      },
    );
  }
}
