import 'package:args/args.dart';
import 'package:mason/mason.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rapid_cli/src/commands/infrastructure/add/service_implementation/service_implementation.dart';
import 'package:rapid_cli/src/project/domain_package/domain_package.dart';
import 'package:rapid_cli/src/project/infrastructure_package/infrastructure_package.dart';
import 'package:rapid_cli/src/project/project.dart';
import 'package:test/test.dart';
import 'package:universal_io/io.dart';

import '../../../../../helpers/helpers.dart';

const expectedUsage = [
  'Add a service implementation to the infrastructure part of an existing Rapid project.\n'
      '\n'
      'Usage: rapid infrastructure add service_implementation <name> [arguments]\n'
      '-h, --help          Print this usage information.\n'
      '\n'
      '\n'
      '-s, --service       The service interface the service implementation is related to.\n'
      '-o, --output-dir    The output directory relative to <infrastructure_package>/lib/src .\n'
      '                    (defaults to ".")\n'
      '\n'
      'Run "rapid help" to see global options.'
];

class _MockLogger extends Mock implements Logger {}

class _MockProgress extends Mock implements Progress {}

class _MockProject extends Mock implements Project {}

class _MockInfrastructurePackage extends Mock
    implements InfrastructurePackage {}

class _MockDomainPackage extends Mock implements DomainPackage {}

class _MockServiceImplementation extends Mock
    implements ServiceImplementation {}

class _MockServiceInterface extends Mock implements ServiceInterface {}

class _MockArgResults extends Mock implements ArgResults {}

