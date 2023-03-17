import 'dart:io';

import 'package:args/args.dart';
import 'package:mason/mason.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rapid_cli/src/cli/cli.dart';
import 'package:rapid_cli/src/commands/ui/android/add/widget/widget.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/project/project.dart';
import 'package:test/test.dart';

import '../../../../../common.dart';
import '../../../../../mocks.dart';

const expectedUsage = [
  'Add a widget to the Android UI part of an existing Rapid project.\n'
      '\n'
      'Usage: rapid ui android add widget <name> [arguments]\n'
      '-h, --help          Print this usage information.\n'
      '\n'
      '\n'
      '-o, --output-dir    The output directory relative to <platform_ui_package>/lib/ .\n'
      '                    (defaults to ".")\n'
      '\n'
      'Run "rapid help" to see global options.'
];

void main() {
  group('ui android add widget', () {
    Directory cwd = Directory.current;

    late Logger logger;

    late Project project;

    late DartFormatFixCommand dartFormatFix;

    late ArgResults argResults;
    late String? outputDir;
    late String name;

    late UiAndroidAddWidgetCommand command;

    setUp(() {
      Directory.current = Directory.systemTemp.createTempSync();

      logger = MockLogger();

      project = MockProject();
      when(() => project.existsAll()).thenReturn(true);
      when(() => project.platformIsActivated(Platform.android))
          .thenReturn(true);
      when(
        () => project.addWidget(
          name: any(named: 'name'),
          outputDir: any(named: 'outputDir'),
          platform: Platform.android,
          logger: logger,
        ),
      ).thenAnswer((_) async {});

      argResults = MockArgResults();
      outputDir = null;
      name = 'FooBar';
      when(() => argResults['output-dir']).thenReturn(outputDir);
      when(() => argResults.rest).thenReturn([name]);

      command = UiAndroidAddWidgetCommand(
        logger: logger,
        project: project,
        dartFormatFix: dartFormatFix,
      )..argResultOverrides = argResults;
    });

    tearDown(() {
      Directory.current = cwd;
    });

    test(
      'help',
      withRunner((commandRunner, logger, printLogs) async {
        // Act
        final result = await commandRunner.run(
          ['ui', 'android', 'add', 'widget', '--help'],
        );

        // Assert
        expect(printLogs, equals(expectedUsage));
        expect(result, equals(ExitCode.success.code));

        printLogs.clear();

        // Act
        final resultAbbr = await commandRunner.run(
          ['ui', 'android', 'add', 'widget', '-h'],
        );

        // Assert
        expect(printLogs, equals(expectedUsage));
        expect(resultAbbr, equals(ExitCode.success.code));
      }),
    );

    test('can be instantiated without explicit logger', () {
      // Act
      command = UiAndroidAddWidgetCommand(project: project);

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
        final result =
            await commandRunner.run(['ui', 'android', 'add', 'widget']);

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
          'ui',
          'android',
          'add',
          'widget',
          'Name1',
          'Name2',
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
          'ui',
          'android',
          'add',
          'widget',
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
      verify(() => logger.info('Adding Android Widget ...')).called(1);
      verify(
        () => project.addWidget(
          name: name,
          outputDir: '.',
          platform: Platform.android,
          logger: logger,
        ),
      ).called(1);
      verify(() => logger.success('Added Android Widget $name.')).called(1);
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
      verify(() => logger.info('Adding Android Widget ...')).called(1);
      verify(
        () => project.addWidget(
          name: name,
          outputDir: outputDir!,
          platform: Platform.android,
          logger: logger,
        ),
      ).called(1);
      verify(() => logger.success('Added Android Widget $name.')).called(1);
      verify(() => logger.info('')).called(1);
      expect(result, ExitCode.success.code);
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

    test('exits with 78 when Android is not activated', () async {
      // Arrange
      when(() => project.platformIsActivated(Platform.android))
          .thenReturn(false);

      // Act
      final result = await command.run();

      // Assert
      verify(() => logger.err('Android is not activated.')).called(1);
      verify(() => logger.info('')).called(1);
      expect(result, ExitCode.config.code);
    });

    test('exits with 78 when the referenced widget already exists', () async {
      // Arrange
      when(
        () => project.addWidget(
          name: any(named: 'name'),
          outputDir: any(named: 'outputDir'),
          platform: Platform.android,
          logger: logger,
        ),
      ).thenThrow(WidgetAlreadyExists());

      // Act
      final result = await command.run();

      // Assert
      verify(
        () => logger.err('Android Widget $name already exists.'),
      ).called(1);
      verify(() => logger.info('')).called(1);
      expect(result, ExitCode.config.code);
    });
  });
}
