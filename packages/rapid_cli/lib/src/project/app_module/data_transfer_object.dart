part of '../project.dart';

class DataTransferObject extends FileSystemEntityCollection {
  DataTransferObject({
    required this.projectName,
    required this.path,
    required this.entityName,
    this.subInfrastructureName,
  });

  final String projectName;

  final String path;

  final String entityName;

  final String? subInfrastructureName;

  File get file =>
      File(p.join(path, 'lib', 'src', '${entityName.snakeCase}_dto.dart'));

  File get freezedFile => File(
      p.join(path, 'lib', 'src', '${entityName.snakeCase}_dto.freezed.dart'));

  File get gFile =>
      File(p.join(path, 'lib', 'src', '${entityName.snakeCase}_dto.g.dart'));

  File get testFile => File(
      p.join(path, 'test', 'src', '${entityName.snakeCase}_dto_test.dart'));

  @override
  Iterable<FileSystemEntity> get entities => {
        file,
        freezedFile,
        gFile,
        testFile,
      };

  Future<void> generate() async {
    await mason.generate(
      bundle: dataTransferObjectBundle,
      target: Directory(path),
      vars: <String, dynamic>{
        'project_name': projectName,
        'entity_name': entityName,
        'output_dir': '.', // TODO rm later
        'sub_infrastructure_name': subInfrastructureName,
      },
    );
  }
}
