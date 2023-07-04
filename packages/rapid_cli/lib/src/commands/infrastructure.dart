part of 'runner.dart';

mixin _InfrastructureMixin on _Rapid {
  Future<void> infrastructureSubInfrastructureAddDataTransferObject({
    required String? subInfrastructureName,
    required String entityName,
  }) async {
    logger.newLine();

    final entity = project.appModule.domainDirectory
        .domainPackage(name: subInfrastructureName)
        .entity(name: entityName);
    if (entity.existsAll) {
      final infrastructurePackage = project.appModule.infrastructureDirectory
          .infrastructurePackage(name: subInfrastructureName);
      final dataTransferObject =
          infrastructurePackage.dataTransferObject(entityName: entityName);
      if (!dataTransferObject.existsAny) {
        final barrelFile = infrastructurePackage.barrelFile;

        await task(
          'Creating data transfer object',
          () async {
            await dataTransferObject.generate();
            // TODO cleaner?
            barrelFile.addExport(
              p.normalize(p.join('src', '${entityName.snakeCase}_dto.dart')),
            );
          },
        );

        await dartFormatFix(package: infrastructurePackage);

        logger
          ..newLine()
          ..commandSuccess('Added Data Transfer Object!');
      } else {
        DataTransferObjectAlreadyExistsException._(entityName);
      }
    } else {
      throw EntityNotFoundException._(entityName);
    }
  }

  Future<void> infrastructureSubInfrastructureAddServiceImplementation({
    required String name,
    required String? subInfrastructureName,
    required String serviceInterfaceName,
  }) async {
    logger.newLine();

    final serviceInterface = project.appModule.domainDirectory
        .domainPackage(name: subInfrastructureName)
        .serviceInterface(name: serviceInterfaceName);
    if (serviceInterface.existsAll) {
      final infrastructurePackage = project.appModule.infrastructureDirectory
          .infrastructurePackage(name: subInfrastructureName);
      final serviceImplementation = infrastructurePackage.serviceImplementation(
        name: name,
        serviceInterfaceName: serviceInterfaceName,
      );
      if (!serviceImplementation.existsAny) {
        final barrelFile = infrastructurePackage.barrelFile;

        await task(
          'Creating service implementation',
          () async {
            await serviceImplementation.generate();
            // TODO cleaner?
            barrelFile.addExport(
              p.normalize(
                p.join(
                  'src',
                  '${name.snakeCase}_${serviceInterfaceName.snakeCase}_service.dart',
                ),
              ),
            );
          },
        );

        await dartFormatFix(package: infrastructurePackage);

        // TODO better hint containg related service etc
        logger
          ..newLine()
          ..commandSuccess('Added Service Implementation!');
      } else {
        throw ServiceImplementationAlreadyExistsException._(
            name, serviceInterfaceName);
      }
    } else {
      throw ServiceInterfaceNotFoundException._(serviceInterfaceName);
    }
  }

  Future<void> infrastructureSubInfrastructureRemoveDataTransferObject({
    required String? subInfrastructureName,
    required String entityName,
  }) async {
    logger.newLine();

    final infrastructurePackage = project.appModule.infrastructureDirectory
        .infrastructurePackage(name: subInfrastructureName);
    final dataTransferObject = infrastructurePackage.dataTransferObject(
      entityName: entityName,
    );
    if (dataTransferObject.existsAny) {
      final barrelFile = infrastructurePackage.barrelFile;

      await task(
        'Deleting data transfer object',
        () async {
          dataTransferObject.delete();
          // TODO cleaner?
          barrelFile.removeExport(
            p.normalize(p.join('src', '${entityName.snakeCase}_dto.dart')),
          );
        },
      );

      logger
        ..newLine()
        ..commandSuccess('Removed Data Transfer Object!');
    } else {
      throw DataTransferObjectNotFoundException._(entityName);
    }
  }

  Future<void> infrastructureSubInfrastructureRemoveServiceImplementation({
    required String name,
    required String? subInfrastructureName,
    required String serviceInterfaceName,
  }) async {
    logger.newLine();

    final infrastructurePackage = project.appModule.infrastructureDirectory
        .infrastructurePackage(name: subInfrastructureName);
    final serviceImplementation = infrastructurePackage.serviceImplementation(
      name: name,
      serviceInterfaceName: serviceInterfaceName,
    );
    if (serviceImplementation.existsAny) {
      final barrelFile = infrastructurePackage.barrelFile;

      await task(
        'Deleting service implementation',
        () async {
          serviceImplementation.delete();
          barrelFile.removeExport(
            p.normalize(
              p.join(
                'src',
                '${name.snakeCase}_${serviceInterfaceName.snakeCase}_service.dart',
              ),
            ),
          );
        },
      );

      logger
        ..newLine()
        ..commandSuccess('Removed Service Implementation!');
    } else {
      throw ServiceImplementationNotFoundException._(
          name, serviceInterfaceName);
    }
  }
}

class DataTransferObjectAlreadyExistsException extends RapidException {
  final String name;

  DataTransferObjectAlreadyExistsException._(this.name);

  @override
  String toString() {
    return 'Data Transfer Object ${name}Dto already exists.';
  }
}

class ServiceImplementationAlreadyExistsException extends RapidException {
  final String name;
  final String serviceName;

  ServiceImplementationAlreadyExistsException._(this.name, this.serviceName);

  @override
  String toString() {
    return 'Service Implementation $name${serviceName}Service already exists.';
  }
}

class ServiceImplementationNotFoundException extends RapidException {
  final String name;
  final String serviceName;

  ServiceImplementationNotFoundException._(this.name, this.serviceName);

  @override
  String toString() {
    return 'Service Implementation $name${serviceName}Service does not exist.';
  }
}

class DataTransferObjectNotFoundException extends RapidException {
  final String name;

  DataTransferObjectNotFoundException._(this.name);

  @override
  String toString() {
    return 'DataTransferObject ${name}Dto not found.';
  }
}
