import 'package:mocktail/mocktail.dart';
import 'package:rapid_cli/src/commands/runner.dart';
import 'package:rapid_cli/src/io/io.dart';
import 'package:rapid_cli/src/project/project.dart';
import 'package:rapid_cli/src/tool.dart';
import 'package:test/test.dart';

import '../mock_env.dart';
import '../mocks.dart';
import '../utils.dart';

// TODO(jtdLab): is it good to use global setup instead
// of setup fcts with records

void main() {
  late Entity entity;
  late ServiceInterface serviceInterface;
  late DataTransferObject dataTransferObject;
  late ServiceImplementation serviceImplementation;
  late DartFile infrastructurePackageBarrelFile;
  late InfrastructurePackage infrastructurePackage;
  late RapidProject project;
  late CommandGroup commandGroup;
  late RapidTool tool;

  setUpAll(registerFallbackValues);

  setUp(() {
    entity = MockEntity();
    when(() => entity.existsAll).thenReturn(true);
    serviceInterface = MockServiceInterface();
    when(() => serviceInterface.existsAll).thenReturn(true);
    dataTransferObject = MockDataTransferObject();
    serviceImplementation = MockServiceImplementation();
    infrastructurePackageBarrelFile = MockDartFile();
    infrastructurePackage = MockInfrastructurePackage(
      packageName: 'infrastructure_package',
      path: 'infrastructure_package_path',
      dataTransferObject: ({required entityName}) => dataTransferObject,
      serviceImplementation: ({required name, required serviceInterfaceName}) =>
          serviceImplementation,
    );
    when(() => infrastructurePackage.barrelFile)
        .thenReturn(infrastructurePackageBarrelFile);
    project = MockRapidProject(
      path: 'project_path',
      appModule: MockAppModule(
        domainDirectory: MockDomainDirectory(
          domainPackage: ({name}) => MockDomainPackage(
            entity: ({required name}) => entity,
            serviceInterface: ({required name}) => serviceInterface,
          ),
        ),
        infrastructureDirectory: MockInfrastructureDirectory(
          infrastructurePackage: ({name}) => infrastructurePackage,
        ),
      ),
    );
    commandGroup = MockCommandGroup();
    when(() => commandGroup.isActive).thenReturn(false);
    tool = MockRapidTool();
    when(() => tool.loadGroup()).thenReturn(commandGroup);
  });

  group('infrastructureSubInfrastructureAddDataTransferObject', () {
    test(
        'throws DataTransferObjectAlreadyExistsException when data transfer '
        'object already exists', () async {
      when(() => dataTransferObject.existsAny).thenReturn(true);
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
      when(() => entity.existsAll).thenReturn(false);
      final rapid = getRapid(project: project);

      expect(
        () => rapid.infrastructureSubInfrastructureAddDataTransferObject(
          subInfrastructureName: 'foo_bar',
          entityName: 'Cool',
        ),
        throwsA(isA<EntityNotFoundException>()),
      );
    });

    test(
      'adds data transfer object to infrastructure package',
      withMockEnv((manager) async {
        when(() => dataTransferObject.existsAny).thenReturn(false);
        final (logger: logger, progress: progress) = setupLoggerWithoutGroup();
        final rapid = getRapid(project: project, logger: logger);

        await rapid.infrastructureSubInfrastructureAddDataTransferObject(
          subInfrastructureName: 'foo_bar',
          entityName: 'Cool',
        );

        verifyInOrder([
          logger.newLine,
          () => logger.progress('Creating data transfer object'),
          () => dataTransferObject.generate(),
          () => infrastructurePackageBarrelFile.addExport('src/cool_dto.dart'),
          progress.complete,
          () => logger.progress('Running "dart format . --fix" in project'),
          () => manager.runDartFormatFix(workingDirectory: 'project_path'),
          progress.complete,
          logger.newLine,
          () => logger.commandSuccess('Added Data Transfer Object!')
        ]);
        verifyNoMoreInteractions(manager);
        verifyNoMoreInteractions(logger);
        verifyNoMoreInteractions(progress);
      }),
    );
  });

  group('infrastructureSubInfrastructureAddServiceImplementation', () {
    test(
        'throws ServiceImplementationAlreadyExistsException when '
        'implementation already exists', () async {
      when(() => serviceImplementation.existsAny).thenReturn(true);
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
        'throws ServiceInterfaceNotFoundException when service interface '
        'does not exist', () async {
      when(() => serviceInterface.existsAll).thenReturn(false);
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

    test(
      'adds service implementation to infrastructure package',
      withMockEnv((manager) async {
        when(() => serviceImplementation.existsAny).thenReturn(false);
        final (logger: logger, progress: progress) = setupLoggerWithoutGroup();
        final rapid = getRapid(project: project, tool: tool, logger: logger);

        await rapid.infrastructureSubInfrastructureAddServiceImplementation(
          name: 'Fake',
          subInfrastructureName: 'foo_bar',
          serviceInterfaceName: 'Cool',
        );

        verifyInOrder([
          logger.newLine,
          () => logger.progress('Creating service implementation'),
          () => serviceImplementation.generate(),
          () => infrastructurePackageBarrelFile
              .addExport('src/fake_cool_service.dart'),
          progress.complete,
          () => logger
              .progress('Running code generation in infrastructure_package'),
          () => manager.runDartRunBuildRunnerBuildDeleteConflictingOutputs(
                workingDirectory: 'infrastructure_package_path',
              ),
          progress.complete,
          () => logger.progress('Running "dart format . --fix" in project'),
          () => manager.runDartFormatFix(workingDirectory: 'project_path'),
          progress.complete,
          logger.newLine,
          () => logger.commandSuccess('Added Service Implementation!')
        ]);
        verifyNoMoreInteractions(manager);
        verifyNoMoreInteractions(logger);
        verifyNoMoreInteractions(progress);
      }),
    );

    group('given command group is active', () {
      setUp(() {
        when(() => commandGroup.isActive).thenReturn(true);
      });

      test(
        'marks infrastructure package as need code gen',
        withMockEnv((_) async {
          when(() => serviceImplementation.existsAny).thenReturn(false);
          final logger = MockRapidLogger();
          final rapid = getRapid(
            project: project,
            tool: tool,
            logger: logger,
          );

          await rapid.infrastructureSubInfrastructureAddServiceImplementation(
            name: 'Fake',
            subInfrastructureName: 'foo_bar',
            serviceInterfaceName: 'Cool',
          );

          verifyInOrder([
            () => tool.markAsNeedCodeGen(package: infrastructurePackage),
          ]);
        }),
      );
    });
  });

  group('infrastructureSubInfrastructureRemoveDataTransferObject', () {
    test(
        'throws DataTransferObjectNotFoundException when data transfer object '
        'does not exist', () async {
      when(() => dataTransferObject.existsAny).thenReturn(false);
      final rapid = getRapid(project: project);

      expect(
        () => rapid.infrastructureSubInfrastructureRemoveDataTransferObject(
          subInfrastructureName: 'foo_bar',
          entityName: 'Cool',
        ),
        throwsA(isA<DataTransferObjectNotFoundException>()),
      );
    });

    test(
      'removes data transfer object from infrastructure package',
      withMockEnv((manager) async {
        when(() => dataTransferObject.existsAny).thenReturn(true);
        final (logger: logger, progress: progress) = setupLoggerWithoutGroup();
        final rapid = getRapid(project: project, logger: logger);

        await rapid.infrastructureSubInfrastructureRemoveDataTransferObject(
          subInfrastructureName: 'foo',
          entityName: 'Cool',
        );

        verifyInOrder([
          logger.newLine,
          () => logger.progress('Deleting data transfer object'),
          () =>
              infrastructurePackageBarrelFile.removeExport('src/cool_dto.dart'),
          () => dataTransferObject.delete(),
          progress.complete,
          () => logger.progress('Running "dart format . --fix" in project'),
          () => manager.runDartFormatFix(workingDirectory: 'project_path'),
          progress.complete,
          logger.newLine,
          () => logger.commandSuccess('Removed Data Transfer Object!')
        ]);
        verifyNoMoreInteractions(manager);
        verifyNoMoreInteractions(logger);
        verifyNoMoreInteractions(progress);
      }),
    );
  });

  group('infrastructureSubInfrastructureRemoveServiceImplementation', () {
    test(
        'throws ServiceImplementationNotFoundException when service '
        'implementation does not exist', () async {
      when(() => serviceImplementation.existsAny).thenReturn(false);
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

    test(
      'removes service implementation from infrastructure package',
      withMockEnv((manager) async {
        when(() => serviceImplementation.existsAny).thenReturn(true);
        final (logger: logger, progress: progress) = setupLoggerWithoutGroup();
        final rapid = getRapid(project: project, tool: tool, logger: logger);

        await rapid.infrastructureSubInfrastructureRemoveServiceImplementation(
          name: 'Fake',
          subInfrastructureName: 'foo_bar',
          serviceInterfaceName: 'Cool',
        );

        verifyInOrder([
          logger.newLine,
          () => logger.progress('Deleting service implementation'),
          () => infrastructurePackageBarrelFile
              .removeExport('src/fake_cool_service.dart'),
          () => serviceImplementation.delete(),
          progress.complete,
          () => logger
              .progress('Running code generation in infrastructure_package'),
          () => manager.runDartRunBuildRunnerBuildDeleteConflictingOutputs(
                workingDirectory: 'infrastructure_package_path',
              ),
          progress.complete,
          () => logger.progress('Running "dart format . --fix" in project'),
          () => manager.runDartFormatFix(workingDirectory: 'project_path'),
          progress.complete,
          logger.newLine,
          () => logger.commandSuccess('Removed Service Implementation!')
        ]);
        verifyNoMoreInteractions(manager);
        verifyNoMoreInteractions(logger);
        verifyNoMoreInteractions(progress);
      }),
    );

    group('given command group is active', () {
      setUp(() {
        when(() => commandGroup.isActive).thenReturn(true);
      });

      test(
        'marks infrastructure package as need code gen',
        withMockEnv((_) async {
          when(() => serviceImplementation.existsAny).thenReturn(true);
          final logger = MockRapidLogger();
          final rapid = getRapid(
            project: project,
            tool: tool,
            logger: logger,
          );

          await rapid
              .infrastructureSubInfrastructureRemoveServiceImplementation(
            name: 'Fake',
            subInfrastructureName: 'foo_bar',
            serviceInterfaceName: 'Cool',
          );

          verifyInOrder([
            () => tool.markAsNeedCodeGen(package: infrastructurePackage),
          ]);
        }),
      );
    });
  });
}