void main() {
  group('infrastructure add service_implementation', () {
    Directory cwd = Directory.current;

    late Logger logger;
    late List<String> progressLogs;

    late Project project;
    late InfrastructurePackage infrastructurePackage;
    late ServiceImplementation serviceImplementation;
    late DomainPackage domainPackage;
    late ServiceInterface serviceInterface;

    late ArgResults argResults;
    late String name;
    late String service;
    late String? outputDir;

    late InfrastructureAddServiceImplementationCommand command;

    setUp(() {
      Directory.current = Directory.systemTemp.createTempSync();

      logger = _MockLogger();
      final progress = _MockProgress();
      progressLogs = <String>[];
      when(() => progress.complete(any())).thenAnswer((_) {
        final message = _.positionalArguments.elementAt(0) as String?;
        if (message != null) progressLogs.add(message);
      });
      when(() => logger.progress(any())).thenReturn(progress);

      project = _MockProject();
      infrastructurePackage = _MockInfrastructurePackage();
      serviceImplementation = _MockServiceImplementation();
      when(() => serviceImplementation.exists()).thenReturn(false);
      when(() => serviceImplementation.create(logger: logger))
          .thenAnswer((_) async {});
      when(
        () => infrastructurePackage.serviceImplementation(
          name: any(named: 'name'),
          serviceName: any(named: 'serviceName'),
          dir: any(named: 'dir'),
        ),
      ).thenReturn(serviceImplementation);
      domainPackage = _MockDomainPackage();
      serviceInterface = _MockServiceInterface();
      when(() => serviceInterface.exists()).thenReturn(true);
      when(
        () => domainPackage.serviceInterface(
          name: any(named: 'name'),
          dir: any(named: 'dir'),
        ),
      ).thenReturn(serviceInterface);
      when(() => project.exists()).thenReturn(true);
      when(() => project.infrastructurePackage)
          .thenReturn(infrastructurePackage);
      when(() => project.domainPackage).thenReturn(domainPackage);

      argResults = _MockArgResults();
      name = 'Fake';
      service = 'FooBar';
      outputDir = null;
      when(() => argResults['service']).thenReturn(service);
      when(() => argResults['output-dir']).thenReturn(outputDir);
      when(() => argResults.rest).thenReturn([name]);

      command = InfrastructureAddServiceImplementationCommand(
        logger: logger,
        project: project,
      )..argResultOverrides = argResults;
    });

    tearDown(() {
      Directory.current = cwd;
    });

    test('service is a valid alias', () {
      // Arrange
      final command =
          InfrastructureAddServiceImplementationCommand(project: project);

      // Act + Assert
      expect(command.aliases, contains('service'));
    });

    test('si is a valid alias', () {
      // Arrange
      final command =
          InfrastructureAddServiceImplementationCommand(project: project);

      // Act + Assert
      expect(command.aliases, contains('si'));
    });
    test(
      'help',
      withRunner((commandRunner, logger, printLogs) async {
        // Act
        final result = await commandRunner.run(
          ['infrastructure', 'add', 'service_implementation', '--help'],
        );

        // Assert
        expect(printLogs, equals(expectedUsage));
        expect(result, equals(ExitCode.success.code));

        printLogs.clear();

        // Act
        final resultAbbr = await commandRunner.run(
          ['infrastructure', 'add', 'service_implementation', '-h'],
        );

        // Assert
        expect(printLogs, equals(expectedUsage));
        expect(resultAbbr, equals(ExitCode.success.code));
      }),
    );

    test('can be instantiated without explicit logger', () {
      // Act
      command = InfrastructureAddServiceImplementationCommand(project: project);

      // Assert
      expect(command, isNotNull);
    });

    test(
      'throws UsageException when service is missing',
      withRunnerOnProject(
          (commandRunner, logger, melosFile, project, printLogs) async {
        // Arrange
        const expectedErrorMessage = 'No option specified for the service.';

        // Act
        final result = await commandRunner
            .run(['infrastructure', 'add', 'service_implementation', name]);

        // Assert
        expect(result, equals(ExitCode.usage.code));
        verify(() => logger.err(expectedErrorMessage)).called(1);
      }),
    );

    test(
      'throws UsageException when service is not a valid dart class name',
      withRunnerOnProject(
          (commandRunner, logger, melosFile, project, printLogs) async {
        // Arrange
        service = '****::_';
        final expectedErrorMessage =
            '"$service" is not a valid dart class name.';

        // Act
        final result = await commandRunner.run([
          'infrastructure',
          'add',
          'service_implementation',
          name,
          '--service',
          service
        ]);

        // Assert
        expect(result, equals(ExitCode.usage.code));
        verify(() => logger.err(expectedErrorMessage)).called(1);
      }),
    );

    test('completes successfully with correct output', () async {
      // Act
      final result = await command.run();

      // Assert
      verify(
        () => infrastructurePackage.serviceImplementation(
          name: name,
          serviceName: service,
          dir: '.',
        ),
      ).called(1);
      verify(() => serviceImplementation.exists()).called(1);
      verify(() => serviceImplementation.create(logger: logger)).called(1);
      verify(() => logger.success(
              'Added Service Implementation ${name.pascalCase}${service.pascalCase}Service.'))
          .called(1);
      expect(result, ExitCode.success.code);
    });

    test('completes successfully with correct output with custom --output-dir',
        () async {
      // Arrange
      outputDir = 'foo/bar';
      when(() => argResults['output-dir']).thenReturn(outputDir);

      // Act
      final result = await command.run();

      // Assert
      verify(
        () => infrastructurePackage.serviceImplementation(
          name: name,
          serviceName: service,
          dir: outputDir!,
        ),
      ).called(1);
      verify(() => serviceImplementation.exists()).called(1);
      verify(() => serviceImplementation.create(logger: logger)).called(1);
      verify(
        () => logger.success(
            'Added Service Implementation ${name.pascalCase}${service.pascalCase}Service.'),
      ).called(1);
      expect(result, ExitCode.success.code);
    });

    test('exits with 78 when service interace does not exist', () async {
      // Arrange
      when(() => serviceInterface.exists()).thenReturn(false);

      // Act
      final result = await command.run();

      // Assert
      verify(() => logger.err(
          'Service Interface I${service}Service does not exist.')).called(1);
      expect(result, ExitCode.config.code);
    });

    test('exits with 78 when service implementation does already exist',
        () async {
      // Arrange
      when(() => serviceImplementation.exists()).thenReturn(true);

      // Act
      final result = await command.run();

      // Assert
      verify(() => logger.err(
              'Service Implementation ${name.pascalCase}${service.pascalCase}Service already exists.'))
          .called(1);
      expect(result, ExitCode.config.code);
    });

    test('exits with 66 when project does not exist', () async {
      // Arrange
      when(() => project.exists()).thenReturn(false);

      // Act
      final result = await command.run();

      // Assert
      verify(() => logger.err('''
 Could not find a melos.yaml.
 This command should be run from the root of your Rapid project.''')).called(1);
      expect(result, ExitCode.noInput.code);
    });
  });
}
