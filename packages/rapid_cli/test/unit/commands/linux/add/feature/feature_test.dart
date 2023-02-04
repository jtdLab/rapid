import 'package:args/args.dart';
import 'package:mason/mason.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rapid_cli/src/commands/linux/add/feature/feature.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/project/project.dart';
import 'package:test/test.dart';
import 'dart:io';

import '../../../../common.dart';
import '../../../../mocks.dart';

const expectedUsage = [
  'Add a feature to the Linux part of an existing Rapid project.\n'
      '\n'
      'Usage: rapid linux add feature <name> [arguments]\n'
      '-h, --help       Print this usage information.\n'
      '\n'
      '\n'
      '    --desc       The description of this new feature.\n'
      '                 (defaults to "A Rapid feature.")\n'
      '    --routing    Wheter the new feature can be registered in the routing package.\n'
      '\n'
      'Run "rapid help" to see global options.'
];

void main() {
  group('linux add feature', () {
    Directory cwd = Directory.current;

    late Logger logger;

    late Project project;

    late ArgResults argResults;
    late String? description;
    late bool routing;
    late String name;

    late LinuxAddFeatureCommand command;

    setUp(() {
      Directory.current = Directory.systemTemp.createTempSync();

      logger = MockLogger();

      project = MockProject();
      when(
        () => project.addFeature(
          name: any(named: 'name'),
          description: any(named: 'description'),
          routing: any(named: 'routing'),
          platform: Platform.linux,
          logger: logger,
        ),
      ).thenAnswer((_) async {});
      when(() => project.exists()).thenReturn(true);
      when(() => project.platformIsActivated(Platform.linux)).thenReturn(true);

      argResults = MockArgResults();
      description = null;
      when(() => argResults['desc']).thenReturn(description);
      routing = false;
      when(() => argResults['routing']).thenReturn(routing);
      name = 'my_cool_feature';
      when(() => argResults.rest).thenReturn([name]);

      command = LinuxAddFeatureCommand(
        logger: logger,
        project: project,
      )..argResultOverrides = argResults;
    });

    tearDown(() {
      Directory.current = cwd;
    });

    test('feat is a valid alias', () {
      // Arrange
      command = LinuxAddFeatureCommand(project: project);

      // Act + Assert
      expect(command.aliases, contains('feat'));
    });

    test(
      'help',
      withRunner((commandRunner, logger, printLogs) async {
        // Act
        final result = await commandRunner.run(
          ['linux', 'add', 'feature', '--help'],
        );

        // Assert
        expect(printLogs, equals(expectedUsage));
        expect(result, equals(ExitCode.success.code));

        printLogs.clear();

        // Act
        final resultAbbr = await commandRunner.run(
          ['linux', 'add', 'feature', '-h'],
        );

        // Assert
        expect(printLogs, equals(expectedUsage));
        expect(resultAbbr, equals(ExitCode.success.code));
      }),
    );

    test('can be instantiated without explicit logger', () {
      // Act
      command = LinuxAddFeatureCommand(project: project);

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
        final result = await commandRunner.run(['linux', 'add', 'feature']);

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
            .run(['linux', 'add', 'feature', 'name1', 'name2']);

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
          ['linux', 'add', 'feature', name],
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
      verify(() => logger.info('Adding Feature ...')).called(1);
      verify(
        () => project.addFeature(
          name: name,
          description: 'A Rapid feature.',
          routing: false,
          platform: Platform.linux,
          logger: logger,
        ),
      ).called(1);
      verify(() => logger.success('Added Linux feature $name.')).called(1);
      verify(() => logger.info('')).called(1);
      expect(result, ExitCode.success.code);
    });

    test('completes successfully with correct output w/ --desc', () async {
      // Arrange
      description = 'My cool description.';
      when(() => argResults['desc']).thenReturn(description);

      // Act
      final result = await command.run();

      // Assert
      verify(() => logger.info('Adding Feature ...')).called(1);
      verify(
        () => project.addFeature(
          name: name,
          description: description!,
          routing: false,
          platform: Platform.linux,
          logger: logger,
        ),
      ).called(1);
      verify(() => logger.success('Added Linux feature $name.')).called(1);
      verify(() => logger.info('')).called(1);
      expect(result, ExitCode.success.code);
    });

    test('completes successfully with correct output w/ --routing', () async {
      // Arrange
      routing = true;
      when(() => argResults['routing']).thenReturn(routing);

      // Act
      final result = await command.run();

      // Assert
      verify(() => logger.info('Adding Feature ...')).called(1);
      verify(
        () => project.addFeature(
          name: name,
          description: 'A Rapid feature.',
          routing: routing,
          platform: Platform.linux,
          logger: logger,
        ),
      ).called(1);
      verify(() => logger.success('Added Linux feature $name.')).called(1);
      verify(() => logger.info('')).called(1);
      expect(result, ExitCode.success.code);
    });

    test('exits with 78 when Linux is not activated', () async {
      // Arrange
      when(() => project.platformIsActivated(Platform.linux)).thenReturn(false);

      // Act
      final result = await command.run();

      // AssertØÏ
      verify(() => logger.err('Linux is not activated.')).called(1);
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
