part of '../project.dart';

/// {@template data_transfer_object}
/// Abstraction of a data transfer object of a Rapid project.
///
// TODO(jtdLab): more docs.
/// {@endtemplate}
class DataTransferObject extends FileSystemEntityCollection {
  /// {@macro data_transfer_object}
  DataTransferObject({
    required this.projectName,
    required this.path,
    required this.entityName,
    this.subInfrastructureName,
  });

  /// The name of the project this data transfer object is part of.
  final String projectName;

  /// The path of the infrastructure package this data transfer object is
  /// part of.
  final String path;

  /// The name of entity this data transfer object is related to.
  final String entityName;

  /// The name of the infrastructure package this data transfer object is
  /// part of.
  final String? subInfrastructureName;

  /// The `lib/src/<entity-name>_dto.dart` file.
  File get file =>
      File(p.join(path, 'lib', 'src', '${entityName.snakeCase}_dto.dart'));

  /// The `lib/src/<entity-name>_dto.freezed.dart` file.
  File get freezedFile => File(
        p.join(path, 'lib', 'src', '${entityName.snakeCase}_dto.freezed.dart'),
      );

  /// The `lib/src/<entity-name>_dto.g.dart` file.
  File get gFile =>
      File(p.join(path, 'lib', 'src', '${entityName.snakeCase}_dto.g.dart'));

  /// The `test/src/<entity-name>_dto_test.dart` file.
  File get testFile => File(
        p.join(path, 'test', 'src', '${entityName.snakeCase}_dto_test.dart'),
      );

  @override
  Iterable<FileSystemEntity> get entities => {
        file,
        freezedFile,
        gFile,
        testFile,
      };

  /// Generate this data transfer object on disk.
  Future<void> generate() async {
    await mason.generate(
      bundle: dataTransferObjectBundle,
      target: Directory(path),
      vars: <String, dynamic>{
        'project_name': projectName,
        'entity_name': entityName,
        'output_dir': '.',
        'output_dir_is_cwd': true,
        'sub_infrastructure_name': subInfrastructureName,
        'has_sub_infrastructure_name': subInfrastructureName != null,
      },
    );
  }
}
