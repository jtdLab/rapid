import 'package:mocktail/mocktail.dart';
import 'package:rapid_cli/src/commands/runner.dart';
import 'package:test/test.dart';

import '../invocations.dart';
import '../mock_env.dart';
import '../mocks.dart';
import '../utils.dart';

void main() {
  setUpAll(() {
    registerFallbackValues();
  });

  group('infrastructureSubInfrastructureAddDataTransferObject', () {
    test('adds data transfer object to sub-infrastructure', () async {
      final manager = MockProcessManager();
      final entity = MockEntity();
      when(() => entity.existsAll).thenReturn(true);
      final dataTransferObject = MockDataTransferObject();
      when(() => dataTransferObject.existsAny).thenReturn(false);
      final barrelFile = MockDartFile();
      final infrastructurePackage = MockInfrastructurePackage(
        dataTransferObject: ({required entityName}) => dataTransferObject,
      );
      when(() => infrastructurePackage.barrelFile).thenReturn(barrelFile);
      final project = MockRapidProject(
        appModule: MockAppModule(
          domainDirectory: MockDomainDirectory(
            domainPackage: ({name}) => MockDomainPackage(
              entity: ({required name}) => entity,
            ),
          ),
          infrastructureDirectory: MockInfrastructureDirectory(
            infrastructurePackage: ({name}) => infrastructurePackage,
          ),
        ),
      );
      final logger = MockRapidLogger();
      final rapid = getRapid(project: project, logger: logger);

      await withMockProcessManager(
        () async => rapid.infrastructureSubInfrastructureAddDataTransferObject(
          subInfrastructureName: 'foo_bar',
          entityName: 'Cool',
        ),
        manager: manager,
      );

      verifyInOrder([
        () => logger.newLine(),
        () => dataTransferObject.generate(),
        () => barrelFile.addExport('src/cool_dto.dart'),
        () => dartFormatFixTask(manager),
        () => logger.newLine(),
        () => logger.commandSuccess('Added Data Transfer Object!')
      ]);
    });

    test(
        'throws DataTransferObjectAlreadyExistsException when data transfer object already exists',
        () async {
      final entity = MockEntity();
      when(() => entity.existsAll).thenReturn(true);
      final dataTransferObject = MockDataTransferObject();
      when(() => dataTransferObject.existsAny).thenReturn(true);
      final infrastructurePackage = MockInfrastructurePackage(
        dataTransferObject: ({required entityName}) => dataTransferObject,
      );
      final project = MockRapidProject(
        appModule: MockAppModule(
          domainDirectory: MockDomainDirectory(
            domainPackage: ({name}) => MockDomainPackage(
              entity: ({required name}) => entity,
            ),
          ),
          infrastructureDirectory: MockInfrastructureDirectory(
            infrastructurePackage: ({name}) => infrastructurePackage,
          ),
        ),
      );
      final rapid = getRapid(project: project);

      expect(
        () => rapid.infrastructureSubInfrastructureAddDataTransferObject(
          subInfrastructureName: 'foo_bar',
          entityName: 'Cool',
        ),
        throwsA(isA<DataTransferObjectAlreadyExistsException>()),
      );
    });

    test('throws EntityNotFoundException when entity does not exist', () async {
      final entity = MockEntity();
      when(() => entity.existsAll).thenReturn(false);
      final project = MockRapidProject(
        appModule: MockAppModule(
          domainDirectory: MockDomainDirectory(
            domainPackage: ({name}) => MockDomainPackage(
              entity: ({required name}) => entity,
            ),
          ),
        ),
      );
      final rapid = getRapid(project: project);

      expect(
        () => rapid.infrastructureSubInfrastructureAddDataTransferObject(
          subInfrastructureName: 'foo_bar',
          entityName: 'Cool',
        ),
        throwsA(isA<EntityNotFoundException>()),
      );
    });
  });

  group('infrastructureSubInfrastructureAddServiceImplementation', () {
    test('adds service implementation to sub-infrastructure', () async {
      final manager = MockProcessManager();
      final serviceImplementation = MockServiceImplementation();
      when(() => serviceImplementation.existsAny).thenReturn(false);
      final barrelFile = MockDartFile();
      final infrastructurePackage = MockInfrastructurePackage(
        serviceImplementation: (
                {required name, required serviceInterfaceName}) =>
            serviceImplementation,
      );
      when(() => infrastructurePackage.barrelFile).thenReturn(barrelFile);
      final serviceInterface = MockServiceInterface();
      when(() => serviceInterface.existsAll).thenReturn(true);
      final project = MockRapidProject(
        appModule: MockAppModule(
          domainDirectory: MockDomainDirectory(
            domainPackage: ({name}) => MockDomainPackage(
              serviceInterface: ({required name}) => serviceInterface,
            ),
          ),
          infrastructureDirectory: MockInfrastructureDirectory(
            infrastructurePackage: ({name}) => infrastructurePackage,
          ),
        ),
      );
      final logger = MockRapidLogger();
      final rapid = getRapid(project: project, logger: logger);

      await withMockProcessManager(
        () async =>
            rapid.infrastructureSubInfrastructureAddServiceImplementation(
          name: 'Fake',
          subInfrastructureName: 'foo_bar',
          serviceInterfaceName: 'Cool',
        ),
        manager: manager,
      );

      verifyInOrder([
        () => logger.newLine(),
        () => serviceImplementation.generate(),
        () => barrelFile.addExport('src/fake_cool_service.dart'),
        () => dartFormatFixTask(manager),
        () => logger.newLine(),
        () => logger.commandSuccess('Added Service Implementation!')
      ]);
    });

    test(
        'throws ServiceImplementationAlreadyExistsException when implementation already exists',
        () async {
      final serviceImplementation = MockServiceImplementation();
      when(() => serviceImplementation.existsAny).thenReturn(true);
      final infrastructurePackage = MockInfrastructurePackage(
        serviceImplementation: ({
          required name,
          required serviceInterfaceName,
        }) =>
            serviceImplementation,
      );
      final serviceInterface = MockServiceInterface();
      when(() => serviceInterface.existsAll).thenReturn(true);

      final project = MockRapidProject(
        appModule: MockAppModule(
          domainDirectory: MockDomainDirectory(
            domainPackage: ({name}) => MockDomainPackage(
              serviceInterface: ({required name}) => serviceInterface,
            ),
          ),
          infrastructureDirectory: MockInfrastructureDirectory(
            infrastructurePackage: ({name}) => infrastructurePackage,
          ),
        ),
      );
      final rapid = getRapid(project: project);

      expect(
        () => rapid.infrastructureSubInfrastructureAddServiceImplementation(
          name: 'Fake',
          subInfrastructureName: 'foo_bar',
          serviceInterfaceName: 'Cool',
        ),
        throwsA(isA<ServiceImplementationAlreadyExistsException>()),
      );
    });

    test(
        'throws ServiceInterfaceNotFoundException when service interface does not exist',
        () async {
      final infrastructurePackage = MockInfrastructurePackage();
      final serviceInterface = MockServiceInterface();
      when(() => serviceInterface.existsAll).thenReturn(false);

      final project = MockRapidProject(
        appModule: MockAppModule(
          domainDirectory: MockDomainDirectory(
            domainPackage: ({name}) => MockDomainPackage(
              serviceInterface: ({required name}) => serviceInterface,
            ),
          ),
          infrastructureDirectory: MockInfrastructureDirectory(
            infrastructurePackage: ({name}) => infrastructurePackage,
          ),
        ),
      );
      final rapid = getRapid(project: project);

      expect(
        () => rapid.infrastructureSubInfrastructureAddServiceImplementation(
          name: 'Fake',
          subInfrastructureName: 'foo_bar',
          serviceInterfaceName: 'Cool',
        ),
        throwsA(isA<ServiceInterfaceNotFoundException>()),
      );
    });
  });

  group('infrastructureSubInfrastructureRemoveDataTransferObject', () {
    test('removes data transfer object from sub-infrastructure', () async {
      final manager = MockProcessManager();
      final dataTransferObject = MockDataTransferObject();
      when(() => dataTransferObject.existsAny).thenReturn(true);
      final barrelFile = MockDartFile();
      final infrastructurePackage = MockInfrastructurePackage(
        dataTransferObject: ({required entityName}) => dataTransferObject,
        barrelFile: barrelFile,
      );
      final project = MockRapidProject(
        appModule: MockAppModule(
          domainDirectory: MockDomainDirectory(
            domainPackage: ({name}) => MockDomainPackage(),
          ),
          infrastructureDirectory: MockInfrastructureDirectory(
            infrastructurePackage: ({name}) => infrastructurePackage,
          ),
        ),
      );
      final logger = MockRapidLogger();
      final rapid = getRapid(project: project, logger: logger);

      await withMockProcessManager(
        () async =>
            rapid.infrastructureSubInfrastructureRemoveDataTransferObject(
          subInfrastructureName: 'foo',
          entityName: 'Cool',
        ),
        manager: manager,
      );

      verifyInOrder([
        () => logger.newLine(),
        () => barrelFile.removeExport('src/cool_dto.dart'),
        () => dataTransferObject.delete(),
        () => dartFormatFixTask(manager),
        () => logger.newLine(),
        () => logger.commandSuccess('Removed Data Transfer Object!')
      ]);
    });

    test(
        'throws DataTransferObjectNotFoundException when data transfer object does not exist',
        () async {
      final dataTransferObject = MockDataTransferObject();
      when(() => dataTransferObject.existsAny).thenReturn(false);
      final infrastructurePackage = MockInfrastructurePackage(
        dataTransferObject: ({required entityName}) => dataTransferObject,
      );

      final project = MockRapidProject(
        appModule: MockAppModule(
          domainDirectory: MockDomainDirectory(
            domainPackage: ({name}) => MockDomainPackage(),
          ),
          infrastructureDirectory: MockInfrastructureDirectory(
            infrastructurePackage: ({name}) => infrastructurePackage,
          ),
        ),
      );
      final rapid = getRapid(project: project);

      expect(
        () => rapid.infrastructureSubInfrastructureRemoveDataTransferObject(
          subInfrastructureName: 'foo_bar',
          entityName: 'Cool',
        ),
        throwsA(isA<DataTransferObjectNotFoundException>()),
      );
    });
  });

  group('infrastructureSubInfrastructureRemoveServiceImplementation', () {
    test('removes service implementation from sub-infrastructure', () async {
      final manager = MockProcessManager();
      final serviceImplementation = MockServiceImplementation();
      when(() => serviceImplementation.existsAny).thenReturn(true);
      final barrelFile = MockDartFile();
      final infrastructurePackage = MockInfrastructurePackage(
        serviceImplementation: ({
          required name,
          required serviceInterfaceName,
        }) =>
            serviceImplementation,
        barrelFile: barrelFile,
      );
      final project = MockRapidProject(
        appModule: MockAppModule(
          domainDirectory: MockDomainDirectory(
            domainPackage: ({name}) => MockDomainPackage(),
          ),
          infrastructureDirectory: MockInfrastructureDirectory(
            infrastructurePackage: ({name}) => infrastructurePackage,
          ),
        ),
      );
      final logger = MockRapidLogger();
      final rapid = getRapid(project: project, logger: logger);

      await withMockProcessManager(
        () async =>
            rapid.infrastructureSubInfrastructureRemoveServiceImplementation(
          name: 'Fake',
          subInfrastructureName: 'foo_bar',
          serviceInterfaceName: 'Cool',
        ),
        manager: manager,
      );

      verifyInOrder([
        () => logger.newLine(),
        () => barrelFile.removeExport('src/fake_cool_service.dart'),
        () => serviceImplementation.delete(),
        () => dartFormatFixTask(manager),
        () => logger.newLine(),
        () => logger.commandSuccess('Removed Service Implementation!')
      ]);
    });

    test(
        'throws ServiceImplementationNotFoundException when service implementation does not exist',
        () async {
      final serviceImplementation = MockServiceImplementation();
      when(() => serviceImplementation.existsAny).thenReturn(false);
      final infrastructurePackage = MockInfrastructurePackage(
        serviceImplementation: (
                {required name, required serviceInterfaceName}) =>
            serviceImplementation,
      );

      final project = MockRapidProject(
        appModule: MockAppModule(
          domainDirectory: MockDomainDirectory(
            domainPackage: ({name}) => MockDomainPackage(),
          ),
          infrastructureDirectory: MockInfrastructureDirectory(
            infrastructurePackage: ({name}) => infrastructurePackage,
          ),
        ),
      );
      final rapid = getRapid(project: project);

      expect(
        () => rapid.infrastructureSubInfrastructureRemoveServiceImplementation(
          name: 'Fake',
          subInfrastructureName: 'foo_bar',
          serviceInterfaceName: 'Cool',
        ),
        throwsA(isA<ServiceImplementationNotFoundException>()),
      );
    });
  });
}
