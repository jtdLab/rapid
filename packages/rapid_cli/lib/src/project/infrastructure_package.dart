import 'package:path/path.dart' as p;
import 'package:rapid_cli/src/core/dart_package.dart';
import 'package:rapid_cli/src/project/project.dart';
import 'package:universal_io/io.dart';

/// {@template domain_package}
/// Abstraction of the domain package of a Rapid project.
/// {@endtemplate}
class InfrastructurePackage {
  /// {@macro domain_package}
  InfrastructurePackage({required Project project})
      : _package = DartPackage(
          path: p.join('packages', project.melosFile.name(),
              '${project.melosFile.name()}_infrastructure'),
        );

  final DartPackage _package;

  String get path => _package.path;

  DataTransferObject dataTransferObject({
    required String name,
    required String dir,
  }) =>
      DataTransferObject(name: name, dir: dir, infrastructurePackage: this);

  ServiceImplementation serviceImplementation({
    required String name,
    required String dir,
  }) =>
      ServiceImplementation(name: name, dir: dir, infrastructurePackage: this);
}

/// {@template data_transfer_object}
/// Abstraction of a data transfer object of the infrastructure package of a Rapid project.
/// {@endtemplate}
class DataTransferObject {
  /// {@macro data_transfer_object}
  DataTransferObject({
    required String name,
    required String dir,
    required InfrastructurePackage infrastructurePackage,
  })  : _name = name,
        _dir = dir,
        _infrastructurePackage = infrastructurePackage;

  final String _name;
  final String _dir;
  final InfrastructurePackage _infrastructurePackage;

  List<FileSystemEntity> delete() {
    final deleted = <FileSystemEntity>[];

    late FileSystemEntity entity;
    // TODO

    return deleted;
  }

  bool exists() {
    // TODO
    throw UnimplementedError();
  }
}

/// {@template service_implementation}
/// Abstraction of a service implementation of the infrastructure package of a Rapid project.
/// {@endtemplate}
class ServiceImplementation {
  /// {@macro service_implementation}
  ServiceImplementation({
    required String name,
    required String dir,
    required InfrastructurePackage infrastructurePackage,
  })  : _name = name,
        _dir = dir,
        _infrastructurePackage = infrastructurePackage;

  final String _name;
  final String _dir;
  final InfrastructurePackage _infrastructurePackage;

  List<FileSystemEntity> delete() {
    final deleted = <FileSystemEntity>[];

    late FileSystemEntity entity;
    // TODO

    return deleted;
  }

  bool exists() {
    // TODO
    throw UnimplementedError();
  }
}
