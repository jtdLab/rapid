part of 'runner.dart';

mixin _InfrastructureMixin on _Rapid {
  Future<void> infrastructureSubInfrastructureAddDataTransferObject({
    required String? subInfrastructureName,
    required String entityName,
    required String outputDir,
  }) async {
    logger
      ..command(
        'rapid infrastructure $subInfrastructureName add data_transfer_object',
      )
      ..newLine();

    final entity = project.domainDirectory
        .domainPackage(name: subInfrastructureName)
        .entity(name: entityName, dir: outputDir);
    if (entity.existsAll()) {
      final infrastructurePackage = project.infrastructureDirectory
          .infrastructurePackage(name: subInfrastructureName);
      final dataTransferObject = infrastructurePackage.dataTransferObject(
        name: entityName,
        dir: outputDir,
      );
      if (!dataTransferObject.existsAny()) {
        final barrelFile = infrastructurePackage.barrelFile;

        await task(
          'Creating data transfer object files',
          () async => dataTransferObject.create(),
        );

        // TODO better title
        await task(
          'Adding exports to ${p.relative(barrelFile.path, from: project.path)} ',
          () => barrelFile.addExport(
            p.normalize(
              p.join('src', outputDir, '${entityName.snakeCase}_dto.dart'),
            ),
          ),
        );

        await dartFormatFix(infrastructurePackage);

        logger
          ..newLine()
          ..success('Success $checkLabel');
      } else {
        _logAndThrow(
          RapidInfrastructureException._dataTransferObjectAlreadyExists(
            entityName,
          ),
        );
      }
    } else {
      _logAndThrow(
        RapidInfrastructureException._entityNotFound(entityName),
      );
    }
  }

  Future<void> infrastructureSubInfrastructureAddServiceImplementation({
    required String name,
    required String? subInfrastructureName,
    required String serviceName,
    required String outputDir,
  }) async {
    logger
      ..command(
        'rapid infrastructure $subInfrastructureName add service_implementation',
      )
      ..newLine();

    final serviceInterface = project.domainDirectory
        .domainPackage(name: subInfrastructureName)
        .serviceInterface(name: serviceName, dir: outputDir);
    if (serviceInterface.existsAll()) {
      final infrastructurePackage = project.infrastructureDirectory
          .infrastructurePackage(name: subInfrastructureName);
      final serviceImplementation = infrastructurePackage.serviceImplementation(
        name: name,
        serviceName: serviceName,
        dir: outputDir,
      );
      if (!serviceImplementation.existsAny()) {
        final barrelFile = infrastructurePackage.barrelFile;

        await task(
          'Creating service implementation files',
          () async => serviceImplementation.create(),
        );

        // TODO better title
        await task(
          'Adding exports to ${p.relative(barrelFile.path, from: project.path)} ',
          () => barrelFile.addExport(
            p.normalize(
              p.join(
                'src',
                outputDir,
                '${name.snakeCase}_${serviceName.snakeCase}_service.dart',
              ),
            ),
          ),
        );

        await dartFormatFix(infrastructurePackage);

        // TODO better hint containg related service etc
        logger
          ..newLine()
          ..success('Success $checkLabel');
      } else {
        _logAndThrow(
          RapidInfrastructureException._serviceImplementationAlreadyExists(
            name,
            serviceName,
          ),
        );
      }
    } else {
      _logAndThrow(
        RapidInfrastructureException._serviceInterfaceNotFound(serviceName),
      );
    }
  }

  Future<void> infrastructureSubInfrastructureRemoveDataTransferObject({
    required String? subInfrastructureName,
    required String entityName,
    required String dir,
  }) async {
    logger
      ..command(
        'rapid infrastructure $subInfrastructureName remove data_transfer_object',
      )
      ..newLine();

    final infrastructurePackage = project.infrastructureDirectory
        .infrastructurePackage(name: subInfrastructureName);
    final dataTransferObject = infrastructurePackage.dataTransferObject(
      name: entityName,
      dir: dir,
    );
    if (dataTransferObject.existsAny()) {
      final barrelFile = infrastructurePackage.barrelFile;

      await task(
        'Deleting data transfer object files',
        () async => dataTransferObject.delete(),
      );

      // TODO better title
      await task(
        'Removing exports from ${p.relative(barrelFile.path, from: project.path)} ',
        () => barrelFile.removeExport(
          p.normalize(p.join('src', dir, '${entityName.snakeCase}_dto.dart')),
        ),
      );

      logger
        ..newLine()
        ..success('Success $checkLabel');
    } else {
      _logAndThrow(
        RapidInfrastructureException._dataTransferObjectNotFound(
          entityName,
        ),
      );
    }
  }

  Future<void> infrastructureSubInfrastructureRemoveServiceImplementation({
    required String name,
    required String? subInfrastructureName,
    required String serviceName,
    required String dir,
  }) async {
    logger
      ..command(
        'rapid infrastructure $subInfrastructureName remove service_implementation',
      )
      ..newLine();

    final infrastructurePackage = project.infrastructureDirectory
        .infrastructurePackage(name: subInfrastructureName);
    final serviceImplementation = infrastructurePackage.serviceImplementation(
      name: name,
      serviceName: serviceName,
      dir: dir,
    );
    if (serviceImplementation.existsAny()) {
      final barrelFile = infrastructurePackage.barrelFile;

      await task(
        'Deleting service implementation files',
        () async => serviceImplementation.delete(),
      );

      // TODO better title
      await task(
        'Removing exports from ${p.relative(barrelFile.path, from: project.path)} ',
        () => barrelFile.removeExport(
          p.normalize(
            p.join(
              'src',
              dir,
              '${name.snakeCase}_${serviceName.snakeCase}_service.dart',
            ),
          ),
        ),
      );

      logger
        ..newLine()
        ..success('Success $checkLabel');
    } else {
      _logAndThrow(
        RapidInfrastructureException._serviceImplementationNotFound(
          name,
          serviceName,
        ),
      );
    }
  }
}

class RapidInfrastructureException extends RapidException {
  RapidInfrastructureException._(super.message);

  factory RapidInfrastructureException._dataTransferObjectAlreadyExists(
    String name,
  ) {
    return RapidInfrastructureException._(
      'Data Transfer Object ${name}Dto already exists.',
    );
  }

  factory RapidInfrastructureException._entityNotFound(
    String name,
  ) {
    return RapidInfrastructureException._(
      'Entity $name does not exist.',
    );
  }

  factory RapidInfrastructureException._serviceImplementationAlreadyExists(
    String name,
    String serviceName,
  ) {
    return RapidInfrastructureException._(
      'Service Implementation $name${serviceName}Service already exists.',
    );
  }

  factory RapidInfrastructureException._serviceInterfaceNotFound(
    String name,
  ) {
    return RapidInfrastructureException._(
      'Service Interface I${name}Service does not exist.',
    );
  }

  factory RapidInfrastructureException._serviceImplementationNotFound(
    String name,
    String serviceName,
  ) {
    return RapidInfrastructureException._(
      'Service Implementation $name${serviceName}Service does not exist.',
    );
  }

  factory RapidInfrastructureException._dataTransferObjectNotFound(
    String name,
  ) {
    return RapidInfrastructureException._(
      'DataTransferObject ${name}Dto not found.',
    );
  }

  @override
  String toString() {
    return 'RapidInfrastructureException: $message';
  }
}
