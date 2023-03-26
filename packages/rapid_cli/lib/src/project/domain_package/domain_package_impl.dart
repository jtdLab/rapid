import 'dart:io' as io;

import 'package:mason/mason.dart';
import 'package:path/path.dart' as p;
import 'package:rapid_cli/src/core/dart_file.dart';
import 'package:rapid_cli/src/core/dart_package_impl.dart';
import 'package:rapid_cli/src/core/file_system_entity_collection.dart';
import 'package:rapid_cli/src/project/core/generator_mixins.dart';
import 'package:rapid_cli/src/project/domain_package/domain_package.dart';
import 'package:rapid_cli/src/project/domain_package/service_interface_bundle.dart';
import 'package:rapid_cli/src/project/project.dart';

import 'domain_package_bundle.dart';
import 'entity_bundle.dart';
import 'value_object_bundle.dart';

class DomainPackageImpl extends DartPackageImpl
    with OverridableGenerator, Generatable
    implements DomainPackage {
  DomainPackageImpl({
    required this.project,
  }) : super(
          path: p.join(
            project.path,
            'packages',
            project.name(),
            '${project.name()}_domain',
          ),
        );

  Entity _entity({
    required String name,
    required String dir,
  }) =>
      (entityOverrides?.call ?? Entity.new)(
        name: name,
        dir: dir,
        domainPackage: this,
      );

  ServiceInterface _serviceInterface({
    required String name,
    required String dir,
  }) =>
      (serviceInterfaceOverrides?.call ?? ServiceInterface.new)(
        name: name,
        dir: dir,
        domainPackage: this,
      );

  ValueObject _valueObject({
    required String name,
    required String dir,
  }) =>
      (valueObjectOverrides?.call ?? ValueObject.new)(
        name: name,
        dir: dir,
        domainPackage: this,
      );

  @override
  EntityBuilder? entityOverrides;

  @override
  ServiceInterfaceBuilder? serviceInterfaceOverrides;

  @override
  ValueObjectBuilder? valueObjectOverrides;

  @override
  final Project project;

  @override
  Future<void> create({required Logger logger}) async {
    final projectName = project.name();

    await generate(
      name: 'domain package',
      bundle: domainPackageBundle,
      vars: <String, dynamic>{
        'project_name': projectName,
      },
      logger: logger,
    );
  }

  @override
  Future<void> addEntity({
    required String name,
    required String outputDir,
    required Logger logger,
  }) async {
    final entity = _entity(name: name, dir: outputDir);
    if (entity.existsAny()) {
      // TODO maybe log which files
      throw EntityAlreadyExists();
    }

    await entity.create(logger: logger);
  }

  @override
  Future<void> removeEntity({
    required String name,
    required String dir,
    required Logger logger,
  }) async {
    final entity = _entity(name: name, dir: dir);
    if (!entity.existsAny()) {
      throw EntityDoesNotExist();
    }

    entity.delete(logger: logger);
  }

  @override
  Future<void> addServiceInterface({
    required String name,
    required String outputDir,
    required Logger logger,
  }) async {
    final serviceInterface = _serviceInterface(name: name, dir: outputDir);
    if (serviceInterface.existsAny()) {
      // TODO maybe log which files
      throw ServiceInterfaceAlreadyExists();
    }

    await serviceInterface.create(logger: logger);
  }

  @override
  Future<void> removeServiceInterface({
    required String name,
    required String dir,
    required Logger logger,
  }) async {
    final serviceInterface = _serviceInterface(name: name, dir: dir);
    if (!serviceInterface.existsAny()) {
      throw ServiceInterfaceDoesNotExist();
    }

    serviceInterface.delete(logger: logger);
  }

  @override
  Future<void> addValueObject({
    required String name,
    required String outputDir,
    required String type,
    required String generics,
    required Logger logger,
  }) async {
    final valueObject = _valueObject(name: name, dir: outputDir);
    if (valueObject.existsAny()) {
      // TODO maybe log which files
      throw ValueObjectAlreadyExists();
    }

    await valueObject.create(type: type, generics: generics, logger: logger);
  }

  @override
  Future<void> removeValueObject({
    required String name,
    required String dir,
    required Logger logger,
  }) async {
    final valueObject = _valueObject(name: name, dir: dir);
    if (!valueObject.existsAny()) {
      throw ValueObjectDoesNotExist();
    }

    valueObject.delete(logger: logger);
  }
}

