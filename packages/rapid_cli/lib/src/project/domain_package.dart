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

  /// Removes the entity with [name] located at lib/[dir]/ .
  void removeEntity({
    required String name,
    required String dir,
  }) {
    /* // TODO seperate entity class that hold all this file the rm logic
    final entityDir = _entityDir(name, dir);
    final entityFile = File(p.join(entityDir.path, '${name.snakeCase}.dart'));
    final entityFreezedFile = File(
      p.join(entityDir.path, '${name.snakeCase}.freezed.dart'),
    );
    final entityTestDir = _entityTestDir(name, dir);
    final entityTestFile = File(
      p.join(entityTestDir.path, '${name.snakeCase}_test.dart'),
    );

    if (entityDir.existsSync()) {
      if (entityFile.existsSync()) {
        entityFile.deleteSync();
      }
      if (entityFreezedFile.existsSync()) {
        entityFreezedFile.deleteSync();
      }

      if (entityDir.listSync().isEmpty) {
        entityDir.deleteSync();
      }
    }

    if (entityTestDir.existsSync()) {
      if (entityTestFile.existsSync()) {
        entityTestFile.deleteSync();
      }

      if (entityTestDir.listSync().isEmpty) {
        entityTestDir.deleteSync();
      }
    } */
  }

  /// Removes the service interface with [name] located at lib/[dir]/ .
  void removeServiceInterface({
    required String name,
    required String dir,
  }) {
    /*  // TODO seperate service interface class that hold all this file and the rm logic
    final serviceInterfaceDir = _serviceInterfaceDir(name, dir);
    final serviceInterfaceFile = File(
        p.join(serviceInterfaceDir.path, 'i_${name.snakeCase}_service.dart'));
    final serviceInterfaceFreezedFile = File(p.join(
        serviceInterfaceDir.path, 'i_${name.snakeCase}_service.freezed.dart'));

    if (serviceInterfaceDir.existsSync()) {
      if (serviceInterfaceFile.existsSync()) {
        serviceInterfaceFile.deleteSync();
      }

      if (serviceInterfaceFreezedFile.existsSync()) {
        serviceInterfaceFreezedFile.deleteSync();
      }

      if (serviceInterfaceDir.listSync().isEmpty) {
        serviceInterfaceDir.deleteSync();
      } 
    }*/
  }

  /// Removes the value object with [name] located at lib/[dir]/ .
  void removeValueObject({
    required String name,
    required String dir,
  }) {
    /*  // TODO seperate value object class that hold all this file the rm logic
    final valueObjectDir = _valueObjectDir(name, dir);
    final valueObjectFile =
        File(p.join(valueObjectDir.path, '${name.snakeCase}.dart'));
    final valueObjectFreezedFile = File(
      p.join(valueObjectDir.path, '${name.snakeCase}.freezed.dart'),
    );
    final valueObjectTestDir = _valueObjectTestDir(name, dir);
    final valueObjectTestFile = File(
      p.join(valueObjectTestDir.path, '${name.snakeCase}_test.dart'),
    );

    if (valueObjectDir.existsSync()) {
      if (valueObjectFile.existsSync()) {
        valueObjectFile.deleteSync();
      }
      if (valueObjectFreezedFile.existsSync()) {
        valueObjectFreezedFile.deleteSync();
      }

      if (valueObjectDir.listSync().isEmpty) {
        valueObjectDir.deleteSync();
      }
    }

    if (valueObjectTestDir.existsSync()) {
      if (valueObjectTestFile.existsSync()) {
        valueObjectTestFile.deleteSync();
      }

      if (valueObjectTestDir.listSync().isEmpty) {
        valueObjectTestDir.deleteSync();
      }
    } */
  }
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
    if (_entityFile.existsSync()) {
      entity = _entityFile;
      entity.deleteSync();
      deleted.add(entity);
    }
    if (_entityFreezedFile.existsSync()) {
      entity = _entityFreezedFile;
      entity.deleteSync();
      deleted.add(entity);
    }
    if (_entityDir.listSync().isEmpty) {
      entity = _entityDir;
      entity.deleteSync();
      deleted.add(entity);
    }

    // test dir + file
    if (_entityTestFile.existsSync()) {
      entity = _entityTestFile;
      entity.deleteSync();
      deleted.add(entity);
    }
    if (_entityTestDir.listSync().isEmpty) {
      entity = _entityTestDir;
      entity.deleteSync();
      deleted.add(entity);
    }

    return deleted..sort((a, b) => a.path.compareTo(b.path));
  }

  /// Wheter an underlying [FileSystemEntity] related to this exists on disk.
  bool exists() {
    if (_entityDir.existsSync() && _entityDir.listSync().isEmpty) {
      return true;
    }

    if (_entityTestDir.existsSync() && _entityTestDir.listSync().isEmpty) {
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
