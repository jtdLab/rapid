import 'package:args/args.dart';
import 'package:mason/mason.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rapid_cli/src/commands/web/remove/feature/feature.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/project/project.dart';
import 'package:test/test.dart';
import 'package:universal_io/io.dart';

import '../../../../../helpers/helpers.dart';

const expectedUsage = [
  'Removes a feature from the Web part of an existing Rapid project.\n'
      '\n'
      'Usage: rapid web remove feature <name>\n'
      '-h, --help    Print this usage information.\n'
      '\n'
      'Run "rapid help" to see global options.'
];

class _MockLogger extends Mock implements Logger {}

class _MockProject extends Mock implements Project {}

class _MockArgResults extends Mock implements ArgResults {}

void main() {
  group('web remove feature', () {
    Directory cwd = Directory.current;

    late Logger logger;

    late Project project;

    late ArgResults argResults;
    late String name;

    late WebRemoveFeatureCommand command;

    setUp(() {
      Directory.current = Directory.systemTemp.createTempSync();

      logger = _MockLogger();

      project = _MockProject();
      when(
        () => project.removeFeature(
          name: any(named: 'name'),
          platform: Platform.web,
          logger: logger,
        ),
      ).thenAnswer((_) async {});
      when(() => project.exists()).thenReturn(true);
      when(() => project.platformIsActivated(Platform.web)).thenReturn(true);

      argResults = _MockArgResults();
      name = 'my_new_feature';
      when(() => argResults.rest).thenReturn([name]);

      command = WebRemoveFeatureCommand(
        logger: logger,
        project: project,
      )..argResultOverrides = argResults;
    });

    tearDown(() {
      Directory.current = cwd;
    });

    test('feat is a valid alias', () {
      // Arrange
      command = WebRemoveFeatureCommand(project: project);

      // Act + Assert
      expect(command.aliases, contains('feat'));
    });

    test(
      'help',
      withRunner((commandRunner, logger, printLogs) async {
        // Act
        final result = await commandRunner.run(
          ['web', 'remove', 'feature', '--help'],
        );

        // Assert
        expect(printLogs, equals(expectedUsage));
        expect(result, equals(ExitCode.success.code));

        printLogs.clear();

        // Act
        final resultAbbr = await commandRunner.run(
          ['web', 'remove', 'feature', '-h'],
        );

        // Assert
        expect(printLogs, equals(expectedUsage));
        expect(resultAbbr, equals(ExitCode.success.code));
      }),
    );

    test('can be instantiated without explicit logger', () {
      // Act
      command = WebRemoveFeatureCommand(project: project);

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
        final result = await commandRunner.run(['web', 'remove', 'feature']);

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
        final result = await commandRunner
            .run(['web', 'remove', 'feature', 'name1', 'name2']);

        // Assert
        expect(result, equals(ExitCode.usage.code));
        verify(() => logger.err(expectedErrorMessage)).called(1);
        verify(() => logger.info('')).called(1);
      }),
    );

    // TODO more test cases for invalid patterns
    test(
      'throws UsageException when name is invalid package name',
      withRunnerOnProject(
          (commandRunner, logger, melosFile, project, printLogs) async {
        // Arrange
        name = 'My Feature';
        final expectedErrorMessage = '"$name" is not a valid package name.\n\n'
            'See https://dart.dev/tools/pub/pubspec#name for more information.';

        // Act
        final result = await commandRunner.run(
          ['web', 'remove', 'feature', name],
        );

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
      verify(() => logger.info('Removing Feature ...')).called(1);
      verify(
        () => project.removeFeature(
          name: any(named: 'name'),
          platform: Platform.web,
          logger: logger,
        ),
      ).called(1);
      verify(
        () => logger.success('Removed Web feature $name.'),
      ).called(1);
      verify(() => logger.info('')).called(1);
      expect(result, ExitCode.success.code);
    });

    test('exits with 78 when the feature does not exist', () async {
      // Arrange
      when(
        () => project.removeFeature(
          name: any(named: 'name'),
          platform: Platform.web,
          logger: logger,
        ),
      ).thenThrow(FeatureDoesNotExist());

      // Act
      final result = await command.run();

      // Assert
      verify(
        () => logger.err('The feature "$name" does not exist on Web.'),
      ).called(1);
      verify(() => logger.info('')).called(1);
      expect(result, ExitCode.config.code);
    });

    test('exits with 78 when Web is not activated', () async {
      // Arrange
      when(() => project.platformIsActivated(Platform.web)).thenReturn(false);

      // Act
      final result = await command.run();

      // Assert
      verify(() => logger.err('Web is not activated.')).called(1);
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
