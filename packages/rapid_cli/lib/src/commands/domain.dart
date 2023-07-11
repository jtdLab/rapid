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

        await codeGenTaskGroup(packages: rootPackages);

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

        await codeGenTaskGroup(packages: rootPackages);

        await dartFormatFixTask();

        logger
          ..newLine()
          ..commandSuccess('Removed Sub Domain!');
      } else {
        throw SubInfrastructureDoesNotExistException._(name);
      }
    } else {
      throw SubDomainDoesNotExistException._(name);
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
          barrelFile.addExport(
            p.normalize(p.join('src', '${name.snakeCase}.dart')),
          );
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
            p.normalize(p.join('src', 'i_${name.snakeCase}_service.dart')),
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
          barrelFile.addExport(
            p.normalize(p.join('src', '${name.snakeCase}.dart')),
          );
        },
      );

      await codeGenTask(package: domainPackage);

      await dartFormatFixTask();

      logger
        ..newLine()
        ..commandSuccess('Added Value Object!');
    } else {
      throw EntityOrValueObjectAlreadyExistsException._(name);
    }
  }

  // TODO this does delete a value_object because they have same files
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
        'Deleting entity',
        () async {
          entity.delete();
          barrelFile.removeExport(
            p.normalize(p.join('src', '${name.snakeCase}.dart')),
          );
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
            p.normalize(p.join('src', 'i_${name.snakeCase}_service.dart')),
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

  // TODO this does delete a entity because they have same files
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
          barrelFile.removeExport(
            p.normalize(p.join('src', '${name.snakeCase}.dart')),
          );
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

class ServiceInterfaceAlreadyExistsException extends RapidException {
  final String name;

  ServiceInterfaceAlreadyExistsException._(this.name);

  @override
  String toString() {
    return 'Service Interface I${name}Service already exists.';
  }
}

class SubInfrastructureAlreadyExistsException extends RapidException {
  final String name;

  SubInfrastructureAlreadyExistsException._(this.name);

  @override
  String toString() {
    return 'The subinfrastructure "$name" already exists.';
  }
}

class SubDomainAlreadyExistsException extends RapidException {
  final String name;

  SubDomainAlreadyExistsException._(this.name);

  @override
  String toString() {
    return 'The subdomain "$name" already exists.';
  }
}

class SubInfrastructureDoesNotExistException extends RapidException {
  final String name;

  SubInfrastructureDoesNotExistException._(this.name);

  @override
  String toString() {
    return 'The subinfrastructure "$name" does not exist.';
  }
}

class SubDomainDoesNotExistException extends RapidException {
  final String name;

  SubDomainDoesNotExistException._(this.name);

  @override
  String toString() {
    return 'The subdomain "$name" does not exist.';
  }
}

class EntityOrValueObjectAlreadyExistsException extends RapidException {
  final String name;

  EntityOrValueObjectAlreadyExistsException._(this.name);

  @override
  String toString() {
    return 'Entity or ValueObject $name already exists.';
  }
}

class EntityNotFoundException extends RapidException {
  final String name;

  EntityNotFoundException._(this.name);

  @override
  String toString() {
    return 'Entity $name does not exist.';
  }
}

class ServiceInterfaceNotFoundException extends RapidException {
  final String name;

  ServiceInterfaceNotFoundException._(this.name);

  @override
  String toString() {
    return 'Service Interface I${name}Service does not exist.';
  }
}

class ValueObjectNotFoundException extends RapidException {
  final String name;

  ValueObjectNotFoundException._(this.name);

  @override
  String toString() {
    return 'Value Object $name does not exist.';
  }
}
