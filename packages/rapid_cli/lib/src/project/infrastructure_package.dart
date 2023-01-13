import 'package:path/path.dart' as p;
import 'package:rapid_cli/src/core/dart_package.dart';
import 'package:rapid_cli/src/project/project.dart';
import 'package:recase/recase.dart';
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
      DataTransferObject(
        name: name,
        dir: dir,
        infrastructurePackage: this,
      );

  ServiceImplementation serviceImplementation({
    required String name,
    required String service,
    required String dir,
  }) =>
      ServiceImplementation(
        name: name,
        service: service,
        dir: dir,
        infrastructurePackage: this,
      );
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

  late final Directory _dataTransferObjectDir = Directory(
      p.join(_infrastructurePackage.path, 'lib', 'src', _dir, _name.snakeCase));
  late final File _dataTransferObjectFile =
      File(p.join(_dataTransferObjectDir.path, '${_name.snakeCase}_dto.dart'));
  late final File _dataTransferObjectFreezedFile = File(p.join(
      _dataTransferObjectDir.path, '${_name.snakeCase}_dto.freezed.dart'));
  late final File _dataTransferObjectGFile = File(
      p.join(_dataTransferObjectDir.path, '${_name.snakeCase}_dto.g.dart'));
  late final Directory _dataTransferObjectTestDir = Directory(p.join(
      _infrastructurePackage.path, 'test', 'src', _dir, _name.snakeCase));
  late final File _dataTransferObjectTestFile = File(p.join(
      _dataTransferObjectTestDir.path, '${_name.snakeCase}_dto_test.dart'));

  List<FileSystemEntity> delete() {
    final deleted = <FileSystemEntity>[];

    late FileSystemEntity entity;
    // source dir + files
    entity = _dataTransferObjectFile;
    if (entity.existsSync()) {
      entity.deleteSync();
      deleted.add(entity);
    }
    entity = _dataTransferObjectFreezedFile;
    if (entity.existsSync()) {
      entity.deleteSync();
      deleted.add(entity);
    }
    entity = _dataTransferObjectGFile;
    if (entity.existsSync()) {
      entity.deleteSync();
      deleted.add(entity);
    }
    entity = _dataTransferObjectDir;
    if ((entity as Directory).listSync().isEmpty) {
      entity.deleteSync();
      deleted.add(entity);
    }

    // test dir + file
    entity = _dataTransferObjectTestFile;
    if (entity.existsSync()) {
      entity.deleteSync();
      deleted.add(entity);
    }
    entity = _dataTransferObjectTestDir;
    if (entity.existsSync()) {
      if ((entity as Directory).listSync().isEmpty) {
        entity.deleteSync();
        deleted.add(entity);
      }
    }

    return deleted..sort((a, b) => a.path.compareTo(b.path));
  }

  /// Wheter an underlying [FileSystemEntity] related to this exists on disk.
  bool exists() {
    final dataTransferObjectDir = _dataTransferObjectDir;
    if (dataTransferObjectDir.existsSync() &&
        dataTransferObjectDir.listSync().isEmpty) {
      return true;
    }

    final dataTransferObjectTestDir = _dataTransferObjectTestDir;
    if (dataTransferObjectTestDir.existsSync() &&
        dataTransferObjectTestDir.listSync().isEmpty) {
      return true;
    }

    return _dataTransferObjectFile.existsSync() ||
        _dataTransferObjectFreezedFile.existsSync() ||
        _dataTransferObjectFile.existsSync() ||
        _dataTransferObjectTestFile.existsSync();
  }
}

/// {@template service_implementation}
/// Abstraction of a service implementation of the infrastructure package of a Rapid project.
/// {@endtemplate}
class ServiceImplementation {
  /// {@macro service_implementation}
  ServiceImplementation({
    required String name,
    required String service,
    required String dir,
    required InfrastructurePackage infrastructurePackage,
  })  : _name = name,
        _service = service,
        _dir = dir,
        _infrastructurePackage = infrastructurePackage;

  final String _name;
  final String _service;
  final String _dir;
  final InfrastructurePackage _infrastructurePackage;

  late final Directory _serviceImplementationDir = Directory(p.join(
      _infrastructurePackage.path, 'lib', 'src', _dir, _service.snakeCase));
  late final File _serviceImplementationFile = File(p.join(
      _serviceImplementationDir.path,
      '${_name.snakeCase}_${_service.snakeCase}_service.dart'));
  late final Directory _serviceImplementationTestDir = Directory(p.join(
      _infrastructurePackage.path, 'test', 'src', _dir, _service.snakeCase));
  late final File _serviceImplementationTestFile = File(p.join(
      _serviceImplementationTestDir.path,
      '${_name.snakeCase}_${_service.snakeCase}_service_test.dart'));

  List<FileSystemEntity> delete() {
    final deleted = <FileSystemEntity>[];

    late FileSystemEntity entity;
    // source dir + files
    entity = _serviceImplementationFile;
    if (entity.existsSync()) {
      entity.deleteSync();
      deleted.add(entity);
    }
    entity = _serviceImplementationDir;
    if ((entity as Directory).listSync().isEmpty) {
      entity.deleteSync();
      deleted.add(entity);
    }

    // test dir + file
    entity = _serviceImplementationTestFile;
    if (entity.existsSync()) {
      entity.deleteSync();
      deleted.add(entity);
    }
    entity = _serviceImplementationTestDir;
    if (entity.existsSync()) {
      if ((entity as Directory).listSync().isEmpty) {
        entity.deleteSync();
        deleted.add(entity);
      }
    }

    return deleted..sort((a, b) => a.path.compareTo(b.path));
  }

  /// Wheter an underlying [FileSystemEntity] related to this exists on disk.
  bool exists() {
    final serviceImplementationDir = _serviceImplementationDir;
    if (serviceImplementationDir.existsSync() &&
        serviceImplementationDir.listSync().isEmpty) {
      return true;
    }

    final serviceImplementationTestDir = _serviceImplementationTestDir;
    if (serviceImplementationTestDir.existsSync() &&
        serviceImplementationTestDir.listSync().isEmpty) {
      return true;
    }

    return _serviceImplementationFile.existsSync() ||
        _serviceImplementationTestFile.existsSync();
  }
}
