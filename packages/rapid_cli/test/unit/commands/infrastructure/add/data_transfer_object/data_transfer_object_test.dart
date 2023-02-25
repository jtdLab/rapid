import 'package:args/args.dart';
import 'package:mason/mason.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rapid_cli/src/commands/infrastructure/add/data_transfer_object/data_transfer_object.dart';
import 'package:rapid_cli/src/project/project.dart';
import 'package:test/test.dart';
import 'dart:io';

import '../../../../common.dart';
import '../../../../mocks.dart';

const expectedUsage = [
  'Add a data transfer object to the infrastructure part of an existing Rapid project.\n'
      '\n'
      'Usage: rapid infrastructure add data_transfer_object [arguments]\n'
      '-h, --help          Print this usage information.\n'
      '\n'
      '\n'
      '-e, --entity        The name of the entity the data transfer object is related to.\n'
      '-o, --output-dir    The output directory relative to <infrastructure_package>/lib/src .\n'
      '                    (defaults to ".")\n'
      '\n'
      'Run "rapid help" to see global options.'
];

void main() {
  group('infrastructure add service_interface', () {
    Directory cwd = Directory.current;

    late Logger logger;

    late Project project;

    late ArgResults argResults;
    late String entityName;
    late String? outputDir;

    late InfrastructureAddDataTransferObjectCommand command;

    setUp(() {
      Directory.current = Directory.systemTemp.createTempSync();

      logger = MockLogger();

      project = MockProject();
      when(() => project.existsAll()).thenReturn(true);
      when(
        () => project.addDataTransferObject(
          entityName: any(named: 'entityName'),
          outputDir: any(named: 'outputDir'),
          logger: logger,
        ),
      ).thenAnswer((_) async {});

      argResults = MockArgResults();
      entityName = 'FooBar';
      outputDir = null;
      when(() => argResults['entity']).thenReturn(entityName);
      when(() => argResults['output-dir']).thenReturn(outputDir);

      command = InfrastructureAddDataTransferObjectCommand(
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
          InfrastructureAddDataTransferObjectCommand(project: project);

      // Act + Assert
      expect(command.aliases, contains('dto'));
    });

    test(
      'help',
      withRunner((commandRunner, logger, printLogs) async {
        // Act
        final result = await commandRunner.run(
          ['infrastructure', 'add', 'data_transfer_object', '--help'],
        );

        // Assert
        expect(printLogs, equals(expectedUsage));
        expect(result, equals(ExitCode.success.code));

        printLogs.clear();

        // Act
        final resultAbbr = await commandRunner.run(
          ['infrastructure', 'add', 'data_transfer_object', '-h'],
        );

        // Assert
        expect(printLogs, equals(expectedUsage));
        expect(resultAbbr, equals(ExitCode.success.code));
      }),
    );

    test('can be instantiated without explicit logger', () {
      // Act
      command = InfrastructureAddDataTransferObjectCommand(project: project);

      // Assert
      expect(command, isNotNull);
    });

    test(
      'throws UsageException when entity is missing',
      withRunnerOnProject(
          (commandRunner, logger, melosFile, project, printLogs) async {
        // Arrange
        const expectedErrorMessage = 'No option specified for the entity.';

        // Act
        final result = await commandRunner
            .run(['infrastructure', 'add', 'data_transfer_object']);

        // Assert
        expect(result, equals(ExitCode.usage.code));
        verify(() => logger.err(expectedErrorMessage)).called(1);
        verify(() => logger.info('')).called(1);
      }),
    );

    test(
      'throws UsageException when entity is not a valid dart class name',
      withRunnerOnProject(
          (commandRunner, logger, melosFile, project, printLogs) async {
        // Arrange
        entityName = '****::_';
        final expectedErrorMessage =
            '"$entityName" is not a valid dart class name.';

        // Act
        final result = await commandRunner.run([
          'infrastructure',
          'add',
          'data_transfer_object',
          '--entity',
          entityName
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
      verify(() => logger.info('Adding Data Transfer Object ...')).called(1);
      verify(
        () => project.addDataTransferObject(
          entityName: entityName,
          outputDir: '.',
          logger: logger,
        ),
      ).called(1);
      verify(
        () => logger.success(
          'Added Data Transfer Object ${entityName}Dto.',
        ),
      ).called(1);
      verify(() => logger.info('')).called(1);
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
      verify(() => logger.info('Adding Data Transfer Object ...')).called(1);
      verify(
        () => project.addDataTransferObject(
          entityName: entityName,
          outputDir: outputDir!,
          logger: logger,
        ),
      ).called(1);
      verify(
        () => logger.success(
          'Added Data Transfer Object ${entityName}Dto.',
        ),
      ).called(1);
      verify(() => logger.info('')).called(1);
      expect(result, ExitCode.success.code);
    });

    test('exits with 78 when entity does not exist', () async {
      // Arrange
      when(
        () => project.addDataTransferObject(
          entityName: any(named: 'entityName'),
          outputDir: any(named: 'outputDir'),
          logger: logger,
        ),
      ).thenThrow(EntityDoesNotExist());

      // Act
      final result = await command.run();

      // Assert
      verify(() => logger.err('Entity $entityName does not exist.')).called(1);
      verify(() => logger.info('')).called(1);
      expect(result, ExitCode.config.code);
    });

    test('exits with 78 when data transfer object does already exist',
        () async {
      // Arrange
      when(
        () => project.addDataTransferObject(
          entityName: any(named: 'entityName'),
          outputDir: any(named: 'outputDir'),
          logger: logger,
        ),
      ).thenThrow(DataTransferObjectAlreadyExists());

      // Act
      final result = await command.run();

      // Assert
      verify(
        () => logger.err(
          'Data Transfer Object ${entityName}Dto already exists.',
        ),
      ).called(1);
      verify(() => logger.info('')).called(1);
      expect(result, ExitCode.config.code);
    });

    test('exits with 66 when project does not exist', () async {
      // Arrange
      when(() => project.existsAll()).thenReturn(false);

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
