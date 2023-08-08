part of 'runner.dart';

mixin _DomainMixin on _Rapid {
  Future<void> domainAddSubDomain({required String name}) async {
    logger.newLine();

    final domainPackage =
        project.appModule.domainDirectory.domainPackage(name: name);
    if (!domainPackage.existsSync()) {
      final infrastructurePackage = project.appModule.infrastructureDirectory
          .infrastructurePackage(name: name);
      final rootPackages = project.rootPackages();

      if (!infrastructurePackage.existsSync()) {
        await task(
          'Creating domain package',
          () async => domainPackage.generate(),
        );

        await task(
          'Creating infrastructure package',
          () async {
            await infrastructurePackage.generate();
            for (final rootPackage in rootPackages) {
              await rootPackage.registerInfrastructurePackage(
                infrastructurePackage,
              );
            }
          },
        );

        await melosBootstrapTask(
          scope: [
            domainPackage,
            infrastructurePackage,
            ...rootPackages,
          ],
        );

        await dartRunBuildRunnerBuildDeleteConflictingOutputsTaskGroup(
          packages: rootPackages,
        );

        await dartFormatFixTask();

        logger
          ..newLine()
          ..commandSuccess('Added Sub Domain!');
      } else {
        throw SubInfrastructureAlreadyExistsException._(name);
      }
    } else {
      throw SubDomainAlreadyExistsException._(name);
    }
  }

  Future<void> domainRemoveSubDomain({required String name}) async {
    logger.newLine();

    final domainPackage =
        project.appModule.domainDirectory.domainPackage(name: name);
    if (domainPackage.existsSync()) {
      final infrastructurePackage = project.appModule.infrastructureDirectory
          .infrastructurePackage(name: name);
      final rootPackages = project.rootPackages();

      if (infrastructurePackage.existsSync()) {
        await task(
          'Deleting domain package',
          () async => domainPackage.deleteSync(recursive: true),
        );

        await task(
          'Deleting infrastructure package',
          () async {
            for (final rootPackage in rootPackages) {
              await rootPackage.unregisterInfrastructurePackage(
                infrastructurePackage,
              );
            }
            infrastructurePackage.deleteSync(recursive: true);
          },
        );

        await melosBootstrapTask(scope: rootPackages);

        await dartRunBuildRunnerBuildDeleteConflictingOutputsTaskGroup(
          packages: rootPackages,
        );

        await dartFormatFixTask();

        logger
          ..newLine()
          ..commandSuccess('Removed Sub Domain!');
      } else {
        throw SubInfrastructureNotFoundException._(name);
      }
    } else {
      throw SubDomainNotFoundException._(name);
    }
  }

  Future<void> domainSubDomainAddEntity({
    required String name,
    required String? subDomainName,
  }) async {
    logger.newLine();

    final domainPackage =
        project.appModule.domainDirectory.domainPackage(name: subDomainName);
    final entity = domainPackage.entity(name: name);
    if (!entity.existsAny) {
      final barrelFile = domainPackage.barrelFile;

      await task(
        'Creating entity',
        () async {
          await entity.generate();
          barrelFile.addExport(p.join('src', '${name.snakeCase}.dart'));
        },
      );

      await dartFormatFixTask();

      logger
        ..newLine()
        ..commandSuccess('Added Entity!');
    } else {
      throw EntityOrValueObjectAlreadyExistsException._(name);
    }
  }

  Future<void> domainSubDomainAddServiceInterface({
    required String name,
    required String? subDomainName,
  }) async {
    logger.newLine();

    final domainPackage =
        project.appModule.domainDirectory.domainPackage(name: subDomainName);
    final serviceInterface = domainPackage.serviceInterface(name: name);
    if (!serviceInterface.existsAny) {
      final barrelFile = domainPackage.barrelFile;

      await task(
        'Creating service interface',
        () async {
          await serviceInterface.generate();
          barrelFile.addExport(
            p.join('src', 'i_${name.snakeCase}_service.dart'),
          );
        },
      );

      await dartFormatFixTask();

      logger
        ..newLine()
        ..commandSuccess('Added Service Interface!');
    } else {
      throw ServiceInterfaceAlreadyExistsException._(name);
    }
  }

  Future<void> domainSubDomainAddValueObject({
    required String name,
    required String? subDomainName,
    required String type,
    required String generics,
  }) async {
    logger.newLine();

    final domainPackage =
        project.appModule.domainDirectory.domainPackage(name: subDomainName);
    final valueObject = domainPackage.valueObject(name: name);
    if (!valueObject.existsAny) {
      final barrelFile = domainPackage.barrelFile;

      await task(
        'Creating value object',
        () async {
          await valueObject.generate(type: type, generics: generics);
          barrelFile.addExport(p.join('src', '${name.snakeCase}.dart'));
        },
      );

      await dartRunBuildRunnerBuildDeleteConflictingOutputsTask(
        package: domainPackage,
      );

      await dartFormatFixTask();

      logger
        ..newLine()
        ..commandSuccess('Added Value Object!');
    } else {
      throw EntityOrValueObjectAlreadyExistsException._(name);
    }
  }

  // TODO(jtdLab): this does delete a value_object because they have same files
  Future<void> domainSubDomainRemoveEntity({
    required String name,
    required String? subDomainName,
  }) async {
    logger.newLine();

    final domainPackage =
        project.appModule.domainDirectory.domainPackage(name: subDomainName);
    final entity = domainPackage.entity(name: name);
    if (entity.existsAny) {
      final barrelFile = domainPackage.barrelFile;

      await task(
        'Deleting entity files',
        () async {
          entity.delete();
          barrelFile.removeExport(p.join('src', '${name.snakeCase}.dart'));
        },
      );

      await dartFormatFixTask();

      logger
        ..newLine()
        ..commandSuccess('Removed Entity!');
    } else {
      throw EntityNotFoundException._(name);
    }
  }

  Future<void> domainSubDomainRemoveServiceInterface({
    required String name,
    required String? subDomainName,
  }) async {
    logger.newLine();

    final domainPackage =
        project.appModule.domainDirectory.domainPackage(name: subDomainName);
    final serviceInterface = domainPackage.serviceInterface(name: name);
    if (serviceInterface.existsAny) {
      final barrelFile = domainPackage.barrelFile;

      await task(
        'Deleting service interface files',
        () async {
          serviceInterface.delete();
          barrelFile.removeExport(
            p.join('src', 'i_${name.snakeCase}_service.dart'),
          );
        },
      );

      await dartFormatFixTask();

      logger
        ..newLine()
        ..commandSuccess('Removed Service Interface!');
    } else {
      throw ServiceInterfaceNotFoundException._(name);
    }
  }

  // TODO(jtdLab): this does delete an entity because they have same files
  Future<void> domainSubDomainRemoveValueObject({
    required String name,
    required String? subDomainName,
  }) async {
    logger.newLine();

    final domainPackage =
        project.appModule.domainDirectory.domainPackage(name: subDomainName);
    final valueObject = domainPackage.valueObject(name: name);
    if (valueObject.existsAny) {
      final barrelFile = domainPackage.barrelFile;

      await task(
        'Deleting value object files',
        () async {
          valueObject.delete();
          barrelFile.removeExport(p.join('src', '${name.snakeCase}.dart'));
        },
      );

      await dartFormatFixTask();

      logger
        ..newLine()
        ..commandSuccess('Removed Value Object!');
    } else {
      throw ValueObjectNotFoundException._(name);
    }
  }
}

