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
            barrelFile.addExport(
              p.join('src', '${entityName.snakeCase}_dto.dart'),
            );
          },
        );

        await dartFormatFixTask();

        logger
          ..newLine()
          ..commandSuccess('Added Data Transfer Object!');
      } else {
        throw DataTransferObjectAlreadyExistsException._(entityName);
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
            barrelFile.addExport(
              p.join(
                'src',
                '${name.snakeCase}_${serviceInterfaceName.snakeCase}_service.dart',
              ),
            );
          },
        );

        await flutterPubRunBuildRunnerBuildDeleteConflictingOutputsTask(
          package: infrastructurePackage,
        );

        await dartFormatFixTask();

        // TODO better hint containg related service etc
        logger
          ..newLine()
          ..commandSuccess('Added Service Implementation!');
      } else {
        throw ServiceImplementationAlreadyExistsException._(
          name,
          serviceInterfaceName,
        );
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
          barrelFile.removeExport(
            p.join('src', '${entityName.snakeCase}_dto.dart'),
          );
          dataTransferObject.delete();
        },
      );

      await dartFormatFixTask();

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
          barrelFile.removeExport(
            p.join(
              'src',
              '${name.snakeCase}_${serviceInterfaceName.snakeCase}_service.dart',
            ),
          );
          serviceImplementation.delete();
        },
      );

      await flutterPubRunBuildRunnerBuildDeleteConflictingOutputsTask(
        package: infrastructurePackage,
      );

      await dartFormatFixTask();

      logger
        ..newLine()
        ..commandSuccess('Removed Service Implementation!');
    } else {
      throw ServiceImplementationNotFoundException._(
        name,
        serviceInterfaceName,
      );
    }
  }
}

class DataTransferObjectAlreadyExistsException extends RapidException {
  DataTransferObjectAlreadyExistsException._(String name)
      : super('Data Transfer Object ${name}Dto already exists.');
}

class ServiceImplementationAlreadyExistsException extends RapidException {
  ServiceImplementationAlreadyExistsException._(String name, String serviceName)
      : super(
            'Service Implementation $name${serviceName}Service already exists.');
}

class ServiceImplementationNotFoundException extends RapidException {
  ServiceImplementationNotFoundException._(String name, String serviceName)
      : super('Service Implementation $name${serviceName}Service not found.');
}

class DataTransferObjectNotFoundException extends RapidException {
  DataTransferObjectNotFoundException._(String name)
      : super('DataTransferObject ${name}Dto not found.');
}
