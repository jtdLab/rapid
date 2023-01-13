import 'package:path/path.dart' as p;
import 'package:rapid_cli/src/core/dart_package.dart';
import 'package:rapid_cli/src/project/project.dart';
import 'package:recase/recase.dart';
import 'package:universal_io/io.dart';

/// {@template domain_package}
/// Abstraction of the domain package of a Rapid project.
/// {@endtemplate}
class DomainPackage {
  /// {@macro domain_package}
  DomainPackage({required Project project})
      : _package = DartPackage(
          path: p.join('packages', project.melosFile.name(),
              '${project.melosFile.name()}_domain'),
        );

  final DartPackage _package;

  String get path => _package.path;

  Entity entity({required String name, required String dir}) =>
      Entity(name: name, dir: dir, domainPackage: this);

  ServiceInterface serviceInterface({
    required String name,
    required String dir,
  }) =>
      ServiceInterface(name: name, dir: dir, domainPackage: this);

  ValueObject valueObject({required String name, required String dir}) =>
      ValueObject(name: name, dir: dir, domainPackage: this);
}

/// {@template entity}
/// Abstraction of an entity of the domain package of a Rapid project.
/// {@endtemplate}
class Entity {
  /// {@macro entity}
  Entity({
    required String name,
    required String dir,
    required DomainPackage domainPackage,
  })  : _name = name,
        _dir = dir,
        _domainPackage = domainPackage;

  final String _name;
  final String _dir;
  final DomainPackage _domainPackage;

  late final Directory _entityDir =
      Directory(p.join(_domainPackage.path, 'lib', _dir, _name.snakeCase));
  late final _entityFile =
      File(p.join(_entityDir.path, '${_name.snakeCase}.dart'));
  late final _entityFreezedFile = File(
    p.join(_entityDir.path, '${_name.snakeCase}.freezed.dart'),
  );
  late final Directory _entityTestDir =
      Directory(p.join(_domainPackage.path, 'test', _dir, _name.snakeCase));
  late final _entityTestFile = File(
    p.join(_entityTestDir.path, '${_name.snakeCase}_test.dart'),
  );

  List<FileSystemEntity> delete() {
    final deleted = <FileSystemEntity>[];

    late FileSystemEntity entity;
    // source dir + files
    entity = _entityFile;
    if (entity.existsSync()) {
      entity.deleteSync();
      deleted.add(entity);
    }
    entity = _entityFreezedFile;
    if (entity.existsSync()) {
      entity.deleteSync();
      deleted.add(entity);
    }
    entity = _entityDir;
    if ((entity as Directory).listSync().isEmpty) {
      entity.deleteSync();
      deleted.add(entity);
    }

    // test dir + file
    entity = _entityTestFile;
    if (entity.existsSync()) {
      entity.deleteSync();
      deleted.add(entity);
    }
    entity = _entityTestDir;
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
    final entityDir = _entityDir;
    if (entityDir.existsSync() && entityDir.listSync().isEmpty) {
      return true;
    }

    final entityTestDir = _entityTestDir;
    if (entityTestDir.existsSync() && entityTestDir.listSync().isEmpty) {
      return true;
    }

    return _entityFile.existsSync() ||
        _entityFreezedFile.existsSync() ||
        _entityTestFile.existsSync();
  }
}

/// {@template service_interface}
/// Abstraction of a service interface of the domain package of a Rapid project.
/// {@endtemplate}
class ServiceInterface {
  /// {@macro service_interface}
  ServiceInterface({
    required String name,
    required String dir,
    required DomainPackage domainPackage,
  })  : _name = name,
        _dir = dir,
        _domainPackage = domainPackage;

  final String _name;
  final String _dir;
  final DomainPackage _domainPackage;

  late final Directory _serviceInterfaceDir =
      Directory(p.join(_domainPackage.path, 'lib', _dir, _name.snakeCase));
  late final File _serviceInterfaceFile = File(
      p.join(_serviceInterfaceDir.path, 'i_${_name.snakeCase}_service.dart'));
  late final File _serviceInterfaceFreezedFile = File(p.join(
      _serviceInterfaceDir.path, 'i_${_name.snakeCase}_service.freezed.dart'));

  List<FileSystemEntity> delete() {
    final deleted = <FileSystemEntity>[];

    late FileSystemEntity entity;
    // source dir + files
    entity = _serviceInterfaceFile;
    if (entity.existsSync()) {
      entity.deleteSync();
      deleted.add(entity);
    }
    entity = _serviceInterfaceFreezedFile;
    if (entity.existsSync()) {
      entity.deleteSync();
      deleted.add(entity);
    }
    entity = _serviceInterfaceDir;
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
    final serviceInterfaceDir = _serviceInterfaceDir;
    if (serviceInterfaceDir.existsSync() &&
        serviceInterfaceDir.listSync().isEmpty) {
      return true;
    }

    return _serviceInterfaceFile.existsSync() ||
        _serviceInterfaceFreezedFile.existsSync();
  }
}

/// {@template value_object}
/// Abstraction of a value object of the domain package of a Rapid project.
/// {@endtemplate}
class ValueObject {
  /// {@macro value_object}
  ValueObject({
    required String name,
    required String dir,
    required DomainPackage domainPackage,
  })  : _name = name,
        _dir = dir,
        _domainPackage = domainPackage;

  final String _name;
  final String _dir;
  final DomainPackage _domainPackage;

  late final Directory _valueObjectDir =
      Directory(p.join(_domainPackage.path, 'lib', _dir, _name.snakeCase));
  late final _valueObjectFile =
      File(p.join(_valueObjectDir.path, '${_name.snakeCase}.dart'));
  late final _valueObjectFreezedFile = File(
    p.join(_valueObjectDir.path, '${_name.snakeCase}.freezed.dart'),
  );
  late final Directory _valueObjectTestDir =
      Directory(p.join(_domainPackage.path, 'test', _dir, _name.snakeCase));
  late final _valueObjectTestFile = File(
    p.join(_valueObjectTestDir.path, '${_name.snakeCase}_test.dart'),
  );

  List<FileSystemEntity> delete() {
    final deleted = <FileSystemEntity>[];

    late FileSystemEntity entity;
    // source dir + files
    entity = _valueObjectFile;
    if (entity.existsSync()) {
      entity.deleteSync();
      deleted.add(entity);
    }
    entity = _valueObjectFreezedFile;
    if (entity.existsSync()) {
      entity.deleteSync();
      deleted.add(entity);
    }
    entity = _valueObjectDir;
    if ((entity as Directory).listSync().isEmpty) {
      entity.deleteSync();
      deleted.add(entity);
    }

    // test dir + file
    entity = _valueObjectTestFile;
    if (entity.existsSync()) {
      entity.deleteSync();
      deleted.add(entity);
    }
    entity = _valueObjectTestDir;
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
    final valueObjectDir = _valueObjectDir;
    if (valueObjectDir.existsSync() && valueObjectDir.listSync().isEmpty) {
      return true;
    }

    final valueObjectTestDir = _valueObjectTestDir;
    if (valueObjectTestDir.existsSync() &&
        valueObjectTestDir.listSync().isEmpty) {
      return true;
    }

    return _valueObjectFile.existsSync() ||
        _valueObjectFreezedFile.existsSync() ||
        _valueObjectTestFile.existsSync();
  }
}
