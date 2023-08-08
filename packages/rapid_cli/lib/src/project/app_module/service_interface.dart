part of '../project.dart';

/// {@template service_interface}
/// Abstraction of a service interface of a Rapid project.
///
// TODO(jtdLab): more docs.
/// {@endtemplate}
class ServiceInterface extends FileSystemEntityCollection {
  /// {@macro service_interface}
  ServiceInterface({
    required this.projectName,
    required this.path,
    required this.name,
  });

  /// The name of the project this service interface is part of.
  final String projectName;

  /// The path of the domain package this service interface is part of.
  final String path;

  /// The name of this service interface.
  final String name;

  /// The `lib/src/i_<name>_service.dart` file.
  File get file =>
      File(p.join(path, 'lib', 'src', 'i_${name.snakeCase}_service.dart'));

  /// The `lib/src/i_<name>_service.freezed.dart` file.
  File get freezedFile => File(
        p.join(path, 'lib', 'src', 'i_${name.snakeCase}_service.freezed.dart'),
      );

  @override
  Iterable<FileSystemEntity> get entities => {
        file,
        freezedFile,
      };

  /// Generate this service interface on disk.
  Future<void> generate() async {
    await mason.generate(
      bundle: serviceInterfaceBundle,
      target: Directory(path),
      vars: <String, dynamic>{
        'project_name': projectName,
        'name': name,
        'output_dir': '.',
      },
    );
  }
}
