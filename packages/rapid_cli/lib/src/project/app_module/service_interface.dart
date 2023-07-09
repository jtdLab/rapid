part of '../project.dart';

class ServiceInterface extends FileSystemEntityCollection {
  ServiceInterface({
    required this.projectName,
    required this.path,
    required this.name,
  });

  final String projectName;

  final String path;

  final String name;

  File get file => File(p.join(path, 'lib', 'src', 'i_${name}_service.dart'));

  File get freezedFile =>
      File(p.join(path, 'lib', 'src', 'i_${name}_service.freezed.dart'));

  @override
  Iterable<FileSystemEntity> get entities => {
        file,
        freezedFile,
      };

  Future<void> generate() async {
    await mason.generate(
      bundle: serviceInterfaceBundle,
      target: Directory(path),
      vars: <String, dynamic>{
        'project_name': projectName,
        'name': name,
      },
    );
  }
}
