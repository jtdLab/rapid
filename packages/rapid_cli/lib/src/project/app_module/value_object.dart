part of '../project.dart';

class ValueObject extends FileSystemEntityCollection {
  ValueObject({
    required this.projectName,
    required this.path,
    required this.name,
    this.subDomainName,
  });

  final String projectName;

  final String path;

  final String name;

  final String? subDomainName;

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

  Future<void> generate({
    required String type,
    required String generics,
  }) async {
    await mason.generate(
      bundle: valueObjectBundle,
      target: Directory(path),
      vars: <String, dynamic>{
        'project_name': projectName,
        'name': name,
        'type': type,
        'generics': generics,
        'sub_domain_name': subDomainName,
      },
    );
  }
}