class EntityImpl extends FileSystemEntityCollection
    with OverridableGenerator
    implements Entity {
  EntityImpl({
    required String name,
    required String dir,
    required DomainPackage domainPackage,
  })  : _name = name,
        _dir = dir,
        _domainPackage = domainPackage,
        super([
          DartFile(
            path: p.join(
              domainPackage.path,
              'lib',
              dir,
            ),
            name: name.snakeCase,
          ),
          DartFile(
            path: p.join(
              domainPackage.path,
              'lib',
              dir,
            ),
            name: '${name.snakeCase}.freezed',
          ),
          DartFile(
            path: p.join(
              domainPackage.path,
              'test',
              dir,
            ),
            name: '${name.snakeCase}_test',
          ),
        ]);

  final String _name;
  final String _dir;
  final DomainPackage _domainPackage;

  @override
  Future<void> create({
    required Logger logger,
  }) async {
    final projectName = _domainPackage.project.name();

    final generator = await super.generator(entityBundle);
    await generator.generate(
      DirectoryGeneratorTarget(io.Directory(_domainPackage.path)),
      vars: <String, dynamic>{
        'project_name': projectName,
        'name': _name,
        'output_dir': _dir,
      },
      logger: logger,
    );
  }
}

class ServiceInterfaceImpl extends FileSystemEntityCollection
    with OverridableGenerator
    implements ServiceInterface {
  ServiceInterfaceImpl({
    required String name,
    required String dir,
    required DomainPackage domainPackage,
  })  : _domainPackage = domainPackage,
        _dir = dir,
        _name = name,
        super([
          DartFile(
            path: p.join(
              domainPackage.path,
              'lib',
              dir,
            ),
            name: 'i_${name.snakeCase}_service',
          ),
          DartFile(
            path: p.join(
              domainPackage.path,
              'lib',
              dir,
            ),
            name: 'i_${name.snakeCase}_service.freezed',
          ),
        ]);

  final String _name;
  final String _dir;
  final DomainPackage _domainPackage;

  @override
  Future<void> create({
    required Logger logger,
  }) async {
    final projectName = _domainPackage.project.name();

    final generator = await super.generator(serviceInterfaceBundle);
    await generator.generate(
      DirectoryGeneratorTarget(io.Directory(_domainPackage.path)),
      vars: <String, dynamic>{
        'project_name': projectName,
        'name': _name,
        'output_dir': _dir,
      },
      logger: logger,
    );
  }
}

class ValueObjectImpl extends FileSystemEntityCollection
    with OverridableGenerator
    implements ValueObject {
  ValueObjectImpl({
    required String name,
    required String dir,
    required DomainPackage domainPackage,
  })  : _domainPackage = domainPackage,
        _dir = dir,
        _name = name,
        super([
          DartFile(
            path: p.join(
              domainPackage.path,
              'lib',
              dir,
            ),
            name: name.snakeCase,
          ),
          DartFile(
            path: p.join(
              domainPackage.path,
              'lib',
              dir,
            ),
            name: '${name.snakeCase}.freezed',
          ),
          DartFile(
            path: p.join(
              domainPackage.path,
              'test',
              dir,
            ),
            name: '${name.snakeCase}_test',
          ),
        ]);

  final String _name;
  final String _dir;
  final DomainPackage _domainPackage;

  @override
  Future<void> create({
    required String type,
    required String generics,
    required Logger logger,
  }) async {
    final projectName = _domainPackage.project.name();

    final generator = await super.generator(valueObjectBundle);
    await generator.generate(
      DirectoryGeneratorTarget(io.Directory(_domainPackage.path)),
      vars: <String, dynamic>{
        'project_name': projectName,
        'name': _name,
        'output_dir': _dir,
        'type': type,
        'generics': generics,
      },
      logger: logger,
    );
  }
}
