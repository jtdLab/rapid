import 'package:mocktail/mocktail.dart';
import 'package:rapid_cli/src/commands/runner.dart';
import 'package:rapid_cli/src/io/io.dart';
import 'package:rapid_cli/src/project/project.dart';
import 'package:rapid_cli/src/tool.dart';
import 'package:test/test.dart';

import '../mock_env.dart';
import '../mocks.dart';
import '../utils.dart';

// TODO(jtdLab): when adding and removing domains the errors are not realy good abstracted the command needs some reconsideration
// TODO(jtdLab): is it good to use global setup instead of setup fcts with records
// TODO(jtdLab): are defaults set usefully and minimalistic ?
// TODO(jtdLab): is the right package used foo_bar -> domain package is not verified same for other commands in other files

void main() {
  late Entity entity;
  late ServiceInterface serviceInterface;
  late ValueObject valueObject;
  late DartFile domainPackageBarrelFile;
  late DomainPackage domainPackage;
  late InfrastructurePackage infrastructurePackage;
  late PlatformRootPackage rootPackageA;
  late PlatformRootPackage rootPackageB;
  late RapidProject project;
  late CommandGroup commandGroup;
  late RapidTool tool;

  setUpAll(registerFallbackValues);

  setUp(() {
    entity = MockEntity();
    serviceInterface = MockServiceInterface();
    valueObject = MockValueObject();
    domainPackageBarrelFile = MockDartFile();
    domainPackage = MockDomainPackage(
      packageName: 'domain_package',
      path: 'domain_package_path',
      entity: ({required name}) => entity,
      serviceInterface: ({required name}) => serviceInterface,
      valueObject: ({required name}) => valueObject,
    );
    when(() => domainPackage.barrelFile).thenReturn(domainPackageBarrelFile);
    when(() => domainPackage.existsSync()).thenReturn(true);
    infrastructurePackage = MockInfrastructurePackage();
    when(() => infrastructurePackage.existsSync()).thenReturn(true);
    rootPackageA = MockNoneIosRootPackage(
      packageName: 'root_package_a',
      path: 'root_package_a_path',
    );
    rootPackageB = MockIosRootPackage(
      packageName: 'root_package_b',
      path: 'root_package_b_path',
    );
    project = MockRapidProject(
      path: 'project_path',
      appModule: MockAppModule(
        domainDirectory: MockDomainDirectory(
          domainPackage: ({name}) => domainPackage,
        ),
        infrastructureDirectory: MockInfrastructureDirectory(
          infrastructurePackage: ({name}) => infrastructurePackage,
        ),
      ),
      rootPackages: [rootPackageA, rootPackageB],
    );
    commandGroup = MockCommandGroup();
    when(() => commandGroup.isActive).thenReturn(false);
    tool = MockRapidTool();
    when(() => tool.loadGroup()).thenReturn(commandGroup);
  });

  group('domainAddSubDomain', () {
    test(
        'throws SubDomainAlreadyExistsException when domain package already exists',
        () async {
      when(() => domainPackage.existsSync()).thenReturn(true);
      final rapid = getRapid(project: project);

      expect(
        () => rapid.domainAddSubDomain(name: 'foo_bar'),
        throwsA(isA<SubDomainAlreadyExistsException>()),
      );
    });

    test(
        'throws SubInfrastructureAlreadyExistsException when infrastructure package already exists',
        () async {
      when(() => domainPackage.existsSync()).thenReturn(false);
      when(() => infrastructurePackage.existsSync()).thenReturn(true);
      final rapid = getRapid(project: project);

      expect(
        () => rapid.domainAddSubDomain(name: 'foo_bar'),
        throwsA(isA<SubInfrastructureAlreadyExistsException>()),
      );
    });

    test(
      'adds domain package and associated infrastructure package',
      withMockEnv((manager) async {
        when(() => domainPackage.existsSync()).thenReturn(false);
        when(() => infrastructurePackage.existsSync()).thenReturn(false);
        final (
          progress: progress,
          groupableProgress: groupableProgress,
          progressGroup: progressGroup,
          logger: logger,
        ) = setupLogger();
        final rapid = getRapid(
          project: project,
          tool: tool,
          logger: logger,
        );

        await rapid.domainAddSubDomain(name: 'foo_bar');

        verifyInOrder([
          logger.newLine,
          () => logger.progress('Creating domain package'),
          () => domainPackage.generate(),
          progress.complete,
          () => logger.progress('Creating infrastructure package'),
          () => infrastructurePackage.generate(),
          () =>
              rootPackageA.registerInfrastructurePackage(infrastructurePackage),
          () =>
              rootPackageB.registerInfrastructurePackage(infrastructurePackage),
          progress.complete,
          () => logger.progress(
                'Running "melos bootstrap --scope domain_package,infrastructure_package,root_package_a,root_package_b"',
              ),
          () => manager.runMelosBootstrap(
                [
                  'domain_package',
                  'infrastructure_package',
                  'root_package_a',
                  'root_package_b',
                ],
                workingDirectory: 'project_path',
              ),
          progress.complete,
          logger.progressGroup,
          () => progressGroup
              .progress('Running code generation in root_package_a'),
          () => manager.runDartRunBuildRunnerBuildDeleteConflictingOutputs(
                workingDirectory: 'root_package_a_path',
              ),
          groupableProgress.complete,
          () => progressGroup
              .progress('Running code generation in root_package_b'),
          () => manager.runDartRunBuildRunnerBuildDeleteConflictingOutputs(
                workingDirectory: 'root_package_b_path',
              ),
          groupableProgress.complete,
          () => logger.progress('Running "dart format . --fix" in project'),
          () => manager.runDartFormatFix(workingDirectory: 'project_path'),
          progress.complete,
          logger.newLine,
          () => logger.commandSuccess('Added Sub Domain!')
        ]);
        verifyNoMoreInteractions(manager);
        verifyNoMoreInteractions(progress);
        verifyNoMoreInteractions(groupableProgress);
        verifyNoMoreInteractions(progressGroup);
        verifyNoMoreInteractions(logger);
      }),
    );

    group('given command group is active', () {
      setUp(() {
        when(() => commandGroup.isActive).thenReturn(true);
      });

      test(
        'marks domain package, infrastructure package and root packages as need bootstrap',
        withMockEnv((_) async {
          when(() => domainPackage.existsSync()).thenReturn(false);
          when(() => infrastructurePackage.existsSync()).thenReturn(false);
          final rapid = getRapid(project: project, tool: tool);

          await rapid.domainAddSubDomain(name: 'foo_bar');

          verifyInOrder([
            () => tool.markAsNeedBootstrap(
                  packages: [
                    domainPackage,
                    infrastructurePackage,
                    rootPackageA,
                    rootPackageB,
                  ],
                ),
          ]);
        }),
      );

      test(
        'marks root packages as need code gen',
        withMockEnv((_) async {
          when(() => domainPackage.existsSync()).thenReturn(false);
          when(() => infrastructurePackage.existsSync()).thenReturn(false);
          final rapid = getRapid(project: project, tool: tool);

          await rapid.domainAddSubDomain(name: 'foo_bar');

          verifyInOrder([
            () => tool.markAsNeedCodeGen(package: rootPackageA),
            () => tool.markAsNeedCodeGen(package: rootPackageB),
          ]);
        }),
      );
    });
  });

  group('domainRemoveSubDomain', () {
    test('throws SubDomainNotFoundException when domain package does not exist',
        () async {
      when(() => domainPackage.existsSync()).thenReturn(false);
      final rapid = getRapid(project: project);

      expect(
        () => rapid.domainRemoveSubDomain(name: 'foo_bar'),
        throwsA(isA<SubDomainNotFoundException>()),
      );
    });

    test(
        'throws SubInfrastructureNotFoundException when infrastructure package does not exist',
        () async {
      when(() => infrastructurePackage.existsSync()).thenReturn(false);
      final rapid = getRapid(project: project);

      expect(
        () => rapid.domainRemoveSubDomain(name: 'foo_bar'),
        throwsA(isA<SubInfrastructureNotFoundException>()),
      );
    });

    test(
      'removes domain package and associated infrastructure package',
      withMockEnv((manager) async {
        when(() => domainPackage.existsSync()).thenReturn(true);
        when(() => infrastructurePackage.existsSync()).thenReturn(true);
        final (
          progress: progress,
          groupableProgress: groupableProgress,
          progressGroup: progressGroup,
          logger: logger,
        ) = setupLogger();
        final rapid = getRapid(
          project: project,
          tool: tool,
          logger: logger,
        );

        await rapid.domainRemoveSubDomain(name: 'foo_bar');

        verifyInOrder([
          logger.newLine,
          () => logger.progress('Deleting domain package'),
          () => domainPackage.deleteSync(recursive: true),
          progress.complete,
          () => logger.progress('Deleting infrastructure package'),
          () => rootPackageA
              .unregisterInfrastructurePackage(infrastructurePackage),
          () => rootPackageB
              .unregisterInfrastructurePackage(infrastructurePackage),
          () => infrastructurePackage.deleteSync(recursive: true),
          progress.complete,
          () => logger.progress(
                'Running "melos bootstrap --scope root_package_a,root_package_b"',
              ),
          () => manager.runMelosBootstrap(
                ['root_package_a', 'root_package_b'],
                workingDirectory: 'project_path',
              ),
          progress.complete,
          logger.progressGroup,
          () => progressGroup
              .progress('Running code generation in root_package_a'),
          () => manager.runDartRunBuildRunnerBuildDeleteConflictingOutputs(
                workingDirectory: 'root_package_a_path',
              ),
          groupableProgress.complete,
          () => progressGroup
              .progress('Running code generation in root_package_b'),
          () => manager.runDartRunBuildRunnerBuildDeleteConflictingOutputs(
                workingDirectory: 'root_package_b_path',
              ),
          groupableProgress.complete,
          () => logger.progress('Running "dart format . --fix" in project'),
          () => manager.runDartFormatFix(workingDirectory: 'project_path'),
          progress.complete,
          logger.newLine,
          () => logger.commandSuccess('Removed Sub Domain!')
        ]);
        verifyNoMoreInteractions(manager);
        verifyNoMoreInteractions(progress);
        verifyNoMoreInteractions(groupableProgress);
        verifyNoMoreInteractions(progressGroup);
        verifyNoMoreInteractions(logger);
      }),
    );

    group('given command group is active', () {
      setUp(() {
        when(() => commandGroup.isActive).thenReturn(true);
      });

      test(
        'marks root packages as need bootstrap',
        withMockEnv((_) async {
          final rapid = getRapid(project: project, tool: tool);

          await rapid.domainRemoveSubDomain(name: 'foo_bar');

          verifyInOrder([
            () => tool
                .markAsNeedBootstrap(packages: [rootPackageA, rootPackageB]),
          ]);
        }),
      );

      test(
        'marks root packages as need code gen',
        withMockEnv((_) async {
          final rapid = getRapid(project: project, tool: tool);

          await rapid.domainRemoveSubDomain(name: 'foo_bar');

          verifyInOrder([
            () => tool.markAsNeedCodeGen(package: rootPackageA),
            () => tool.markAsNeedCodeGen(package: rootPackageB),
          ]);
        }),
      );
    });
  });

  group('domainSubDomainAddEntity', () {
    test(
        'throws EntityOrValueObjectAlreadyExistsException when entity already exists',
        () async {
      when(() => entity.existsAny).thenReturn(true);
      final rapid = getRapid(project: project);

      expect(
        () => rapid.domainSubDomainAddEntity(
          name: 'Cool',
          subDomainName: 'foo_bar',
        ),
        throwsA(isA<EntityOrValueObjectAlreadyExistsException>()),
      );
    });

    test(
      'adds entity to subdomain',
      withMockEnv((manager) async {
        when(() => entity.existsAny).thenReturn(false);
        final (logger: logger, progress: progress) = setupLoggerWithoutGroup();
        final rapid = getRapid(project: project, logger: logger);

        await rapid.domainSubDomainAddEntity(
          name: 'Cool',
          subDomainName: 'foo_bar',
        );

        verifyInOrder([
          logger.newLine,
          () => logger.progress('Creating entity'),
          () => entity.generate(),
          () => domainPackageBarrelFile.addExport('src/cool.dart'),
          progress.complete,
          () => logger.progress('Running "dart format . --fix" in project'),
          () => manager.runDartFormatFix(workingDirectory: 'project_path'),
          progress.complete,
          logger.newLine,
          () => logger.commandSuccess('Added Entity!')
        ]);
        verifyNoMoreInteractions(manager);
        verifyNoMoreInteractions(logger);
        verifyNoMoreInteractions(progress);
      }),
    );
  });

  group('domainSubDomainAddServiceInterface', () {
    test(
        'throws ServiceInterfaceAlreadyExistsException when service interface already exists',
        () async {
      when(() => serviceInterface.existsAny).thenReturn(true);
      final rapid = getRapid(project: project);

      expect(
        () => rapid.domainSubDomainAddServiceInterface(
          name: 'Cool',
          subDomainName: 'foo_bar',
        ),
        throwsA(isA<ServiceInterfaceAlreadyExistsException>()),
      );
    });

    test(
      'adds service interface to subdomain',
      withMockEnv((manager) async {
        when(() => serviceInterface.existsAny).thenReturn(false);
        final (logger: logger, progress: progress) = setupLoggerWithoutGroup();
        final rapid = getRapid(project: project, logger: logger);

        await rapid.domainSubDomainAddServiceInterface(
          name: 'Cool',
          subDomainName: 'foo_bar',
        );

        verifyInOrder([
          logger.newLine,
          () => logger.progress('Creating service interface'),
          () => serviceInterface.generate(),
          () => domainPackageBarrelFile.addExport('src/i_cool_service.dart'),
          progress.complete,
          () => logger.progress('Running "dart format . --fix" in project'),
          () => manager.runDartFormatFix(workingDirectory: 'project_path'),
          progress.complete,
          logger.newLine,
          () => logger.commandSuccess('Added Service Interface!')
        ]);
        verifyNoMoreInteractions(manager);
        verifyNoMoreInteractions(logger);
        verifyNoMoreInteractions(progress);
      }),
    );
  });

  group('domainSubDomainAddValueObject', () {
    test(
        'throws EntityOrValueObjectAlreadyExistsException when value object already exists',
        () async {
      when(() => valueObject.existsAny).thenReturn(true);
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

    test(
      'adds value object to subdomain',
      withMockEnv((manager) async {
        when(() => valueObject.existsAny).thenReturn(false);
        final (logger: logger, progress: progress) = setupLoggerWithoutGroup();
        final rapid = getRapid(
          project: project,
          tool: tool,
          logger: logger,
        );

        await rapid.domainSubDomainAddValueObject(
          name: 'Cool',
          subDomainName: 'foo_bar',
          type: 'String',
          generics: '<T>',
        );

        verifyInOrder([
          logger.newLine,
          () => logger.progress('Creating value object'),
          () => valueObject.generate(type: 'String', generics: '<T>'),
          () => domainPackageBarrelFile.addExport('src/cool.dart'),
          progress.complete,
          () => logger.progress('Running code generation in domain_package'),
          () => manager.runDartRunBuildRunnerBuildDeleteConflictingOutputs(
                workingDirectory: 'domain_package_path',
              ),
          progress.complete,
          () => logger.progress('Running "dart format . --fix" in project'),
          () => manager.runDartFormatFix(workingDirectory: 'project_path'),
          progress.complete,
          logger.newLine,
          () => logger.commandSuccess('Added Value Object!')
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
        'marks domain package as need code gen',
        withMockEnv((_) async {
          when(() => valueObject.existsAny).thenReturn(false);
          final logger = MockRapidLogger();
          final rapid = getRapid(
            project: project,
            tool: tool,
            logger: logger,
          );

          await rapid.domainSubDomainAddValueObject(
            name: 'Cool',
            subDomainName: 'foo_bar',
            type: 'String',
            generics: '<T>',
          );

          verifyInOrder([
            () => tool.markAsNeedCodeGen(package: domainPackage),
          ]);
        }),
      );
    });
  });

  group('domainSubDomainRemoveEntity', () {
    test('throws EntityNotFoundException when entity does not exist', () async {
      when(() => entity.existsAny).thenReturn(false);
      final rapid = getRapid(project: project);

      expect(
        () => rapid.domainSubDomainRemoveEntity(
          name: 'Cool',
          subDomainName: 'foo_bar',
        ),
        throwsA(isA<EntityNotFoundException>()),
      );
    });

    test(
      'removes entity from subdomain',
      withMockEnv((manager) async {
        when(() => entity.existsAny).thenReturn(true);
        final (logger: logger, progress: progress) = setupLoggerWithoutGroup();
        final rapid = getRapid(project: project, logger: logger);

        await rapid.domainSubDomainRemoveEntity(
          name: 'Cool',
          subDomainName: 'foo_bar',
        );

        verifyInOrder([
          logger.newLine,
          () => logger.progress('Deleting entity files'),
          () => entity.delete(),
          () => domainPackageBarrelFile.removeExport('src/cool.dart'),
          progress.complete,
          () => logger.progress('Running "dart format . --fix" in project'),
          () => manager.runDartFormatFix(workingDirectory: 'project_path'),
          progress.complete,
          logger.newLine,
          () => logger.commandSuccess('Removed Entity!')
        ]);
        verifyNoMoreInteractions(manager);
        verifyNoMoreInteractions(logger);
        verifyNoMoreInteractions(progress);
      }),
    );
  });

  group('domainSubDomainRemoveServiceInterface', () {
    test(
        'throws ServiceInterfaceNotFoundException when service interface does not exist',
        () async {
      when(() => serviceInterface.existsAny).thenReturn(false);
      final rapid = getRapid(project: project);

      expect(
        () => rapid.domainSubDomainRemoveServiceInterface(
          name: 'Cool',
          subDomainName: 'foo_bar',
        ),
        throwsA(isA<ServiceInterfaceNotFoundException>()),
      );
    });

    test(
      'removes service interface from subdomain',
      withMockEnv((manager) async {
        when(() => serviceInterface.existsAny).thenReturn(true);
        final (logger: logger, progress: progress) = setupLoggerWithoutGroup();
        final rapid = getRapid(project: project, logger: logger);

        await rapid.domainSubDomainRemoveServiceInterface(
          name: 'Cool',
          subDomainName: 'foo_bar',
        );

        verifyInOrder([
          logger.newLine,
          () => logger.progress('Deleting service interface files'),
          () => serviceInterface.delete(),
          () => domainPackageBarrelFile.removeExport('src/i_cool_service.dart'),
          progress.complete,
          () => logger.progress('Running "dart format . --fix" in project'),
          () => manager.runDartFormatFix(workingDirectory: 'project_path'),
          progress.complete,
          logger.newLine,
          () => logger.commandSuccess('Removed Service Interface!')
        ]);
        verifyNoMoreInteractions(manager);
        verifyNoMoreInteractions(logger);
        verifyNoMoreInteractions(progress);
      }),
    );
  });

  group('domainSubDomainRemoveValueObject', () {
    test('throws ValueObjectNotFoundException when value object does not exist',
        () async {
      when(() => valueObject.existsAny).thenReturn(false);
      final rapid = getRapid(project: project);

      expect(
        () => rapid.domainSubDomainRemoveValueObject(
          name: 'Cool',
          subDomainName: 'foo_bar',
        ),
        throwsA(isA<ValueObjectNotFoundException>()),
      );
    });

    test(
      'removes value object from subdomain',
      withMockEnv((manager) async {
        when(() => valueObject.existsAny).thenReturn(true);

        final (logger: logger, progress: progress) = setupLoggerWithoutGroup();
        final rapid = getRapid(project: project, logger: logger);

        await rapid.domainSubDomainRemoveValueObject(
          name: 'Cool',
          subDomainName: 'foo_bar',
        );

        verifyInOrder([
          logger.newLine,
          () => logger.progress('Deleting value object files'),
          () => valueObject.delete(),
          () => domainPackageBarrelFile.removeExport('src/cool.dart'),
          progress.complete,
          () => logger.progress('Running "dart format . --fix" in project'),
          () => manager.runDartFormatFix(workingDirectory: 'project_path'),
          progress.complete,
          logger.newLine,
          () => logger.commandSuccess('Removed Value Object!')
        ]);
        verifyNoMoreInteractions(manager);
        verifyNoMoreInteractions(logger);
        verifyNoMoreInteractions(progress);
      }),
    );
  });
}
