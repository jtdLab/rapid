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

  group('domainAddSubDomain', () {
    test('adds subdomain', () async {
      final manager = MockProcessManager();
      final domainPackage = MockDomainPackage();
      when(() => domainPackage.existsSync()).thenReturn(false);
      final infrastructurePackage = MockInfrastructurePackage();
      when(() => infrastructurePackage.existsSync()).thenReturn(false);
      final rootPackage1 = MockNoneIosRootPackage();
      final rootPackage2 = MockIosRootPackage();
      final rootPackages = [rootPackage1, rootPackage2];
      final project = MockRapidProject(
        appModule: MockAppModule(
          domainDirectory: MockDomainDirectory(
            domainPackage: ({name}) => domainPackage,
          ),
          infrastructureDirectory: MockInfrastructureDirectory(
            infrastructurePackage: ({name}) => infrastructurePackage,
          ),
        ),
        rootPackages: rootPackages,
      );
      final logger = MockRapidLogger();
      final group = MockCommandGroup();
      when(() => group.isActive).thenReturn(false);
      final tool = MockRapidTool();
      when(() => tool.loadGroup()).thenReturn(group);
      final melosBootstrapTaskInvocations = setupMelosBootstrapTask(
        manager,
        scope: [
          domainPackage,
          infrastructurePackage,
          ...rootPackages,
        ],
        logger: logger,
      );
      final melosBootstrapTaskInCommandGroupInvocations =
          setupMelosBootstrapTaskInCommandGroup(
        manager,
        scope: [
          domainPackage,
          infrastructurePackage,
          ...rootPackages,
        ],
        tool: tool,
      );
      final codeGenTaskGroupInvocations =
          setupFlutterPubRunBuildRunnerBuildTaskGroup(
        manager,
        packages: rootPackages,
        logger: logger,
      );
      final codeGenTaskGroupInCommandGroupInvocations =
          setupFlutterPubRunBuildRunnerBuildTaskGroupInCommandGroup(
        manager,
        packages: rootPackages,
        tool: tool,
      );
      final rapid = getRapid(
        project: project,
        tool: tool,
        logger: logger,
      );

      await withMockProcessManager(
        () async => rapid.domainAddSubDomain(name: 'foo_bar'),
        manager: manager,
      );

      verifyInOrder([
        () => logger.newLine(),
        () => domainPackage.generate(),
        () => infrastructurePackage.generate(),
        () => rootPackage1.registerInfrastructurePackage(infrastructurePackage),
        () => rootPackage2.registerInfrastructurePackage(infrastructurePackage),
        ...melosBootstrapTaskInvocations,
        ...codeGenTaskGroupInvocations,
        () => dartFormatFixTask(manager),
        () => logger.newLine(),
        () => logger.commandSuccess('Added Sub Domain!')
      ]);
      verifyNeverMulti(melosBootstrapTaskInCommandGroupInvocations);
      verifyNeverMulti(codeGenTaskGroupInCommandGroupInvocations);
    });

    test('adds subdomain (inside command group)', () async {
      final manager = MockProcessManager();
      final domainPackage = MockDomainPackage();
      when(() => domainPackage.existsSync()).thenReturn(false);
      final infrastructurePackage = MockInfrastructurePackage();
      when(() => infrastructurePackage.existsSync()).thenReturn(false);
      final rootPackage1 = MockNoneIosRootPackage();
      final rootPackage2 = MockIosRootPackage();
      final rootPackages = [rootPackage1, rootPackage2];
      final project = MockRapidProject(
        appModule: MockAppModule(
          domainDirectory: MockDomainDirectory(
            domainPackage: ({name}) => domainPackage,
          ),
          infrastructureDirectory: MockInfrastructureDirectory(
            infrastructurePackage: ({name}) => infrastructurePackage,
          ),
        ),
        rootPackages: rootPackages,
      );
      final logger = MockRapidLogger();
      final group = MockCommandGroup();
      when(() => group.isActive).thenReturn(true);
      final tool = MockRapidTool();
      when(() => tool.loadGroup()).thenReturn(group);
      final melosBootstrapTaskInvocations = setupMelosBootstrapTask(
        manager,
        scope: [
          domainPackage,
          infrastructurePackage,
          ...rootPackages,
        ],
        logger: logger,
      );
      final melosBootstrapTaskInCommandGroupInvocations =
          setupMelosBootstrapTaskInCommandGroup(
        manager,
        scope: [
          domainPackage,
          infrastructurePackage,
          ...rootPackages,
        ],
        tool: tool,
      );
      final codeGenTaskGroupInvocations =
          setupFlutterPubRunBuildRunnerBuildTaskGroup(
        manager,
        packages: rootPackages,
        logger: logger,
      );
      final codeGenTaskGroupInCommandGroupInvocations =
          setupFlutterPubRunBuildRunnerBuildTaskGroupInCommandGroup(
        manager,
        packages: rootPackages,
        tool: tool,
      );
      final rapid = getRapid(
        project: project,
        tool: tool,
        logger: logger,
      );

      await withMockProcessManager(
        () async => rapid.domainAddSubDomain(name: 'foo_bar'),
        manager: manager,
      );

      verifyInOrder([
        () => logger.newLine(),
        () => domainPackage.generate(),
        () => infrastructurePackage.generate(),
        () => rootPackage1.registerInfrastructurePackage(infrastructurePackage),
        () => rootPackage2.registerInfrastructurePackage(infrastructurePackage),
        ...melosBootstrapTaskInCommandGroupInvocations,
        ...codeGenTaskGroupInCommandGroupInvocations,
        () => dartFormatFixTask(manager),
        () => logger.newLine(),
        () => logger.commandSuccess('Added Sub Domain!')
      ]);
      verifyNeverMulti(melosBootstrapTaskInvocations);
      verifyNeverMulti(codeGenTaskGroupInvocations);
    });

    test(
        'throws SubDomainAlreadyExistsException when domain package already exists',
        () async {
      final domainPackage = MockDomainPackage();
      when(() => domainPackage.existsSync()).thenReturn(true);
      final project = MockRapidProject(
        appModule: MockAppModule(
          domainDirectory: MockDomainDirectory(
            domainPackage: ({name}) => domainPackage,
          ),
        ),
      );
      final rapid = getRapid(project: project);

      expect(
        () => rapid.domainAddSubDomain(name: 'foo_bar'),
        throwsA(isA<SubDomainAlreadyExistsException>()),
      );
    });

    test(
        'throws SubInfrastructureAlreadyExistsException when infrastructure package already exists',
        () async {
      final domainPackage = MockDomainPackage();
      when(() => domainPackage.existsSync()).thenReturn(false);
      final infrastructurePackage = MockInfrastructurePackage();
      when(() => infrastructurePackage.existsSync()).thenReturn(true);
      final project = MockRapidProject(
        appModule: MockAppModule(
          domainDirectory: MockDomainDirectory(
            domainPackage: ({name}) => domainPackage,
          ),
          infrastructureDirectory: MockInfrastructureDirectory(
            infrastructurePackage: ({name}) => infrastructurePackage,
          ),
        ),
      );
      final rapid = getRapid(project: project);

      expect(
        () => rapid.domainAddSubDomain(name: 'foo_bar'),
        throwsA(isA<SubInfrastructureAlreadyExistsException>()),
      );
    });
  });

  group('domainRemoveSubDomain', () {
    test('removes subdomain', () async {
      final manager = MockProcessManager();
      final domainPackage = MockDomainPackage();
      when(() => domainPackage.existsSync()).thenReturn(true);
      final infrastructurePackage = MockInfrastructurePackage();
      when(() => infrastructurePackage.existsSync()).thenReturn(true);
      final rootPackage1 = MockNoneIosRootPackage();
      final rootPackage2 = MockIosRootPackage();
      final rootPackages = [rootPackage1, rootPackage2];
      final project = MockRapidProject(
        appModule: MockAppModule(
          domainDirectory: MockDomainDirectory(
            domainPackage: ({name}) => domainPackage,
          ),
          infrastructureDirectory: MockInfrastructureDirectory(
            infrastructurePackage: ({name}) => infrastructurePackage,
          ),
        ),
        rootPackages: rootPackages,
      );
      final logger = MockRapidLogger();
      final group = MockCommandGroup();
      when(() => group.isActive).thenReturn(false);
      final tool = MockRapidTool();
      when(() => tool.loadGroup()).thenReturn(group);
      final melosBootstrapTaskInvocations = setupMelosBootstrapTask(
        manager,
        scope: rootPackages,
        logger: logger,
      );
      final melosBootstrapTaskInCommandGroupInvocations =
          setupMelosBootstrapTaskInCommandGroup(
        manager,
        scope: rootPackages,
        tool: tool,
      );
      final codeGenTaskGroupInvocations =
          setupFlutterPubRunBuildRunnerBuildTaskGroup(
        manager,
        packages: rootPackages,
        logger: logger,
      );
      final codeGenTaskGroupInCommandGroupInvocations =
          setupFlutterPubRunBuildRunnerBuildTaskGroupInCommandGroup(
        manager,
        packages: rootPackages,
        tool: tool,
      );
      final rapid = getRapid(
        project: project,
        tool: tool,
        logger: logger,
      );

      await withMockProcessManager(
        () async => rapid.domainRemoveSubDomain(name: 'foo_bar'),
        manager: manager,
      );

      verifyInOrder([
        () => logger.newLine(),
        () => domainPackage.deleteSync(recursive: true),
        () =>
            rootPackage1.unregisterInfrastructurePackage(infrastructurePackage),
        () =>
            rootPackage2.unregisterInfrastructurePackage(infrastructurePackage),
        () => infrastructurePackage.deleteSync(recursive: true),
        ...melosBootstrapTaskInvocations,
        ...codeGenTaskGroupInvocations,
        () => dartFormatFixTask(manager),
        () => logger.newLine(),
        () => logger.commandSuccess('Removed Sub Domain!')
      ]);
      verifyNeverMulti(melosBootstrapTaskInCommandGroupInvocations);
      verifyNeverMulti(codeGenTaskGroupInCommandGroupInvocations);
    });

    test('removes subdomain (inside command group)', () async {
      final manager = MockProcessManager();
      final domainPackage = MockDomainPackage();
      when(() => domainPackage.existsSync()).thenReturn(true);
      final infrastructurePackage = MockInfrastructurePackage();
      when(() => infrastructurePackage.existsSync()).thenReturn(true);
      final rootPackage1 = MockNoneIosRootPackage();
      final rootPackage2 = MockIosRootPackage();
      final rootPackages = [rootPackage1, rootPackage2];
      final project = MockRapidProject(
        appModule: MockAppModule(
          domainDirectory: MockDomainDirectory(
            domainPackage: ({name}) => domainPackage,
          ),
          infrastructureDirectory: MockInfrastructureDirectory(
            infrastructurePackage: ({name}) => infrastructurePackage,
          ),
        ),
        rootPackages: rootPackages,
      );
      final logger = MockRapidLogger();
      final group = MockCommandGroup();
      when(() => group.isActive).thenReturn(true);
      final tool = MockRapidTool();
      when(() => tool.loadGroup()).thenReturn(group);
      final melosBootstrapTaskInvocations = setupMelosBootstrapTask(
        manager,
        scope: rootPackages,
        logger: logger,
      );
      final melosBootstrapTaskInCommandGroupInvocations =
          setupMelosBootstrapTaskInCommandGroup(
        manager,
        scope: rootPackages,
        tool: tool,
      );
      final codeGenTaskGroupInvocations =
          setupFlutterPubRunBuildRunnerBuildTaskGroup(
        manager,
        packages: rootPackages,
        logger: logger,
      );
      final codeGenTaskGroupInCommandGroupInvocations =
          setupFlutterPubRunBuildRunnerBuildTaskGroupInCommandGroup(
        manager,
        packages: rootPackages,
        tool: tool,
      );
      final rapid = getRapid(
        project: project,
        tool: tool,
        logger: logger,
      );

      await withMockProcessManager(
        () async => rapid.domainRemoveSubDomain(name: 'foo_bar'),
        manager: manager,
      );

      verifyInOrder([
        () => logger.newLine(),
        () => domainPackage.deleteSync(recursive: true),
        () =>
            rootPackage1.unregisterInfrastructurePackage(infrastructurePackage),
        () =>
            rootPackage2.unregisterInfrastructurePackage(infrastructurePackage),
        () => infrastructurePackage.deleteSync(recursive: true),
        ...melosBootstrapTaskInCommandGroupInvocations,
        ...codeGenTaskGroupInCommandGroupInvocations,
        () => dartFormatFixTask(manager),
        () => logger.newLine(),
        () => logger.commandSuccess('Removed Sub Domain!')
      ]);
      verifyNeverMulti(melosBootstrapTaskInvocations);
      verifyNeverMulti(codeGenTaskGroupInvocations);
    });

    test('throws SubDomainNotFoundException when domain package does not exist',
        () async {
      final domainPackage = MockDomainPackage();
      when(() => domainPackage.existsSync()).thenReturn(false);
      final project = MockRapidProject(
        appModule: MockAppModule(
          domainDirectory: MockDomainDirectory(
            domainPackage: ({name}) => domainPackage,
          ),
        ),
      );
      final rapid = getRapid(project: project);

      expect(
        () => rapid.domainRemoveSubDomain(name: 'foo_bar'),
        throwsA(isA<SubDomainNotFoundException>()),
      );
    });

    test(
        'throws SubInfrastructureNotFoundException when infrastructure package does not exist',
        () async {
      final domainPackage = MockDomainPackage();
      when(() => domainPackage.existsSync()).thenReturn(true);
      final infrastructurePackage = MockInfrastructurePackage();
      when(() => infrastructurePackage.existsSync()).thenReturn(false);
      final project = MockRapidProject(
        appModule: MockAppModule(
          domainDirectory: MockDomainDirectory(
            domainPackage: ({name}) => domainPackage,
          ),
          infrastructureDirectory: MockInfrastructureDirectory(
            infrastructurePackage: ({name}) => infrastructurePackage,
          ),
        ),
      );
      final rapid = getRapid(project: project);

      expect(
        () => rapid.domainRemoveSubDomain(name: 'foo_bar'),
        throwsA(isA<SubInfrastructureNotFoundException>()),
      );
    });
  });

  group('domainSubDomainAddEntity', () {
    test('adds entity to subdomain', () async {
      final manager = MockProcessManager();
      final entity = MockEntity();
      when(() => entity.existsAny).thenReturn(false);
      final barrelFile = MockDartFile();
      final domainPackage = MockDomainPackage(
        entity: ({required name}) => entity,
      );
      when(() => domainPackage.barrelFile).thenReturn(barrelFile);
      final project = MockRapidProject(
        appModule: MockAppModule(
          domainDirectory: MockDomainDirectory(
            domainPackage: ({name}) => domainPackage,
          ),
        ),
      );
      final logger = MockRapidLogger();
      final rapid = getRapid(project: project, logger: logger);

      await withMockProcessManager(
        () async => rapid.domainSubDomainAddEntity(
          name: 'Cool',
          subDomainName: 'foo_bar',
        ),
        manager: manager,
      );

      verifyInOrder([
        () => logger.newLine(),
        () => entity.generate(),
        () => barrelFile.addExport('src/cool.dart'),
        () => dartFormatFixTask(manager),
        () => logger.newLine(),
        () => logger.commandSuccess('Added Entity!')
      ]);
    });

    test(
        'throws EntityOrValueObjectAlreadyExistsException when entity already exists',
        () async {
      final entity = MockEntity();
      when(() => entity.existsAny).thenReturn(true);
      final domainPackage = MockDomainPackage(
        entity: ({required name}) => entity,
      );

      final project = MockRapidProject(
        appModule: MockAppModule(
          domainDirectory: MockDomainDirectory(
            domainPackage: ({name}) => domainPackage,
          ),
        ),
      );
      final rapid = getRapid(project: project);

      expect(
        () => rapid.domainSubDomainAddEntity(
          name: 'Cool',
          subDomainName: 'foo_bar',
        ),
        throwsA(isA<EntityOrValueObjectAlreadyExistsException>()),
      );
    });
  });

  group('domainSubDomainAddServiceInterface', () {
    test('adds service interface to subdomain', () async {
      final manager = MockProcessManager();
      final serviceInterface = MockServiceInterface();
      when(() => serviceInterface.existsAny).thenReturn(false);
      final barrelFile = MockDartFile();
      final domainPackage = MockDomainPackage(
        serviceInterface: ({required name}) => serviceInterface,
        barrelFile: barrelFile,
      );

      final project = MockRapidProject(
        appModule: MockAppModule(
          domainDirectory: MockDomainDirectory(
            domainPackage: ({name}) => domainPackage,
          ),
        ),
      );
      final logger = MockRapidLogger();
      final rapid = getRapid(project: project, logger: logger);

      await withMockProcessManager(
        () async => rapid.domainSubDomainAddServiceInterface(
          name: 'Cool',
          subDomainName: 'foo_bar',
        ),
        manager: manager,
      );

      verifyInOrder([
        () => logger.newLine(),
        () => serviceInterface.generate(),
        () => barrelFile.addExport('src/i_cool_service.dart'),
        () => dartFormatFixTask(manager),
        () => logger.newLine(),
        () => logger.commandSuccess('Added Service Interface!')
      ]);
    });

    test(
        'throws ServiceInterfaceAlreadyExistsException when service interface already exists',
        () async {
      final serviceInterface = MockServiceInterface();
      when(() => serviceInterface.existsAny).thenReturn(true);
      final domainPackage = MockDomainPackage(
        serviceInterface: ({required name}) => serviceInterface,
      );

      final project = MockRapidProject(
        appModule: MockAppModule(
          domainDirectory: MockDomainDirectory(
            domainPackage: ({name}) => domainPackage,
          ),
        ),
      );
      final rapid = getRapid(project: project);

      expect(
        () => rapid.domainSubDomainAddServiceInterface(
          name: 'Cool',
          subDomainName: 'foo_bar',
        ),
        throwsA(isA<ServiceInterfaceAlreadyExistsException>()),
      );
    });
  });

  group('domainSubDomainAddValueObject', () {
    test('adds value object to subdomain', () async {
      final manager = MockProcessManager();
      final valueObject = MockValueObject();
      when(() => valueObject.existsAny).thenReturn(false);
      final barrelFile = MockDartFile();
      final domainPackage = MockDomainPackage(
        valueObject: ({required name}) => valueObject,
        barrelFile: barrelFile,
      );

      final project = MockRapidProject(
        appModule: MockAppModule(
          domainDirectory: MockDomainDirectory(
            domainPackage: ({name}) => domainPackage,
          ),
        ),
      );
      final logger = MockRapidLogger();
      final group = MockCommandGroup();
      when(() => group.isActive).thenReturn(false);
      final tool = MockRapidTool();
      when(() => tool.loadGroup()).thenReturn(group);
      final codeGenTaskInvocations = setupFlutterPubRunBuildRunnerBuildTask(
        manager,
        package: domainPackage,
        logger: logger,
      );
      final codeGenTaskInCommandGroupInvocations =
          setupFlutterPubRunBuildRunnerBuildTaskInCommandGroup(
        manager,
        package: domainPackage,
        tool: tool,
      );
      final rapid = getRapid(
        project: project,
        tool: tool,
        logger: logger,
      );

      await withMockProcessManager(
        () async => rapid.domainSubDomainAddValueObject(
          name: 'Cool',
          subDomainName: 'foo_bar',
          type: 'String',
          generics: '<T>',
        ),
        manager: manager,
      );

      verifyInOrder([
        () => logger.newLine(),
        () => valueObject.generate(type: 'String', generics: '<T>'),
        () => barrelFile.addExport('src/cool.dart'),
        ...codeGenTaskInvocations,
        () => dartFormatFixTask(manager),
        () => logger.newLine(),
        () => logger.commandSuccess('Added Value Object!')
      ]);
      verifyNeverMulti(codeGenTaskInCommandGroupInvocations);
    });

    test('adds value object to subdomain (inside command group)', () async {
      final manager = MockProcessManager();
      final valueObject = MockValueObject();
      when(() => valueObject.existsAny).thenReturn(false);
      final barrelFile = MockDartFile();
      final domainPackage = MockDomainPackage(
        valueObject: ({required name}) => valueObject,
        barrelFile: barrelFile,
      );

      final project = MockRapidProject(
        appModule: MockAppModule(
          domainDirectory: MockDomainDirectory(
            domainPackage: ({name}) => domainPackage,
          ),
        ),
      );
      final logger = MockRapidLogger();
      final group = MockCommandGroup();
      when(() => group.isActive).thenReturn(true);
      final tool = MockRapidTool();
      when(() => tool.loadGroup()).thenReturn(group);
      final codeGenTaskInvocations = setupFlutterPubRunBuildRunnerBuildTask(
        manager,
        package: domainPackage,
        logger: logger,
      );
      final codeGenTaskInCommandGroupInvocations =
          setupFlutterPubRunBuildRunnerBuildTaskInCommandGroup(
        manager,
        package: domainPackage,
        tool: tool,
      );
      final rapid = getRapid(
        project: project,
        tool: tool,
        logger: logger,
      );

      await withMockProcessManager(
        () async => rapid.domainSubDomainAddValueObject(
          name: 'Cool',
          subDomainName: 'foo_bar',
          type: 'String',
          generics: '<T>',
        ),
        manager: manager,
      );

      verifyInOrder([
        () => logger.newLine(),
        () => valueObject.generate(type: 'String', generics: '<T>'),
        () => barrelFile.addExport('src/cool.dart'),
        ...codeGenTaskInCommandGroupInvocations,
        () => dartFormatFixTask(manager),
        () => logger.newLine(),
        () => logger.commandSuccess('Added Value Object!')
      ]);
      verifyNeverMulti(codeGenTaskInvocations);
    });

    test(
        'throws EntityOrValueObjectAlreadyExistsException when value object already exists',
        () async {
      final valueObject = MockValueObject();
      when(() => valueObject.existsAny).thenReturn(true);
      final domainPackage = MockDomainPackage(
        valueObject: ({required name}) => valueObject,
      );

      final project = MockRapidProject(
        appModule: MockAppModule(
          domainDirectory: MockDomainDirectory(
            domainPackage: ({name}) => domainPackage,
          ),
        ),
      );
      final rapid = getRapid(project: project);

      expect(
        () => rapid.domainSubDomainAddValueObject(
          name: 'Cool',
          subDomainName: 'foo_bar',
          type: 'String',
          generics: '<T>',
        ),
        throwsA(isA<EntityOrValueObjectAlreadyExistsException>()),
      );
    });
  });

  group('domainSubDomainRemoveEntity', () {
    test('removes entity from subdomain', () async {
      final manager = MockProcessManager();
      final entity = MockEntity();
      when(() => entity.existsAny).thenReturn(true);
      final barrelFile = MockDartFile();
      final domainPackage = MockDomainPackage(
        entity: ({required name}) => entity,
        barrelFile: barrelFile,
      );

      final project = MockRapidProject(
        appModule: MockAppModule(
          domainDirectory: MockDomainDirectory(
            domainPackage: ({name}) => domainPackage,
          ),
        ),
      );
      final logger = MockRapidLogger();
      final rapid = getRapid(project: project, logger: logger);

      await withMockProcessManager(
        () async => rapid.domainSubDomainRemoveEntity(
          name: 'Cool',
          subDomainName: 'foo_bar',
        ),
        manager: manager,
      );

      verifyInOrder([
        () => logger.newLine(),
        () => entity.delete(),
        () => barrelFile.removeExport('src/cool.dart'),
        () => dartFormatFixTask(manager),
        () => logger.newLine(),
        () => logger.commandSuccess('Removed Entity!')
      ]);
    });

    test('throws EntityNotFoundException when entity does not exist', () async {
      final entity = MockEntity();
      when(() => entity.existsAny).thenReturn(false);
      final domainPackage = MockDomainPackage(
        entity: ({required name}) => entity,
      );

      final project = MockRapidProject(
        appModule: MockAppModule(
          domainDirectory: MockDomainDirectory(
            domainPackage: ({name}) => domainPackage,
          ),
        ),
      );
      final rapid = getRapid(project: project);

      expect(
        () => rapid.domainSubDomainRemoveEntity(
          name: 'Cool',
          subDomainName: 'foo_bar',
        ),
        throwsA(isA<EntityNotFoundException>()),
      );
    });
  });

  group('domainSubDomainRemoveServiceInterface', () {
    test('removes service interface from subdomain', () async {
      final manager = MockProcessManager();

      final serviceInterface = MockServiceInterface();
      when(() => serviceInterface.existsAny).thenReturn(true);
      final barrelFile = MockDartFile();
      final domainPackage = MockDomainPackage(
        serviceInterface: ({required name}) => serviceInterface,
        barrelFile: barrelFile,
      );

      final project = MockRapidProject(
        appModule: MockAppModule(
          domainDirectory: MockDomainDirectory(
            domainPackage: ({name}) => domainPackage,
          ),
        ),
      );
      final logger = MockRapidLogger();
      final rapid = getRapid(project: project, logger: logger);

      await withMockProcessManager(
        () async => rapid.domainSubDomainRemoveServiceInterface(
          name: 'Cool',
          subDomainName: 'foo_bar',
        ),
        manager: manager,
      );

      verifyInOrder([
        () => logger.newLine(),
        () => serviceInterface.delete(),
        () => barrelFile.removeExport('src/i_cool_service.dart'),
        () => dartFormatFixTask(manager),
        () => logger.newLine(),
        () => logger.commandSuccess('Removed Service Interface!')
      ]);
    });

    test(
        'throws ServiceInterfaceNotFoundException when service interface does not exist',
        () async {
      final serviceInterface = MockServiceInterface();

      when(() => serviceInterface.existsAny).thenReturn(false);
      final domainPackage = MockDomainPackage(
          serviceInterface: ({required name}) => serviceInterface);

      final project = MockRapidProject(
        appModule: MockAppModule(
          domainDirectory: MockDomainDirectory(
            domainPackage: ({name}) => domainPackage,
          ),
        ),
      );
      final rapid = getRapid(project: project);

      expect(
        () => rapid.domainSubDomainRemoveServiceInterface(
          name: 'Cool',
          subDomainName: 'foo_bar',
        ),
        throwsA(isA<ServiceInterfaceNotFoundException>()),
      );
    });
  });

  group('domainSubDomainRemoveValueObject', () {
    test('removes value object from subdomain', () async {
      final manager = MockProcessManager();
      final valueObject = MockValueObject();
      when(() => valueObject.existsAny).thenReturn(true);
      final barrelFile = MockDartFile();
      final domainPackage = MockDomainPackage(
        valueObject: ({required name}) => valueObject,
        barrelFile: barrelFile,
      );

      final project = MockRapidProject(
        appModule: MockAppModule(
          domainDirectory: MockDomainDirectory(
            domainPackage: ({name}) => domainPackage,
          ),
        ),
      );
      final logger = MockRapidLogger();
      final rapid = getRapid(project: project, logger: logger);

      await withMockProcessManager(
        () async => rapid.domainSubDomainRemoveValueObject(
          name: 'Cool',
          subDomainName: 'foo_bar',
        ),
        manager: manager,
      );

      verifyInOrder([
        () => logger.newLine(),
        () => valueObject.delete(),
        () => barrelFile.removeExport('src/cool.dart'),
        () => dartFormatFixTask(manager),
        () => logger.newLine(),
        () => logger.commandSuccess('Removed Value Object!')
      ]);
    });

    test('throws ValueObjectNotFoundException when value object does not exist',
        () async {
      final valueObject = MockValueObject();
      when(() => valueObject.existsAny).thenReturn(false);
      final domainPackage = MockDomainPackage(
        valueObject: ({required name}) => valueObject,
      );

      final project = MockRapidProject(
        appModule: MockAppModule(
          domainDirectory: MockDomainDirectory(
            domainPackage: ({name}) => domainPackage,
          ),
        ),
      );
      final rapid = getRapid(project: project);

      expect(
        () => rapid.domainSubDomainRemoveValueObject(
          name: 'Cool',
          subDomainName: 'foo_bar',
        ),
        throwsA(isA<ValueObjectNotFoundException>()),
      );
    });
  });
}
