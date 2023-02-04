import 'package:args/args.dart';
import 'package:mason/mason.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rapid_cli/src/commands/infrastructure/remove/data_transfer_object/data_transfer_object.dart';
import 'package:rapid_cli/src/project/project.dart';
import 'package:test/test.dart';
import 'dart:io';

import '../../../../common.dart';
import '../../../../mocks.dart';

const expectedUsage = [
  'Remove a data transfer object from the infrastructure part of an existing Rapid project.\n'
      '\n'
      'Usage: rapid infrastructure remove data_transfer_object <name> [arguments]\n'
      '-h, --help    Print this usage information.\n'
      '\n'
      '\n'
      '-d, --dir     The directory relative to <infrastructure_package>/lib/ .\n'
      '              (defaults to ".")\n'
      '\n'
      'Run "rapid help" to see global options.'
];

void main() {
  group('infrastructure add data_transfer_object', () {
    Directory cwd = Directory.current;

    late Logger logger;

    late Project project;

    late ArgResults argResults;
    late String? dir;
    late String name;

    late InfrastructureRemoveDataTransferObjectCommand command;

    setUp(() {
      Directory.current = Directory.systemTemp.createTempSync();

      logger = MockLogger();

      project = MockProject();
      when(
        () => project.removeDataTransferObject(
          name: any(named: 'name'),
          dir: any(named: 'dir'),
          logger: logger,
        ),
      ).thenAnswer((_) async {});
      when(() => project.exists()).thenReturn(true);

      argResults = MockArgResults();
      dir = null;
      name = 'FooBar';
      when(() => argResults['dir']).thenReturn(dir);
      when(() => argResults.rest).thenReturn([name]);

      command = InfrastructureRemoveDataTransferObjectCommand(
        logger: logger,
        project: project,
      )..argResultOverrides = argResults;
    });

    tearDown(() {
      Directory.current = cwd;
    });

    test('dto is a valid alias', () {
      // Arrange
      final command =
          InfrastructureRemoveDataTransferObjectCommand(project: project);

      // Act + Assert
      expect(command.aliases, contains('dto'));
    });

    test(
      'help',
      withRunner((commandRunner, logger, printLogs) async {
        // Act
        final result = await commandRunner.run(
          ['infrastructure', 'remove', 'data_transfer_object', '--help'],
        );

        // Assert
        expect(printLogs, equals(expectedUsage));
        expect(result, equals(ExitCode.success.code));

        printLogs.clear();

        // Act
        final resultAbbr = await commandRunner.run(
          ['infrastructure', 'remove', 'data_transfer_object', '-h'],
        );

        // Assert
        expect(printLogs, equals(expectedUsage));
        expect(resultAbbr, equals(ExitCode.success.code));
      }),
    );

    test('can be instantiated without explicit logger', () {
      // Act
      command = InfrastructureRemoveDataTransferObjectCommand(project: project);

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
            .run(['infrastructure', 'remove', 'data_transfer_object']);

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
          'data_transfer_object',
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
          'data_transfer_object',
          name,
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
      verify(() => logger.info('Removing Data Transfer Object ...')).called(1);
      verify(
        () => project.removeDataTransferObject(
          name: name,
          dir: '.',
          logger: logger,
        ),
      ).called(1);
      verify(() => logger.success('Removed Data Transfer Object $name.'))
          .called(1);
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
      verify(() => logger.info('Removing Data Transfer Object ...')).called(1);
      verify(
        () => project.removeDataTransferObject(
          name: name,
          dir: dir!,
          logger: logger,
        ),
      ).called(1);
      verify(
        () => logger.success(
          'Removed Data Transfer Object $name.',
        ),
      ).called(1);
      verify(() => logger.info('')).called(1);
      expect(result, ExitCode.success.code);
    });

    test('exits with 78 when data transfer object does not exist', () async {
      // Arrange
      when(
        () => project.removeDataTransferObject(
          name: any(named: 'name'),
          dir: any(named: 'dir'),
          logger: logger,
        ),
      ).thenThrow(DataTransferObjectDoesNotExist());

      // Act
      final result = await command.run();

      // Assert
      verify(
        () => logger.err('Data Transfer Object $name not found.'),
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
