part of '../../project.dart';

class ServiceImplementation extends FileSystemEntityCollection {
  ServiceImplementation({
    required this.projectName,
    required this.path,
    required this.name,
    required this.serviceInterfaceName,
    this.subInfrastructureName,
  });

  final String projectName;

  final String path;

  final String name;

  final String serviceInterfaceName;

  final String? subInfrastructureName;

  File get file => File(p.join(
      path, 'lib', 'src', '${name}_${serviceInterfaceName}_service.dart'));

  File get testFile => File(p.join(
      path, 'test', 'src' '${name}_${serviceInterfaceName}_service_test.dart'));

  @override
  Iterable<FileSystemEntity> get entities => {
        file,
        testFile,
      };

  Future<void> generate() async {
    await mason.generate(
      bundle: serviceImplementationBundle,
      target: Directory(path),
      vars: <String, dynamic>{
        'project_name': projectName,
        'name': name,
        'service_interface_name': serviceInterfaceName,
        'sub_infrastructure_name': subInfrastructureName,
      },
    );
  }
}