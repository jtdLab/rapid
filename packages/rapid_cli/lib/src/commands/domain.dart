part of 'runner.dart';

mixin _DomainMixin on _Rapid {
  Future<void> domainAddSubDomain({required String name}) async {
    logger
      ..command('rapid domain add sub_domain')
      ..newLine();

    final domainPackage = project.domainDirectory.domainPackage(name: name);
    if (!domainPackage.exists()) {
      final infrastructurePackage =
          project.infrastructureDirectory.infrastructurePackage(name: name);
      if (!infrastructurePackage.exists()) {
        await task(
          'Creating domain package files',
          () async => domainPackage.create(),
        );

        await task(
          'Creating infrastructure package files',
          () async => infrastructurePackage.create(),
        );

        final rootPackages = await task(
          'Registering infrastructure package in platform root packages',
          () async {
            final rootPackages = project.rootPackages;
            for (final rootPackage in rootPackages) {
              await rootPackage.registerInfrastructurePackage(
                infrastructurePackage,
              );
            }
            return rootPackages;
          },
        );

        await bootstrap(
          packages: [domainPackage, infrastructurePackage, ...rootPackages],
        );

        await codeGen(packages: rootPackages);

        await dartFormatFix(project);

        logger
          ..newLine()
          ..success('Success $checkLabel');
      } else {
        _logAndThrow(
          RapidDomainException._subInfrastructureAlreadyExists(name),
        );
      }
    } else {
      _logAndThrow(
        RapidDomainException._subDomainAlreadyExists(name),
      );
    }
  }

  Future<void> domainRemoveSubDomain({required String name}) async {
    logger
      ..command('rapid domain remove sub_domain')
      ..newLine();

    final domainPackage = project.domainDirectory.domainPackage(name: name);
    if (domainPackage.exists()) {
      final infrastructurePackage =
          project.infrastructureDirectory.infrastructurePackage(name: name);
      if (infrastructurePackage.exists()) {
        await task(
          'Deleting domain package files',
          () async => domainPackage.delete(),
        );

        await task(
          'Deleting infrastructure package files',
          () async => infrastructurePackage.delete(),
        );

        final rootPackages = await task(
          'Unegistering infrastructure package from platform root packages',
          () async {
            final rootPackages = project.rootPackages;
            for (final rootPackage in rootPackages) {
              await rootPackage
                  .unregisterInfrastructurePackage(infrastructurePackage);
            }
            return rootPackages;
          },
        );

        await bootstrap(packages: [...rootPackages]);

        await codeGen(packages: rootPackages);

        logger
          ..newLine()
          ..success('Success $checkLabel');
      } else {
        _logAndThrow(RapidDomainException._subInfrastructureDoesNotExist(name));
      }
    } else {
      _logAndThrow(RapidDomainException._subDomainDoesNotExist(name));
    }
  }

  Future<void> domainSubDomainAddEntity({
    required String name,
    required String? subDomainName,
    required String outputDir,
  }) async {
    logger
      ..command('rapid domain ${subDomainName ?? 'default'} add entity')
      ..newLine();

    final domainPackage =
        project.domainDirectory.domainPackage(name: subDomainName);
    final entity = domainPackage.entity(name: name, dir: outputDir);
    if (!entity.existsAny()) {
      final barrelFile = domainPackage.barrelFile;

      await task(
        'Creating entity files',
        () async => entity.create(),
      );

      // TODO better title
      await task(
        'Adding exports to ${p.relative(barrelFile.path, from: project.path)} ',
        () => barrelFile.addExport(
          p.normalize(
            p.join('src', outputDir, '${name.snakeCase}.dart'),
          ),
        ),
      );

      await dartFormatFix(domainPackage);

      logger
        ..newLine()
        ..success('Success $checkLabel');
    } else {
      _logAndThrow(
        RapidDomainException._entityOrValueObjectAlreadyExists(name),
      );
    }
  }

  Future<void> domainSubDomainAddServiceInterface({
    required String name,
    required String? subDomainName,
    required String outputDir,
  }) async {
    logger
      ..command(
          'rapid domain ${subDomainName ?? 'default'} add service_interface')
      ..newLine();

    final domainPackage =
        project.domainDirectory.domainPackage(name: subDomainName);
    final serviceInterface =
        domainPackage.serviceInterface(name: name, dir: outputDir);
    if (!serviceInterface.existsAny()) {
      final barrelFile = domainPackage.barrelFile;

      await task(
        'Creating service interface files',
        () async => serviceInterface.create(),
      );

      // TODO better title
      await task(
        'Adding exports to ${p.relative(barrelFile.path, from: project.path)} ',
        () => barrelFile.addExport(
          p.normalize(
            p.join('src', outputDir, 'i_${name.snakeCase}_service.dart'),
          ),
        ),
      );

      await dartFormatFix(domainPackage);

      logger
        ..newLine()
        ..success('Success $checkLabel');
    } else {
      _logAndThrow(
        RapidDomainException._serviceInterfaceAlreadyExists(name),
      );
    }
  }

  Future<void> domainSubDomainAddValueObject({
    required String name,
    required String? subDomainName,
    required String outputDir,
    required String type,
    required String generics,
  }) async {
    logger
      ..command('rapid domain ${subDomainName ?? 'default'} add value_object')
      ..newLine();

    final domainPackage =
        project.domainDirectory.domainPackage(name: subDomainName);
    final valueObject = domainPackage.valueObject(
      name: name,
      dir: outputDir,
    );

    if (!valueObject.existsAny()) {
      final barrelFile = domainPackage.barrelFile;

      await task(
        'Creating value object files',
        () async => valueObject.create(type: type, generics: generics),
      );

      // TODO better title
      await task(
        'Adding exports to ${p.relative(barrelFile.path, from: project.path)} ',
        () => barrelFile.addExport(
          p.normalize(
            p.join('src', outputDir, '${name.snakeCase}.dart'),
          ),
        ),
      );

      await codeGen(packages: [domainPackage]);

      await dartFormatFix(domainPackage);

      logger
        ..newLine()
        ..success('Success $checkLabel');
    } else {
      _logAndThrow(
        RapidDomainException._entityOrValueObjectAlreadyExists(name),
      );
    }
  }

  Future<void> domainSubDomainRemoveEntity({
    required String name,
    required String? subDomainName,
    required String dir,
  }) async {
    logger
      ..command('rapid domain ${subDomainName ?? 'default'} remove entity')
      ..newLine();

    final domainPackage =
        project.domainDirectory.domainPackage(name: subDomainName);
    final entity = domainPackage.entity(name: name, dir: dir);
    // TODO this does delete a value_object because they have same files
    if (entity.existsAny()) {
      final barrelFile = domainPackage.barrelFile;

      await task(
        'Deleting entity files',
        () async => entity.delete(),
      );

      // TODO better title
      await task(
        'Removing exports from ${p.relative(barrelFile.path, from: project.path)} ',
        () => barrelFile.removeExport(
          p.normalize(
            p.join('src', dir, '${name.snakeCase}.dart'),
          ),
        ),
      );

      logger
        ..newLine()
        ..success('Success $checkLabel');
    } else {
      _logAndThrow(RapidDomainException._entityNotFound(name));
    }
  }

  Future<void> domainSubDomainRemoveServiceInterface({
    required String name,
    required String? subDomainName,
    required String dir,
  }) async {
    logger
      ..command(
          'rapid domain ${subDomainName ?? 'default'} remove service_interface')
      ..newLine();

    final domainPackage =
        project.domainDirectory.domainPackage(name: subDomainName);
    final serviceInterface =
        domainPackage.serviceInterface(name: name, dir: dir);
    if (serviceInterface.existsAny()) {
      final barrelFile = domainPackage.barrelFile;

      await task(
        'Deleting service interface files',
        () async => serviceInterface.delete(),
      );

      // TODO better title
      await task(
        'Removing exports from ${p.relative(barrelFile.path, from: project.path)} ',
        () => barrelFile.removeExport(
          p.normalize(
            p.join('src', dir, 'i_${name.snakeCase}_service.dart'),
          ),
        ),
      );

      logger
        ..newLine()
        ..success('Success $checkLabel');
    } else {
      _logAndThrow(
        RapidDomainException._serviceInterfaceNotFound(name),
      );
    }
  }

  Future<void> domainSubDomainRemoveValueObject({
    required String name,
    required String? subDomainName,
    required String dir,
  }) async {
    logger
      ..command(
          'rapid domain ${subDomainName ?? 'default'} remove value_object')
      ..newLine();

    final domainPackage =
        project.domainDirectory.domainPackage(name: subDomainName);
    final valueObject = domainPackage.valueObject(name: name, dir: dir);
    if (valueObject.existsAny()) {
      final barrelFile = domainPackage.barrelFile;

      await task(
        'Deleting value object files',
        () async => valueObject.delete(),
      );

      // TODO better title
      await task(
        'Removing exports from ${p.relative(barrelFile.path, from: project.path)} ',
        () => barrelFile.removeExport(
          p.normalize(
            p.join('src', dir, '${name.snakeCase}.dart'),
          ),
        ),
      );

      logger
        ..newLine()
        ..success('Success $checkLabel');
    } else {
      _logAndThrow(RapidDomainException._valueObjectNotFound(name));
    }
  }
}

