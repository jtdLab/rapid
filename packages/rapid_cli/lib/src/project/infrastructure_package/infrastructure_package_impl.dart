import 'dart:io' as io;

import 'package:mason/mason.dart';
import 'package:path/path.dart' as p;
import 'package:rapid_cli/src/core/dart_package_impl.dart';
import 'package:rapid_cli/src/core/directory.dart';
import 'package:rapid_cli/src/core/file_system_entity_collection.dart';
import 'package:rapid_cli/src/project/core/generator_mixins.dart';
import 'package:rapid_cli/src/project/domain_package/domain_package.dart';
import 'package:rapid_cli/src/project/infrastructure_package/data_transfer_object_bundle.dart';
import 'package:rapid_cli/src/project/infrastructure_package/service_implementation_bundle.dart';
import 'package:rapid_cli/src/project/project.dart';

import 'infrastructure_package.dart';
import 'infrastructure_package_bundle.dart';

class InfrastructurePackageImpl extends DartPackageImpl
    with OverridableGenerator, Generatable
    implements InfrastructurePackage {
  InfrastructurePackageImpl({
    required DomainPackage domainPackage,
    required this.project,
  })  : _domainPackage = domainPackage,
        super(
          path: p.join(
            project.path,
            'packages',
            project.name(),
            '${project.name()}_infrastructure',
          ),
        );

  Entity _entity({
    required String name,
    required String dir,
  }) =>
      (entityOverrides ?? Entity.new)(
        name: dir,
        dir: dir,
        domainPackage: _domainPackage,
      );

  ServiceInterface _serviceInterface({
    required String entityName,
    required String dir,
  }) =>
      (serviceInterfaceOverrides ?? ServiceInterface.new)(
        name: dir,
        dir: dir,
        domainPackage: _domainPackage,
      );

  DataTransferObject _dataTransferObject({
    required String entityName,
    required String dir,
  }) =>
      (dataTransferObjectOverrides ?? DataTransferObject.new)(
        entityName: entityName,
        dir: dir,
        infrastructurePackage: this,
      );

  ServiceImplementation _serviceImplementation({
    required String name,
    required String serviceName,
    required String dir,
  }) =>
      (serviceImplementationOverrides ?? ServiceImplementation.new)(
        name: dir,
        serviceName: serviceName,
        dir: dir,
        infrastructurePackage: this,
      );

  @override
  EntityBuilder? entityOverrides;

  @override
  ServiceInterfaceBuilder? serviceInterfaceOverrides;

  @override
  DataTransferObjectBuilder? dataTransferObjectOverrides;

  @override
  ServiceImplementationBuilder? serviceImplementationOverrides;

  final DomainPackage _domainPackage;

  @override
  final Project project;

  @override
  Future<void> create({
    required Logger logger,
  }) async {
    final projectName = project.name();

    await generate(
      name: 'infrastructure package',
      bundle: infrastructurePackageBundle,
      vars: <String, dynamic>{
        'project_name': projectName,
      },
      logger: logger,
    );
  }

  @override
  Future<void> addDataTransferObject({
    required String entityName,
    required String outputDir,
    required Logger logger,
  }) async {
    final entity = _entity(name: entityName, dir: outputDir);
    if (!entity.existsAny()) {
      throw EntityDoesNotExist();
    }

    final dataTransferObject = _dataTransferObject(
      entityName: entityName,
      dir: outputDir,
    );
    if (dataTransferObject.existsAny()) {
      throw DataTransferObjectAlreadyExists();
    }

    await dataTransferObject.create(logger: logger);
  }

  @override
  Future<void> removeDataTransferObject({
    required String name,
    required String dir,
    required Logger logger,
  }) async {
    final dataTransferObject = _dataTransferObject(
      // TODO good ? maybe pass the entity
      entityName: name.replaceAll('Dto', ''),
      dir: dir,
    );
    if (!dataTransferObject.existsAny()) {
      throw DataTransferObjectDoesNotExist();
    }

    dataTransferObject.delete(logger: logger);
  }

  @override
  Future<void> addServiceImplementation({
    required String name,
    required String serviceName,
    required String outputDir,
    required Logger logger,
  }) async {
    final serviceInterface = _serviceInterface(
      entityName: serviceName,
      dir: outputDir,
    );
    if (!serviceInterface.existsAny()) {
      throw ServiceInterfaceDoesNotExist();
    }

    final serviceImplementation = _serviceImplementation(
      name: name,
      serviceName: serviceName,
      dir: outputDir,
    );
    if (serviceImplementation.existsAny()) {
      throw ServiceImplementationAlreadyExists();
    }

    await serviceImplementation.create(logger: logger);
  }

  @override
  Future<void> removeServiceImplementation({
    required String name,
    required String serviceName,
    required String dir,
    required Logger logger,
  }) async {
    final serviceImplementation = _serviceImplementation(
      name: name,
      serviceName: serviceName,
      dir: dir,
    );
    if (!serviceImplementation.existsAny()) {
      throw ServiceImplementationDoesNotExist();
    }

    serviceImplementation.delete(logger: logger);
  }
}

class DataTransferObjectImpl extends FileSystemEntityCollection
    with OverridableGenerator
    implements DataTransferObject {
  DataTransferObjectImpl({
    required String entityName,
    required String dir,
    required InfrastructurePackage infrastructurePackage,
  })  : _infrastructurePackage = infrastructurePackage,
        _dir = dir,
        _entityName = entityName,
        super([
          Directory(
            path: p.join(
              infrastructurePackage.path,
              'lib',
              'src',
              dir,
              entityName.snakeCase,
            ),
          ),
          Directory(
            path: p.join(
              infrastructurePackage.path,
              'test',
              'src',
              dir,
              entityName.snakeCase,
            ),
          ),
        ]);

  final String _entityName;
  final String _dir;
  final InfrastructurePackage _infrastructurePackage;

  @override
  Future<void> create({
    required Logger logger,
  }) async {
    final projectName = _infrastructurePackage.project.name();

    final generator = await super.generator(dataTransferObjectBundle);
    await generator.generate(
      DirectoryGeneratorTarget(io.Directory(_infrastructurePackage.path)),
      vars: <String, dynamic>{
        'project_name': projectName,
        'entity_name': _entityName,
        'output_dir': _dir,
      },
      logger: logger,
    );
  }
}

class ServiceImplementationImpl extends FileSystemEntityCollection
    with OverridableGenerator
    implements ServiceImplementation {
  ServiceImplementationImpl({
    required String name,
    required String serviceName,
    required String dir,
    required InfrastructurePackage infrastructurePackage,
  })  : _infrastructurePackage = infrastructurePackage,
        _dir = dir,
        _serviceName = serviceName,
        _name = name,
        super([
          Directory(
            path: p.join(
              infrastructurePackage.path,
              'lib',
              'src',
              dir,
              serviceName.snakeCase,
            ),
          ),
          Directory(
            path: p.join(
              infrastructurePackage.path,
              'test',
              'src',
              dir,
              serviceName.snakeCase,
            ),
          ),
        ]);

  final String _name;
  final String _serviceName;
  final String _dir;
  final InfrastructurePackage _infrastructurePackage;

  @override
  Future<void> create({
    required Logger logger,
  }) async {
    final projectName = _infrastructurePackage.project.name();

    final generator = await super.generator(serviceImplementationBundle);
    await generator.generate(
      DirectoryGeneratorTarget(io.Directory(_infrastructurePackage.path)),
      vars: <String, dynamic>{
        'project_name': projectName,
        'name': _name,
        'service_name': _serviceName,
        'output_dir': _dir,
      },
      logger: logger,
    );
  }
}
