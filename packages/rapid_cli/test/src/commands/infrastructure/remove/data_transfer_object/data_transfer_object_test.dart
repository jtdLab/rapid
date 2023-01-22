import 'package:args/args.dart';
import 'package:mason/mason.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rapid_cli/src/commands/infrastructure/remove/data_transfer_object/data_transfer_object.dart';
import 'package:rapid_cli/src/project/infrastructure_package/infrastructure_package.dart';
import 'package:rapid_cli/src/project/project.dart';
import 'package:recase/recase.dart';
import 'package:test/test.dart';
import 'package:universal_io/io.dart';

import '../../../../../helpers/helpers.dart';

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

class _MockLogger extends Mock implements Logger {}

class _MockProgress extends Mock implements Progress {}

class _MockProject extends Mock implements Project {}

class _MockInfrastructurePackage extends Mock implements InfrastructurePackage {
}

class _MockDataTransferObject extends Mock implements DataTransferObject {}

class _MockArgResults extends Mock implements ArgResults {}

void main() {
  group('infrastructure add data_transfer_object', () {
    Directory cwd = Directory.current;

    late Logger logger;
    late List<String> progressLogs;

    late Project project;
    late InfrastructurePackage infrastructurePackage;
    late DataTransferObject dataTransferObject;

    late ArgResults argResults;
    late String? dir;
    late String name;

    late InfrastructureRemoveDataTransferObjectCommand command;

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
      dataTransferObject = _MockDataTransferObject();
      when(() => dataTransferObject.exists()).thenReturn(true);
      when(
        () => infrastructurePackage.dataTransferObject(
          entityName: any(named: 'name'),
          dir: any(named: 'dir'),
        ),
      ).thenReturn(dataTransferObject);
      when(() => project.exists()).thenReturn(true);
      when(() => project.infrastructurePackage)
          .thenReturn(infrastructurePackage);

      argResults = _MockArgResults();
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
      }),
    );

    test('completes successfully with correct output', () async {
      // Act
      final result = await command.run();

      // Assert
      verify(() => infrastructurePackage.dataTransferObject(
          entityName: name, dir: '.')).called(1);
      verify(() => dataTransferObject.exists()).called(1);
      verify(() => dataTransferObject.delete()).called(1);
      verify(() => logger.success(
          'Removed Data Transfer Object ${name.pascalCase}.')).called(1);
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
      verify(() => infrastructurePackage.dataTransferObject(
          entityName: name, dir: dir!)).called(1);
      verify(() => dataTransferObject.exists()).called(1);
      verify(() => dataTransferObject.delete()).called(1);
      verify(() => logger.success(
          'Removed Data Transfer Object ${name.pascalCase}.')).called(1);
      expect(result, ExitCode.success.code);
    });

    test('exits with 78 when data transfer object does not exist', () async {
      // Arrange
      when(() => dataTransferObject.exists()).thenReturn(false);

      // Act
      final result = await command.run();

      // Assert
      verify(() =>
              logger.err('Data Transfer Object ${name.pascalCase} not found.'))
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