/// An exception thrown when a service interface already exists.
class ServiceInterfaceAlreadyExistsException extends RapidException {
  ServiceInterfaceAlreadyExistsException._(String name)
      : super('Service Interface I${name}Service already exists.');
}

/// An exception thrown when a infrastructure package already exists.
class SubInfrastructureAlreadyExistsException extends RapidException {
  SubInfrastructureAlreadyExistsException._(String name)
      : super('The subinfrastructure "$name" already exists.');
}

/// An exception thrown when a domain package already exists.
class SubDomainAlreadyExistsException extends RapidException {
  SubDomainAlreadyExistsException._(String name)
      : super('The subdomain "$name" already exists.');
}

/// An exception thrown when a infrastructure package does not exist.
class SubInfrastructureNotFoundException extends RapidException {
  SubInfrastructureNotFoundException._(String name)
      : super('Subinfrastructure "$name" not found.');
}

/// An exception thrown when a domain package does not exist.
class SubDomainNotFoundException extends RapidException {
  SubDomainNotFoundException._(String name)
      : super('Subdomain "$name" not found.');
}

/// An exception thrown when a entity or value object already exists.
class EntityOrValueObjectAlreadyExistsException extends RapidException {
  EntityOrValueObjectAlreadyExistsException._(String name)
      : super('Entity or ValueObject $name already exists.');
}

/// An exception thrown when entity does not exist.
class EntityNotFoundException extends RapidException {
  EntityNotFoundException._(String name) : super('Entity $name not found.');
}

/// An exception thrown when service interface does not exist.
class ServiceInterfaceNotFoundException extends RapidException {
  ServiceInterfaceNotFoundException._(String name)
      : super('Service Interface I${name}Service not found.');
}

/// An exception thrown when value object does not exist.
class ValueObjectNotFoundException extends RapidException {
  ValueObjectNotFoundException._(String name)
      : super('Value Object $name not found.');
}
