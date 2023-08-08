part of '../project.dart';

/// {@template service_implementation}
/// Abstraction of a service implementation of a Rapid project.
///
// TODO(jtdLab): more docs.
/// {@endtemplate}
class ServiceImplementation extends FileSystemEntityCollection {
  /// {@macro service_implementation}
  ServiceImplementation({
    required this.projectName,
    required this.path,
    required this.name,
    required this.serviceInterfaceName,
    this.subInfrastructureName,
  });

  /// The name of the project this service implementation is part of.
  final String projectName;

  /// The path of the infrastructure package this service implementation is
  /// part of.
  final String path;

  /// The name of this service implementation.
  final String name;

  /// The name of the service interface this service implementation is
  /// related  to.
  final String serviceInterfaceName;

  /// The name of the infrastructure package this service implementation is
  /// part of.
  final String? subInfrastructureName;

  /// The `lib/src/<name>_<service-interface-name>_service.dart` file.
  File get file => File(
        p.join(
          path,
          'lib',
          'src',
          '${name.snakeCase}_${serviceInterfaceName.snakeCase}_service.dart',
        ),
      );

  /// The `test/src/<name>_<service-interface-name>_service_test.dart` file.
  File get testFile => File(
        p.join(
          path,
          'test',
          'src',
          // ignore: lines_longer_than_80_chars
          '${name.snakeCase}_${serviceInterfaceName.snakeCase}_service_test.dart',
        ),
      );

  @override
  Iterable<FileSystemEntity> get entities => {
        file,
        testFile,
      };

  /// Generate this service implementation on disk.
  Future<void> generate() async {
    await mason.generate(
      bundle: serviceImplementationBundle,
      target: Directory(path),
      vars: <String, dynamic>{
        'project_name': projectName,
        'name': name,
        'output_dir': '.',
        'output_dir_is_cwd': true,
        'service_interface_name': serviceInterfaceName,
        'sub_infrastructure_name': subInfrastructureName,
        'has_sub_infrastructure_name': subInfrastructureName != null,
      },
    );
  }
}
