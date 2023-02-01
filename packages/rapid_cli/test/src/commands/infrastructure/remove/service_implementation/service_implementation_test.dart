import 'package:args/args.dart';
import 'package:mason/mason.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rapid_cli/src/commands/infrastructure/remove/service_implementation/service_implementation.dart';
import 'package:rapid_cli/src/project/project.dart';
import 'package:test/test.dart';
import 'package:universal_io/io.dart';

import '../../../../../helpers/helpers.dart';

const expectedUsage = [
  'Remove a service implementation from the infrastructure part of an existing Rapid project.\n'
      '\n'
      'Usage: rapid infrastructure remove service_implementation <name> [arguments]\n'
      '-h, --help       Print this usage information.\n'
      '\n'
      '\n'
      '-s, --service    The service interface the service implementation is related to.\n'
      '-d, --dir        The directory relative to <infrastructure_package>/lib/ .\n'
      '                 (defaults to ".")\n'
      '\n'
      'Run "rapid help" to see global options.'
];

class _MockLogger extends Mock implements Logger {}

class _MockProject extends Mock implements Project {}

class _MockArgResults extends Mock implements ArgResults {}

void main() {
  group('infrastructure add service_implementation', () {
    Directory cwd = Directory.current;

    late Logger logger;

    late Project project;

    late ArgResults argResults;
    late String? dir;
    late String name;
    late String service;

    late InfrastructureRemoveServiceImplementationCommand command;

    setUp(() {
      Directory.current = Directory.systemTemp.createTempSync();

      logger = _MockLogger();

      project = _MockProject();
      when(
        () => project.removeServiceImplementation(
          name: any(named: 'name'),
          serviceName: any(named: 'serviceName'),
          dir: any(named: 'dir'),
          logger: logger,
        ),
      ).thenAnswer((_) async {});
      when(() => project.exists()).thenReturn(true);

      argResults = _MockArgResults();
      dir = null;
      name = 'Fake';
      service = 'FooBar';
      when(() => argResults['service']).thenReturn(service);
      when(() => argResults['dir']).thenReturn(dir);
      when(() => argResults.rest).thenReturn([name]);

      command = InfrastructureRemoveServiceImplementationCommand(
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
          InfrastructureRemoveServiceImplementationCommand(project: project);

      // Act + Assert
      expect(command.aliases, contains('service'));
    });

    test('si is a valid alias', () {
      // Arrange
      final command =
          InfrastructureRemoveServiceImplementationCommand(project: project);

      // Act + Assert
      expect(command.aliases, contains('si'));
    });

    test(
      'help',
      withRunner((commandRunner, logger, printLogs) async {
        // Act
        final result = await commandRunner.run(
          ['infrastructure', 'remove', 'service_implementation', '--help'],
        );

        // Assert
        expect(printLogs, equals(expectedUsage));
        expect(result, equals(ExitCode.success.code));

        printLogs.clear();

        // Act
        final resultAbbr = await commandRunner.run(
          ['infrastructure', 'remove', 'service_implementation', '-h'],
        );

        // Assert
        expect(printLogs, equals(expectedUsage));
        expect(resultAbbr, equals(ExitCode.success.code));
      }),
    );

    test('can be instantiated without explicit logger', () {
      // Act
      command =
          InfrastructureRemoveServiceImplementationCommand(project: project);

      // Assert
      expect(command, isNotNull);
    });

    test(
      'throws UsageException when name is missing',
      withRunnerOnProject(
          (commandRunner, logger, melosFile, project, printLogs) async {
        // Arrange
        const expectedErrorMessage = 'No option specified for the name.';

        // Act
        final result = await commandRunner
            .run(['infrastructure', 'remove', 'service_implementation']);

        // Assert
        expect(result, equals(ExitCode.usage.code));
        verify(() => logger.err(expectedErrorMessage)).called(1);
        verify(() => logger.info('')).called(1);
      }),
    );

    test(
      'throws UsageException when multiple names are provided',
      withRunnerOnProject(
          (commandRunner, logger, melosFile, project, printLogs) async {
        // Arrange
        const expectedErrorMessage = 'Multiple names specified.';

        // Act
        final result = await commandRunner.run([
          'infrastructure',
          'remove',
          'service_implementation',
          'name1',
          'name2',
        ]);

        // Assert
        expect(result, equals(ExitCode.usage.code));
        verify(() => logger.err(expectedErrorMessage)).called(1);
        verify(() => logger.info('')).called(1);
      }),
    );

    test(
      'throws UsageException when name is not a valid dart class name',
      withRunnerOnProject(
          (commandRunner, logger, melosFile, project, printLogs) async {
        // Arrange
        const name = 'name1';
        const expectedErrorMessage = '"$name" is not a valid dart class name.';

        // Act
        final result = await commandRunner.run([
          'infrastructure',
          'remove',
          'service_implementation',
          name,
        ]);

        // Assert
        expect(result, equals(ExitCode.usage.code));
        verify(() => logger.err(expectedErrorMessage)).called(1);
        verify(() => logger.info('')).called(1);
      }),
    );

    test(
      'throws UsageException when service is missing',
      withRunnerOnProject(
          (commandRunner, logger, melosFile, project, printLogs) async {
        // Arrange
        const expectedErrorMessage = 'No option specified for the service.';

        // Act
        final result = await commandRunner
            .run(['infrastructure', 'remove', 'service_implementation', name]);

        // Assert
        expect(result, equals(ExitCode.usage.code));
        verify(() => logger.err(expectedErrorMessage)).called(1);
        verify(() => logger.info('')).called(1);
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
          'remove',
          'service_implementation',
          name,
          '--service',
          service
        ]);

        // Assert
        expect(result, equals(ExitCode.usage.code));
        verify(() => logger.err(expectedErrorMessage)).called(1);
        verify(() => logger.info('')).called(1);
      }),
    );

    test('completes successfully with correct output', () async {
      // Act
      final result = await command.run();

      // Assert
      verify(() => logger.info('Removing Service Implementation ...'))
          .called(1);
      verify(
        () => project.removeServiceImplementation(
          name: name,
          serviceName: service,
          dir: '.',
          logger: logger,
        ),
      ).called(1);
      verify(
        () => logger.success(
          'Removed Service Implementation ${name.pascalCase}${service.pascalCase}Service.',
        ),
      ).called(1);
      verify(() => logger.info('')).called(1);
      expect(result, ExitCode.success.code);
    });

    test('completes successfully with correct output with custom --dir',
        () async {
      // Arrange
      dir = 'foo/bar';
      when(() => argResults['dir']).thenReturn(dir);

      // Act
      final result = await command.run();

      // Assert
      verify(() => logger.info('Removing Service Implementation ...'))
          .called(1);
      verify(
        () => project.removeServiceImplementation(
          name: name,
          serviceName: service,
          dir: dir!,
          logger: logger,
        ),
      ).called(1);
      verify(
        () => logger.success(
          'Removed Service Implementation ${name.pascalCase}${service.pascalCase}Service.',
        ),
      ).called(1);
      verify(() => logger.info('')).called(1);
      expect(result, ExitCode.success.code);
    });

    test('exits with 78 when service implementation does not exist', () async {
      // Arrange
      when(
        () => project.removeServiceImplementation(
          name: any(named: 'name'),
          serviceName: any(named: 'serviceName'),
          dir: any(named: 'dir'),
          logger: logger,
        ),
      ).thenThrow(ServiceImplementationDoesNotExist());

      // Act
      final result = await command.run();

      // Assert
      verify(
        () => logger.err(
          'Service Implementation ${name.pascalCase}${service.pascalCase}Service not found.',
        ),
      ).called(1);
      verify(() => logger.info('')).called(1);
      expect(result, ExitCode.config.code);
    });

    test('exits with 66 when project does not exist', () async {
      // Arrange
      when(() => project.exists()).thenReturn(false);

      // Act
      final result = await command.run();

      // Assert
      verify(
        () => logger.err(
          'This command should be run from the root of an existing Rapid project.',
        ),
      ).called(1);
      verify(() => logger.info('')).called(1);
      expect(result, ExitCode.noInput.code);
    });
  });
}
