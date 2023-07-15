void main() {
  // TODO impl
}

/* import 'package:mocktail/mocktail.dart';
import 'package:rapid_cli/src/commands/runner.dart';
import 'package:test/test.dart';

import '../mocks.dart';
import '../utils.dart';

void main() {
  group('infrastructureSubInfrastructureAddDataTransferObject', () {
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
      when(() => domainPackage.entity(name: any(named: 'entityName')))
          .thenReturn(entity);
      when(() => entity.existsAll).thenReturn(false);
      final rapid = getRapid(tool: tool);

      expect(
        () => rapid.infrastructureSubInfrastructureAddDataTransferObject(
            subInfrastructureName: 'SubInfrastructure', entityName: 'Entity'),
        throwsA(isA<EntityNotFoundException>()),
      );
    });

    test(
        'throws DataTransferObjectAlreadyExistsException when data transfer object already exists',
        () async {
      final tool = MockRapidTool();
      final logger = MockRapidLogger();
      final project = MockRapidProject();
      final appModule = MockRapidModule();
      final domainDirectory = MockRapidDirectory();
      final domainPackage = MockRapidPackage();
      final entity = MockRapidEntity();
      final infrastructureDirectory = MockRapidDirectory();
      final infrastructurePackage = MockRapidPackage();
      final dataTransferObject = MockRapidDataTransferObject();
      when(() => tool.logger).thenReturn(logger);
      when(() => tool.project).thenReturn(project);
      when(() => project.appModule).thenReturn(appModule);
      when(() => appModule.domainDirectory).thenReturn(domainDirectory);
      when(() => domainDirectory.domainPackage(
          name: any(named: 'subInfrastructureName'))).thenReturn(domainPackage);
      when(() => domainPackage.entity(name: any(named: 'entityName')))
          .thenReturn(entity);
      when(() => entity.existsAll).thenReturn(true);
      when(() => appModule.infrastructureDirectory)
          .thenReturn(infrastructureDirectory);
      when(() => infrastructureDirectory.infrastructurePackage(
              name: any(named: 'subInfrastructureName')))
          .thenReturn(infrastructurePackage);
      when(() => infrastructurePackage.dataTransferObject(
          entityName: any(named: 'entityName'))).thenReturn(dataTransferObject);
      when(() => dataTransferObject.existsAny).thenReturn(true);
      final rapid = getRapid(tool: tool);

      expect(
        () => rapid.infrastructureSubInfrastructureAddDataTransferObject(
            subInfrastructureName: 'SubInfrastructure', entityName: 'Entity'),
        throwsA(isA<DataTransferObjectAlreadyExistsException>()),
      );
    });

    test('adds data transfer object and completes', () async {
      final tool = MockRapidTool();
      final logger = MockRapidLogger();
      final project = MockRapidProject();
      final appModule = MockRapidModule();
      final domainDirectory = MockRapidDirectory();
      final domainPackage = MockRapidPackage();
      final entity = MockRapidEntity();
      final infrastructureDirectory = MockRapidDirectory();
      final infrastructurePackage = MockRapidPackage();
      final dataTransferObject = MockRapidDataTransferObject();
      final barrelFile = MockRapidFile();
      when(() => tool.logger).thenReturn(logger);
      when(() => tool.project).thenReturn(project);
      when(() => project.appModule).thenReturn(appModule);
      when(() => appModule.domainDirectory).thenReturn(domainDirectory);
      when(() => domainDirectory.domainPackage(
          name: any(named: 'subInfrastructureName'))).thenReturn(domainPackage);
      when(() => domainPackage.entity(name: any(named: 'entityName')))
          .thenReturn(entity);
      when(() => entity.existsAll).thenReturn(true);
      when(() => appModule.infrastructureDirectory)
          .thenReturn(infrastructureDirectory);
      when(() => infrastructureDirectory.infrastructurePackage(
              name: any(named: 'subInfrastructureName')))
          .thenReturn(infrastructurePackage);
      when(() => infrastructurePackage.dataTransferObject(
          entityName: any(named: 'entityName'))).thenReturn(dataTransferObject);
      when(() => dataTransferObject.existsAny).thenReturn(false);
      when(() => infrastructurePackage.barrelFile).thenReturn(barrelFile);
      final rapid = getRapid(tool: tool);

      await rapid.infrastructureSubInfrastructureAddDataTransferObject(
          subInfrastructureName: 'SubInfrastructure', entityName: 'Entity');

      verify(() => dataTransferObject.generate()).called(1);
      verify(() => barrelFile.addExport(any())).called(1);
      // Verify other expectations
    });
  });

  group('infrastructureSubInfrastructureAddServiceImplementation', () {
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
      when(() => domainDirectory.domainPackage(
          name: any(named: 'subInfrastructureName'))).thenReturn(domainPackage);
      when(() => domainPackage.serviceInterface(
              name: any(named: 'serviceInterfaceName')))
          .thenReturn(serviceInterface);
      when(() => serviceInterface.existsAll).thenReturn(false);
      final rapid = getRapid(tool: tool);

      expect(
        () => rapid.infrastructureSubInfrastructureAddServiceImplementation(
            name: 'Service',
            subInfrastructureName: 'SubInfrastructure',
            serviceInterfaceName: 'ServiceInterface'),
        throwsA(isA<ServiceInterfaceNotFoundException>()),
      );
    });

    test(
        'throws ServiceImplementationAlreadyExistsException when service implementation already exists',
        () async {
      final tool = MockRapidTool();
      final logger = MockRapidLogger();
      final project = MockRapidProject();
      final appModule = MockRapidModule();
      final domainDirectory = MockRapidDirectory();
      final domainPackage = MockRapidPackage();
      final serviceInterface = MockRapidServiceInterface();
      final infrastructureDirectory = MockRapidDirectory();
      final infrastructurePackage = MockRapidPackage();
      final serviceImplementation = MockRapidServiceImplementation();
      when(() => tool.logger).thenReturn(logger);
      when(() => tool.project).thenReturn(project);
      when(() => project.appModule).thenReturn(appModule);
      when(() => appModule.domainDirectory).thenReturn(domainDirectory);
      when(() => domainDirectory.domainPackage(
          name: any(named: 'subInfrastructureName'))).thenReturn(domainPackage);
      when(() => domainPackage.serviceInterface(
              name: any(named: 'serviceInterfaceName')))
          .thenReturn(serviceInterface);
      when(() => serviceInterface.existsAll).thenReturn(true);
      when(() => appModule.infrastructureDirectory)
          .thenReturn(infrastructureDirectory);
      when(() => infrastructureDirectory.infrastructurePackage(
              name: any(named: 'subInfrastructureName')))
          .thenReturn(infrastructurePackage);
      when(() => infrastructurePackage.serviceImplementation(
              name: any(named: 'name'),
              serviceInterfaceName: any(named: 'serviceInterfaceName')))
          .thenReturn(serviceImplementation);
      when(() => serviceImplementation.existsAny).thenReturn(true);
      final rapid = getRapid(tool: tool);

      expect(
        () => rapid.infrastructureSubInfrastructureAddServiceImplementation(
            name: 'Service',
            subInfrastructureName: 'SubInfrastructure',
            serviceInterfaceName: 'ServiceInterface'),
        throwsA(isA<ServiceImplementationAlreadyExistsException>()),
      );
    });

    test('adds service implementation and completes', () async {
      final tool = MockRapidTool();
      final logger = MockRapidLogger();
      final project = MockRapidProject();
      final appModule = MockRapidModule();
      final domainDirectory = MockRapidDirectory();
      final domainPackage = MockRapidPackage();
      final serviceInterface = MockRapidServiceInterface();
      final infrastructureDirectory = MockRapidDirectory();
      final infrastructurePackage = MockRapidPackage();
      final serviceImplementation = MockRapidServiceImplementation();
      final barrelFile = MockRapidFile();
      when(() => tool.logger).thenReturn(logger);
      when(() => tool.project).thenReturn(project);
      when(() => project.appModule).thenReturn(appModule);
      when(() => appModule.domainDirectory).thenReturn(domainDirectory);
      when(() => domainDirectory.domainPackage(
          name: any(named: 'subInfrastructureName'))).thenReturn(domainPackage);
      when(() => domainPackage.serviceInterface(
              name: any(named: 'serviceInterfaceName')))
          .thenReturn(serviceInterface);
      when(() => serviceInterface.existsAll).thenReturn(true);
      when(() => appModule.infrastructureDirectory)
          .thenReturn(infrastructureDirectory);
      when(() => infrastructureDirectory.infrastructurePackage(
              name: any(named: 'subInfrastructureName')))
          .thenReturn(infrastructurePackage);
      when(() => infrastructurePackage.serviceImplementation(
              name: any(named: 'name'),
              serviceInterfaceName: any(named: 'serviceInterfaceName')))
          .thenReturn(serviceImplementation);
      when(() => serviceImplementation.existsAny).thenReturn(false);
      when(() => infrastructurePackage.barrelFile).thenReturn(barrelFile);
      final rapid = getRapid(tool: tool);

      await rapid.infrastructureSubInfrastructureAddServiceImplementation(
          name: 'Service',
          subInfrastructureName: 'SubInfrastructure',
          serviceInterfaceName: 'ServiceInterface');

      verify(() => serviceImplementation.generate()).called(1);
      verify(() => barrelFile.addExport(any())).called(1);
      // Verify other expectations
    });
  });

  group('infrastructureSubInfrastructureRemoveDataTransferObject', () {
    test(
        'throws DataTransferObjectNotFoundException when data transfer object does not exist',
        () async {
      final tool = MockRapidTool();
      final logger = MockRapidLogger();
      final project = MockRapidProject();
      final appModule = MockRapidModule();
      final infrastructureDirectory = MockRapidDirectory();
      final infrastructurePackage = MockRapidPackage();
      final dataTransferObject = MockRapidDataTransferObject();
      when(() => tool.logger).thenReturn(logger);
      when(() => tool.project).thenReturn(project);
      when(() => project.appModule).thenReturn(appModule);
      when(() => appModule.infrastructureDirectory)
          .thenReturn(infrastructureDirectory);
      when(() => infrastructureDirectory.infrastructurePackage(
              name: any(named: 'subInfrastructureName')))
          .thenReturn(infrastructurePackage);
      when(() => infrastructurePackage.dataTransferObject(
          entityName: any(named: 'entityName'))).thenReturn(dataTransferObject);
      when(() => dataTransferObject.existsAny).thenReturn(false);
      final rapid = getRapid(tool: tool);

      expect(
        () => rapid.infrastructureSubInfrastructureRemoveDataTransferObject(
            subInfrastructureName: 'SubInfrastructure', entityName: 'Entity'),
        throwsA(isA<DataTransferObjectNotFoundException>()),
      );
    });

    test('removes data transfer object and completes', () async {
      final tool = MockRapidTool();
      final logger = MockRapidLogger();
      final project = MockRapidProject();
      final appModule = MockRapidModule();
      final infrastructureDirectory = MockRapidDirectory();
      final infrastructurePackage = MockRapidPackage();
      final dataTransferObject = MockRapidDataTransferObject();
      final barrelFile = MockRapidFile();
      when(() => tool.logger).thenReturn(logger);
      when(() => tool.project).thenReturn(project);
      when(() => project.appModule).thenReturn(appModule);
      when(() => appModule.infrastructureDirectory)
          .thenReturn(infrastructureDirectory);
      when(() => infrastructureDirectory.infrastructurePackage(
              name: any(named: 'subInfrastructureName')))
          .thenReturn(infrastructurePackage);
      when(() => infrastructurePackage.dataTransferObject(
          entityName: any(named: 'entityName'))).thenReturn(dataTransferObject);
      when(() => dataTransferObject.existsAny).thenReturn(true);
      when(() => infrastructurePackage.barrelFile).thenReturn(barrelFile);
      final rapid = getRapid(tool: tool);

      await rapid.infrastructureSubInfrastructureRemoveDataTransferObject(
          subInfrastructureName: 'SubInfrastructure', entityName: 'Entity');

      verify(() => barrelFile.removeExport(any())).called(1);
      verify(() => dataTransferObject.delete()).called(1);
      // Verify other expectations
    });
  });

  group('infrastructureSubInfrastructureRemoveServiceImplementation', () {
    test(
        'throws ServiceImplementationNotFoundException when service implementation does not exist',
        () async {
      final tool = MockRapidTool();
      final logger = MockRapidLogger();
      final project = MockRapidProject();
      final appModule = MockRapidModule();
      final infrastructureDirectory = MockRapidDirectory();
      final infrastructurePackage = MockRapidPackage();
      final serviceImplementation = MockRapidServiceImplementation();
      when(() => tool.logger).thenReturn(logger);
      when(() => tool.project).thenReturn(project);
      when(() => project.appModule).thenReturn(appModule);
      when(() => appModule.infrastructureDirectory)
          .thenReturn(infrastructureDirectory);
      when(() => infrastructureDirectory.infrastructurePackage(
              name: any(named: 'subInfrastructureName')))
          .thenReturn(infrastructurePackage);
      when(() => infrastructurePackage.serviceImplementation(
              name: any(named: 'name'),
              serviceInterfaceName: any(named: 'serviceInterfaceName')))
          .thenReturn(serviceImplementation);
      when(() => serviceImplementation.existsAny).thenReturn(false);
      final rapid = getRapid(tool: tool);

      expect(
        () => rapid.infrastructureSubInfrastructureRemoveServiceImplementation(
            name: 'Service',
            subInfrastructureName: 'SubInfrastructure',
            serviceInterfaceName: 'ServiceInterface'),
        throwsA(isA<ServiceImplementationNotFoundException>()),
      );
    });

    test('removes service implementation and completes', () async {
      final tool = MockRapidTool();
      final logger = MockRapidLogger();
      final project = MockRapidProject();
      final appModule = MockRapidModule();
      final infrastructureDirectory = MockRapidDirectory();
      final infrastructurePackage = MockRapidPackage();
      final serviceImplementation = MockRapidServiceImplementation();
      final barrelFile = MockRapidFile();
      when(() => tool.logger).thenReturn(logger);
      when(() => tool.project).thenReturn(project);
      when(() => project.appModule).thenReturn(appModule);
      when(() => appModule.infrastructureDirectory)
          .thenReturn(infrastructureDirectory);
      when(() => infrastructureDirectory.infrastructurePackage(
              name: any(named: 'subInfrastructureName')))
          .thenReturn(infrastructurePackage);
      when(() => infrastructurePackage.serviceImplementation(
              name: any(named: 'name'),
              serviceInterfaceName: any(named: 'serviceInterfaceName')))
          .thenReturn(serviceImplementation);
      when(() => serviceImplementation.existsAny).thenReturn(true);
      when(() => infrastructurePackage.barrelFile).thenReturn(barrelFile);
      final rapid = getRapid(tool: tool);

      await rapid.infrastructureSubInfrastructureRemoveServiceImplementation(
          name: 'Service',
          subInfrastructureName: 'SubInfrastructure',
          serviceInterfaceName: 'ServiceInterface');

      verify(() => barrelFile.removeExport(any())).called(1);
      verify(() => serviceImplementation.delete()).called(1);
      // Verify other expectations
    });
  });
}
 */
