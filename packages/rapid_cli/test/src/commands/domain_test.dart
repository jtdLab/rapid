void main() {
  // TODO impl
}

/* import 'package:mocktail/mocktail.dart';
import 'package:rapid_cli/src/commands/runner.dart';
import 'package:test/test.dart';

import '../mocks.dart';
import '../utils.dart';

void main() {
  group('domainAddSubDomain', () {
    test('throws SubDomainAlreadyExistsException when subdomain already exists',
        () async {
      final tool = MockRapidTool();
      final logger = MockRapidLogger();
      final project = MockRapidProject();
      final appModule = MockRapidModule();
      final domainDirectory = MockRapidDirectory();
      final domainPackage = MockRapidPackage();
      when(() => tool.logger).thenReturn(logger);
      when(() => tool.project).thenReturn(project);
      when(() => project.appModule).thenReturn(appModule);
      when(() => appModule.domainDirectory).thenReturn(domainDirectory);
      when(() => domainDirectory.domainPackage(name: any(named: 'name')))
          .thenReturn(domainPackage);
      when(() => domainPackage.existsSync()).thenReturn(true);
      final rapid = getRapid(tool: tool);

      expect(
        () => rapid.domainAddSubDomain(name: 'SubDomain'),
        throwsA(isA<SubDomainAlreadyExistsException>()),
      );
    });

    test(
        'throws SubInfrastructureAlreadyExistsException when subinfrastructure already exists',
        () async {
      final tool = MockRapidTool();
      final logger = MockRapidLogger();
      final project = MockRapidProject();
      final appModule = MockRapidModule();
      final domainDirectory = MockRapidDirectory();
      final domainPackage = MockRapidPackage();
      final infrastructureDirectory = MockRapidDirectory();
      final infrastructurePackage = MockRapidPackage();
      when(() => tool.logger).thenReturn(logger);
      when(() => tool.project).thenReturn(project);
      when(() => project.appModule).thenReturn(appModule);
      when(() => appModule.domainDirectory).thenReturn(domainDirectory);
      when(() => appModule.infrastructureDirectory)
          .thenReturn(infrastructureDirectory);
      when(() => domainDirectory.domainPackage(name: any(named: 'name')))
          .thenReturn(domainPackage);
      when(() => infrastructureDirectory.infrastructurePackage(
          name: any(named: 'name'))).thenReturn(infrastructurePackage);
      when(() => domainPackage.existsSync()).thenReturn(false);
      when(() => infrastructurePackage.existsSync()).thenReturn(true);
      final rapid = getRapid(tool: tool);

      expect(
        () => rapid.domainAddSubDomain(name: 'SubDomain'),
        throwsA(isA<SubInfrastructureAlreadyExistsException>()),
      );
    });

    test('creates subdomain and completes', () async {
      final tool = MockRapidTool();
      final logger = MockRapidLogger();
      final project = MockRapidProject();
      final appModule = MockRapidModule();
      final domainDirectory = MockRapidDirectory();
      final domainPackage = MockRapidPackage();
      final infrastructureDirectory = MockRapidDirectory();
      final infrastructurePackage = MockRapidPackage();
      final rootPackage = MockRapidPackage();
      final barrelFile = MockRapidFile();
      when(() => tool.logger).thenReturn(logger);
      when(() => tool.project).thenReturn(project);
      when(() => project.appModule).thenReturn(appModule);
      when(() => appModule.domainDirectory).thenReturn(domainDirectory);
      when(() => appModule.infrastructureDirectory)
          .thenReturn(infrastructureDirectory);
      when(() => project.rootPackages()).thenReturn([rootPackage]);
      when(() => domainDirectory.domainPackage(name: any(named: 'name')))
          .thenReturn(domainPackage);
      when(() => infrastructureDirectory.infrastructurePackage(
          name: any(named: 'name'))).thenReturn(infrastructurePackage);
      when(() => domainPackage.existsSync()).thenReturn(false);
      when(() => infrastructurePackage.existsSync()).thenReturn(false);
      when(() => domainPackage.barrelFile).thenReturn(barrelFile);
      final rapid = getRapid(tool: tool);

      await rapid.domainAddSubDomain(name: 'SubDomain');

      verify(() => domainPackage.generate()).called(1);
      verify(() => infrastructurePackage.generate()).called(1);
      verify(() =>
              rootPackage.registerInfrastructurePackage(infrastructurePackage))
          .called(1);
      // Verify other expectations
    });
  });

  group('domainRemoveSubDomain', () {
    test('throws SubDomainDoesNotExistException when subdomain does not exist',
        () async {
      final tool = MockRapidTool();
      final logger = MockRapidLogger();
      final project = MockRapidProject();
      final appModule = MockRapidModule();
      final domainDirectory = MockRapidDirectory();
      final domainPackage = MockRapidPackage();
      when(() => tool.logger).thenReturn(logger);
      when(() => tool.project).thenReturn(project);
      when(() => project.appModule).thenReturn(appModule);
      when(() => appModule.domainDirectory).thenReturn(domainDirectory);
      when(() => domainDirectory.domainPackage(name: any(named: 'name')))
          .thenReturn(domainPackage);
      when(() => domainPackage.existsSync()).thenReturn(false);
      final rapid = getRapid(tool: tool);

      expect(
        () => rapid.domainRemoveSubDomain(name: 'SubDomain'),
        throwsA(isA<SubDomainDoesNotExistException>()),
      );
    });

    test(
        'throws SubInfrastructureDoesNotExistException when subinfrastructure does not exist',
        () async {
      final tool = MockRapidTool();
      final logger = MockRapidLogger();
      final project = MockRapidProject();
      final appModule = MockRapidModule();
      final domainDirectory = MockRapidDirectory();
      final domainPackage = MockRapidPackage();
      final infrastructureDirectory = MockRapidDirectory();
      final infrastructurePackage = MockRapidPackage();
      when(() => tool.logger).thenReturn(logger);
      when(() => tool.project).thenReturn(project);
      when(() => project.appModule).thenReturn(appModule);
      when(() => appModule.domainDirectory).thenReturn(domainDirectory);
      when(() => appModule.infrastructureDirectory)
          .thenReturn(infrastructureDirectory);
      when(() => domainDirectory.domainPackage(name: any(named: 'name')))
          .thenReturn(domainPackage);
      when(() => infrastructureDirectory.infrastructurePackage(
          name: any(named: 'name'))).thenReturn(infrastructurePackage);
      when(() => domainPackage.existsSync()).thenReturn(true);
      when(() => infrastructurePackage.existsSync()).thenReturn(false);
      final rapid = getRapid(tool: tool);

      expect(
        () => rapid.domainRemoveSubDomain(name: 'SubDomain'),
        throwsA(isA<SubInfrastructureDoesNotExistException>()),
      );
    });

    test('removes subdomain and completes', () async {
      final tool = MockRapidTool();
      final logger = MockRapidLogger();
      final project = MockRapidProject();
      final appModule = MockRapidModule();
      final domainDirectory = MockRapidDirectory();
      final domainPackage = MockRapidPackage();
      final infrastructureDirectory = MockRapidDirectory();
      final infrastructurePackage = MockRapidPackage();
      final rootPackage = MockRapidPackage();
      final barrelFile = MockRapidFile();
      when(() => tool.logger).thenReturn(logger);
      when(() => tool.project).thenReturn(project);
      when(() => project.appModule).thenReturn(appModule);
      when(() => appModule.domainDirectory).thenReturn(domainDirectory);
      when(() => appModule.infrastructureDirectory)
          .thenReturn(infrastructureDirectory);
      when(() => project.rootPackages()).thenReturn([rootPackage]);
      when(() => domainDirectory.domainPackage(name: any(named: 'name')))
          .thenReturn(domainPackage);
      when(() => infrastructureDirectory.infrastructurePackage(
          name: any(named: 'name'))).thenReturn(infrastructurePackage);
      when(() => domainPackage.existsSync()).thenReturn(true);
      when(() => infrastructurePackage.existsSync()).thenReturn(true);
      when(() => domainPackage.barrelFile).thenReturn(barrelFile);
      final rapid = getRapid(tool: tool);

      await rapid.domainRemoveSubDomain(name: 'SubDomain');

      verify(() => domainPackage.deleteSync(recursive: true)).called(1);
      verify(() => rootPackage
          .unregisterInfrastructurePackage(infrastructurePackage)).called(1);
      verify(() => infrastructurePackage.deleteSync(recursive: true)).called(1);
      // Verify other expectations
    });
  });

  group('domainSubDomainAddEntity', () {
    test(
        'throws EntityOrValueObjectAlreadyExistsException when entity already exists',
        () async {
      final tool = MockRapidTool();
      final logger = MockRapidLogger();
      final project = MockRapidProject();
      final appModule = MockRapidModule();
      final domainDirectory = MockRapidDirectory();
      final domainPackage = MockRapidPackage();
      final entity = MockRapidEntity();
      when(() => tool.logger).thenReturn(logger);
      when(() => tool.project).thenReturn(project);
      when(() => project.appModule).thenReturn(appModule);
      when(() => appModule.domainDirectory).thenReturn(domainDirectory);
      when(() => domainDirectory.domainPackage(name: any(named: 'name')))
          .thenReturn(domainPackage);
      when(() => domainPackage.entity(name: any(named: 'name')))
          .thenReturn(entity);
      when(() => entity.existsAny).thenReturn(true);
      final rapid = getRapid(tool: tool);

      expect(
        () => rapid.domainSubDomainAddEntity(
            name: 'Entity', subDomainName: 'SubDomain'),
        throwsA(isA<EntityOrValueObjectAlreadyExistsException>()),
      );
    });

    test('adds entity and completes', () async {
      final tool = MockRapidTool();
      final logger = MockRapidLogger();
      final project = MockRapidProject();
      final appModule = MockRapidModule();
      final domainDirectory = MockRapidDirectory();
      final domainPackage = MockRapidPackage();
      final entity = MockRapidEntity();
      final barrelFile = MockRapidFile();
      when(() => tool.logger).thenReturn(logger);
      when(() => tool.project).thenReturn(project);
      when(() => project.appModule).thenReturn(appModule);
      when(() => appModule.domainDirectory).thenReturn(domainDirectory);
      when(() => domainDirectory.domainPackage(name: any(named: 'name')))
          .thenReturn(domainPackage);
      when(() => domainPackage.entity(name: any(named: 'name')))
          .thenReturn(entity);
      when(() => entity.existsAny).thenReturn(false);
      when(() => domainPackage.barrelFile).thenReturn(barrelFile);
      final rapid = getRapid(tool: tool);

      await rapid.domainSubDomainAddEntity(
          name: 'Entity', subDomainName: 'SubDomain');

      verify(() => entity.generate()).called(1);
      verify(() => barrelFile.addExport(any())).called(1);
      // Verify other expectations
    });
  });

  group('domainSubDomainAddServiceInterface', () {
    test(
        'throws ServiceInterfaceAlreadyExistsException when service interface already exists',
        () async {
      final tool = MockRapidTool();
      final logger = MockRapidLogger();
      final project = MockRapidProject();
      final appModule = MockRapidModule();
      final domainDirectory = MockRapidDirectory();
      final domainPackage = MockRapidPackage();
      final serviceInterface = MockRapidServiceInterface();
      when(() => tool.logger).thenReturn(logger);
      when(() => tool.project).thenReturn(project);
      when(() => project.appModule).thenReturn(appModule);
      when(() => appModule.domainDirectory).thenReturn(domainDirectory);
      when(() => domainDirectory.domainPackage(name: any(named: 'name')))
          .thenReturn(domainPackage);
      when(() => domainPackage.serviceInterface(name: any(named: 'name')))
          .thenReturn(serviceInterface);
      when(() => serviceInterface.existsAny).thenReturn(true);
      final rapid = getRapid(tool: tool);

      expect(
        () => rapid.domainSubDomainAddServiceInterface(
            name: 'Service', subDomainName: 'SubDomain'),
        throwsA(isA<ServiceInterfaceAlreadyExistsException>()),
      );
    });

    test('adds service interface and completes', () async {
      final tool = MockRapidTool();
      final logger = MockRapidLogger();
      final project = MockRapidProject();
      final appModule = MockRapidModule();
      final domainDirectory = MockRapidDirectory();
      final domainPackage = MockRapidPackage();
      final serviceInterface = MockRapidServiceInterface();
      final barrelFile = MockRapidFile();
      when(() => tool.logger).thenReturn(logger);
      when(() => tool.project).thenReturn(project);
      when(() => project.appModule).thenReturn(appModule);
      when(() => appModule.domainDirectory).thenReturn(domainDirectory);
      when(() => domainDirectory.domainPackage(name: any(named: 'name')))
          .thenReturn(domainPackage);
      when(() => domainPackage.serviceInterface(name: any(named: 'name')))
          .thenReturn(serviceInterface);
      when(() => serviceInterface.existsAny).thenReturn(false);
      when(() => domainPackage.barrelFile).thenReturn(barrelFile);
      final rapid = getRapid(tool: tool);

      await rapid.domainSubDomainAddServiceInterface(
          name: 'Service', subDomainName: 'SubDomain');

      verify(() => serviceInterface.generate()).called(1);
      verify(() => barrelFile.addExport(any())).called(1);
      // Verify other expectations
    });
  });

  group('domainSubDomainAddValueObject', () {
    test(
        'throws EntityOrValueObjectAlreadyExistsException when value object already exists',
        () async {
      final tool = MockRapidTool();
      final logger = MockRapidLogger();
      final project = MockRapidProject();
      final appModule = MockRapidModule();
      final domainDirectory = MockRapidDirectory();
      final domainPackage = MockRapidPackage();
      final valueObject = MockRapidValueObject();
      when(() => tool.logger).thenReturn(logger);
      when(() => tool.project).thenReturn(project);
      when(() => project.appModule).thenReturn(appModule);
      when(() => appModule.domainDirectory).thenReturn(domainDirectory);
      when(() => domainDirectory.domainPackage(name: any(named: 'name')))
          .thenReturn(domainPackage);
      when(() => domainPackage.valueObject(name: any(named: 'name')))
          .thenReturn(valueObject);
      when(() => valueObject.existsAny).thenReturn(true);
      final rapid = getRapid(tool: tool);

      expect(
        () => rapid.domainSubDomainAddValueObject(
            name: 'ValueObject',
            subDomainName: 'SubDomain',
            type: 'String',
            generics: '<T>'),
        throwsA(isA<EntityOrValueObjectAlreadyExistsException>()),
      );
    });

    test('adds value object and completes', () async {
      final tool = MockRapidTool();
      final logger = MockRapidLogger();
      final project = MockRapidProject();
      final appModule = MockRapidModule();
      final domainDirectory = MockRapidDirectory();
      final domainPackage = MockRapidPackage();
      final valueObject = MockRapidValueObject();
      final barrelFile = MockRapidFile();
      when(() => tool.logger).thenReturn(logger);
      when(() => tool.project).thenReturn(project);
      when(() => project.appModule).thenReturn(appModule);
      when(() => appModule.domainDirectory).thenReturn(domainDirectory);
      when(() => domainDirectory.domainPackage(name: any(named: 'name')))
          .thenReturn(domainPackage);
      when(() => domainPackage.valueObject(name: any(named: 'name')))
          .thenReturn(valueObject);
      when(() => valueObject.existsAny).thenReturn(false);
      when(() => domainPackage.barrelFile).thenReturn(barrelFile);
      final rapid = getRapid(tool: tool);

      await rapid.domainSubDomainAddValueObject(
          name: 'ValueObject',
          subDomainName: 'SubDomain',
          type: 'String',
          generics: '<T>');

      verify(() => valueObject.generate(
          type: any(named: 'type'),
          generics: any(named: 'generics'))).called(1);
      verify(() => barrelFile.addExport(any())).called(1);
      // Verify other expectations
    });
  });

  group('domainSubDomainRemoveEntity', () {
    test('throws EntityNotFoundException when entity does not exist', () async {
      final tool = MockRapidTool();
      final logger = MockRapidLogger();
      final project = MockRapidProject();
      final appModule = MockRapidModule();
      final domainDirectory = MockRapidDirectory();
      final domainPackage = MockRapidPackage();
      final entity = MockRapidEntity();
      when(() => tool.logger).thenReturn(logger);
      when(() => tool.project).thenReturn(project);
      when(() => project.appModule).thenReturn(appModule);
      when(() => appModule.domainDirectory).thenReturn(domainDirectory);
      when(() => domainDirectory.domainPackage(name: any(named: 'name')))
          .thenReturn(domainPackage);
      when(() => domainPackage.entity(name: any(named: 'name')))
          .thenReturn(entity);
      when(() => entity.existsAny).thenReturn(false);
      final rapid = getRapid(tool: tool);

      expect(
        () => rapid.domainSubDomainRemoveEntity(
            name: 'Entity', subDomainName: 'SubDomain'),
        throwsA(isA<EntityNotFoundException>()),
      );
    });

    test('removes entity and completes', () async {
      final tool = MockRapidTool();
      final logger = MockRapidLogger();
      final project = MockRapidProject();
      final appModule = MockRapidModule();
      final domainDirectory = MockRapidDirectory();
      final domainPackage = MockRapidPackage();
      final entity = MockRapidEntity();
      final barrelFile = MockRapidFile();
      when(() => tool.logger).thenReturn(logger);
      when(() => tool.project).thenReturn(project);
      when(() => project.appModule).thenReturn(appModule);
      when(() => appModule.domainDirectory).thenReturn(domainDirectory);
      when(() => domainDirectory.domainPackage(name: any(named: 'name')))
          .thenReturn(domainPackage);
      when(() => domainPackage.entity(name: any(named: 'name')))
          .thenReturn(entity);
      when(() => entity.existsAny).thenReturn(true);
      when(() => domainPackage.barrelFile).thenReturn(barrelFile);
      final rapid = getRapid(tool: tool);

      await rapid.domainSubDomainRemoveEntity(
          name: 'Entity', subDomainName: 'SubDomain');

      verify(() => entity.delete()).called(1);
      verify(() => barrelFile.removeExport(any())).called(1);
      // Verify other expectations
    });
  });

  group('domainSubDomainRemoveServiceInterface', () {
    test(
        'throws ServiceInterfaceNotFoundException when service interface does not exist',
        () async {
      final tool = MockRapidTool();
      final logger = MockRapidLogger();
      final project = MockRapidProject();
      final appModule = MockRapidModule();
      final domainDirectory = MockRapidDirectory();
      final domainPackage = MockRapidPackage();
      final serviceInterface = MockRapidServiceInterface();
      when(() => tool.logger).thenReturn(logger);
      when(() => tool.project).thenReturn(project);
      when(() => project.appModule).thenReturn(appModule);
      when(() => appModule.domainDirectory).thenReturn(domainDirectory);
      when(() => domainDirectory.domainPackage(name: any(named: 'name')))
          .thenReturn(domainPackage);
      when(() => domainPackage.serviceInterface(name: any(named: 'name')))
          .thenReturn(serviceInterface);
      when(() => serviceInterface.existsAny).thenReturn(false);
      final rapid = getRapid(tool: tool);

      expect(
        () => rapid.domainSubDomainRemoveServiceInterface(
            name: 'Service', subDomainName: 'SubDomain'),
        throwsA(isA<ServiceInterfaceNotFoundException>()),
      );
    });

    test('removes service interface and completes', () async {
      final tool = MockRapidTool();
      final logger = MockRapidLogger();
      final project = MockRapidProject();
      final appModule = MockRapidModule();
      final domainDirectory = MockRapidDirectory();
      final domainPackage = MockRapidPackage();
      final serviceInterface = MockRapidServiceInterface();
      final barrelFile = MockRapidFile();
      when(() => tool.logger).thenReturn(logger);
      when(() => tool.project).thenReturn(project);
      when(() => project.appModule).thenReturn(appModule);
      when(() => appModule.domainDirectory).thenReturn(domainDirectory);
      when(() => domainDirectory.domainPackage(name: any(named: 'name')))
          .thenReturn(domainPackage);
      when(() => domainPackage.serviceInterface(name: any(named: 'name')))
          .thenReturn(serviceInterface);
      when(() => serviceInterface.existsAny).thenReturn(true);
      when(() => domainPackage.barrelFile).thenReturn(barrelFile);
      final rapid = getRapid(tool: tool);

      await rapid.domainSubDomainRemoveServiceInterface(
          name: 'Service', subDomainName: 'SubDomain');

      verify(() => serviceInterface.delete()).called(1);
      verify(() => barrelFile.removeExport(any())).called(1);
      // Verify other expectations
    });
  });

  group('domainSubDomainRemoveValueObject', () {
    test('throws ValueObjectNotFoundException when value object does not exist',
        () async {
      final tool = MockRapidTool();
      final logger = MockRapidLogger();
      final project = MockRapidProject();
      final appModule = MockRapidModule();
      final domainDirectory = MockRapidDirectory();
      final domainPackage = MockRapidPackage();
      final valueObject = MockRapidValueObject();
      when(() => tool.logger).thenReturn(logger);
      when(() => tool.project).thenReturn(project);
      when(() => project.appModule).thenReturn(appModule);
      when(() => appModule.domainDirectory).thenReturn(domainDirectory);
      when(() => domainDirectory.domainPackage(name: any(named: 'name')))
          .thenReturn(domainPackage);
      when(() => domainPackage.valueObject(name: any(named: 'name')))
          .thenReturn(valueObject);
      when(() => valueObject.existsAny).thenReturn(false);
      final rapid = getRapid(tool: tool);

      expect(
        () => rapid.domainSubDomainRemoveValueObject(
            name: 'ValueObject', subDomainName: 'SubDomain'),
        throwsA(isA<ValueObjectNotFoundException>()),
      );
    });

    test('removes value object and completes', () async {
      final tool = MockRapidTool();
      final logger = MockRapidLogger();
      final project = MockRapidProject();
      final appModule = MockRapidModule();
      final domainDirectory = MockRapidDirectory();
      final domainPackage = MockRapidPackage();
      final valueObject = MockRapidValueObject();
      final barrelFile = MockRapidFile();
      when(() => tool.logger).thenReturn(logger);
      when(() => tool.project).thenReturn(project);
      when(() => project.appModule).thenReturn(appModule);
      when(() => appModule.domainDirectory).thenReturn(domainDirectory);
      when(() => domainDirectory.domainPackage(name: any(named: 'name')))
          .thenReturn(domainPackage);
      when(() => domainPackage.valueObject(name: any(named: 'name')))
          .thenReturn(valueObject);
      when(() => valueObject.existsAny).thenReturn(true);
      when(() => domainPackage.barrelFile).thenReturn(barrelFile);
      final rapid = getRapid(tool: tool);

      await rapid.domainSubDomainRemoveValueObject(
          name: 'ValueObject', subDomainName: 'SubDomain');

      verify(() => valueObject.delete()).called(1);
      verify(() => barrelFile.removeExport(any())).called(1);
      // Verify other expectations
    });
  });
}
 */
