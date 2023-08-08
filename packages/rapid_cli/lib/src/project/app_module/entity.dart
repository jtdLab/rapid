part of '../project.dart';

/// {@template entity}
/// Abstraction of an entity of a Rapid project.
///
// TODO(jtdLab): more docs.
/// {@endtemplate}
class Entity extends FileSystemEntityCollection {
  /// {@macro entity}
  Entity({
    required this.projectName,
    required this.path,
    required this.name,
    this.subDomainName,
  });

  /// The name of the project this entity is part of.
  final String projectName;

  /// The path of the domain package this entity is part of.
  final String path;

  /// The name of this entity.
  final String name;

  /// The name of the domain package this value object is part of.
  final String? subDomainName;

  /// The `lib/src/<name>.dart` file.
  File get file => File(p.join(path, 'lib', 'src', '${name.snakeCase}.dart'));

  /// The `lib/src/<name>.freezed.dart` file.
  File get freezedFile =>
      File(p.join(path, 'lib', 'src', '${name.snakeCase}.freezed.dart'));

  /// The `test/src/<name>_test.dart` file.
  File get testFile =>
      File(p.join(path, 'test', 'src', '${name.snakeCase}_test.dart'));

  @override
  Iterable<FileSystemEntity> get entities => {
        file,
        freezedFile,
        testFile,
      };

  /// Generate this entity on disk.
  Future<void> generate() async {
    await mason.generate(
      bundle: entityBundle,
      target: Directory(path),
      vars: <String, dynamic>{
        'project_name': projectName,
        'name': name,
        'output_dir': '.',
        'output_dir_is_cwd': true,
        'sub_domain_name': subDomainName,
        'has_sub_domain_name': subDomainName != null,
      },
    );
  }
}