class RapidDomainException extends RapidException {
  RapidDomainException._(super.message);

  factory RapidDomainException._serviceInterfaceAlreadyExists(String name) {
    return RapidDomainException._(
      'Service Interface I${name}Service already exists.',
    );
  }

  factory RapidDomainException._subInfrastructureAlreadyExists(String name) {
    return RapidDomainException._(
      'The subinfrastructure "$name" already exists.',
    );
  }

  factory RapidDomainException._subDomainAlreadyExists(String name) {
    return RapidDomainException._('The subdomain "$name" already exists.');
  }

  factory RapidDomainException._subInfrastructureDoesNotExist(String name) {
    return RapidDomainException._(
      'The subinfrastructure "$name" does not exist.',
    );
  }

  factory RapidDomainException._subDomainDoesNotExist(String name) {
    return RapidDomainException._(
      'The subdomain "$name" does not exist.',
    );
  }

  factory RapidDomainException._entityOrValueObjectAlreadyExists(String name) {
    return RapidDomainException._(
      'Entity or ValueObject $name already exists.',
    );
  }

  factory RapidDomainException._entityNotFound(String name) {
    return RapidDomainException._(
      'Entity $name does not exist.',
    );
  }

  factory RapidDomainException._serviceInterfaceNotFound(String name) {
    return RapidDomainException._(
      'Service Interface I${name}Service does not exist.',
    );
  }

  factory RapidDomainException._valueObjectNotFound(String name) {
    return RapidDomainException._(
      'Value Object $name does not exist.',
    );
  }

  @override
  String toString() {
    return 'RapidDomainException: $message';
  }
}
