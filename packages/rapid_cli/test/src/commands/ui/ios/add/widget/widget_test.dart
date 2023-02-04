import 'package:args/args.dart';
import 'package:mason/mason.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rapid_cli/src/commands/ui/ios/add/widget/widget.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/project/project.dart';
import 'package:test/test.dart';
import 'package:universal_io/io.dart';

import '../../../../../../helpers/helpers.dart';
import '../../../../../mocks.dart';

const expectedUsage = [
  'Add a widget to the iOS UI part of an existing Rapid project.\n'
      '\n'
      'Usage: rapid ui ios add widget <name> [arguments]\n'
      '-h, --help          Print this usage information.\n'
      '\n'
      '\n'
      '-o, --output-dir    The output directory relative to <platform_ui_package>/lib/ .\n'
      '                    (defaults to ".")\n'
      '\n'
      'Run "rapid help" to see global options.'
];

void main() {
  group('ui ios add widget', () {
    Directory cwd = Directory.current;

    late Logger logger;

    late Project project;

    late ArgResults argResults;
    late String? outputDir;
    late String name;

    late UiIosAddWidgetCommand command;

    setUp(() {
      Directory.current = Directory.systemTemp.createTempSync();

      logger = MockLogger();

      project = MockProject();
      when(() => project.exists()).thenReturn(true);
      when(() => project.platformIsActivated(Platform.ios)).thenReturn(true);
      when(
        () => project.addWidget(
          name: any(named: 'name'),
          outputDir: any(named: 'outputDir'),
          platform: Platform.ios,
          logger: logger,
        ),
      ).thenAnswer((_) async {});

      argResults = MockArgResults();
      outputDir = null;
      name = 'FooBar';
      when(() => argResults['output-dir']).thenReturn(outputDir);
      when(() => argResults.rest).thenReturn([name]);

      command = UiIosAddWidgetCommand(
        logger: logger,
        project: project,
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
          ['ui', 'ios', 'add', 'widget', '--help'],
        );

        // Assert
        expect(printLogs, equals(expectedUsage));
        expect(result, equals(ExitCode.success.code));

        printLogs.clear();

        // Act
        final resultAbbr = await commandRunner.run(
          ['ui', 'ios', 'add', 'widget', '-h'],
        );

        // Assert
        expect(printLogs, equals(expectedUsage));
        expect(resultAbbr, equals(ExitCode.success.code));
      }),
    );

    test('can be instantiated without explicit logger', () {
      // Act
      command = UiIosAddWidgetCommand(project: project);

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
        final result = await commandRunner.run(['ui', 'ios', 'add', 'widget']);

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
          'ios',
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
          'ios',
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
      verify(() => logger.info('Adding iOS Widget ...')).called(1);
      verify(
        () => project.addWidget(
          name: name,
          outputDir: '.',
          platform: Platform.ios,
          logger: logger,
        ),
      ).called(1);
      verify(() => logger.success('Added iOS Widget $name.')).called(1);
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
      verify(() => logger.info('Adding iOS Widget ...')).called(1);
      verify(
        () => project.addWidget(
          name: name,
          outputDir: outputDir!,
          platform: Platform.ios,
          logger: logger,
        ),
      ).called(1);
      verify(() => logger.success('Added iOS Widget $name.')).called(1);
      verify(() => logger.info('')).called(1);
      expect(result, ExitCode.success.code);
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

    test('exits with 78 when iOS is not activated', () async {
      // Arrange
      when(() => project.platformIsActivated(Platform.ios)).thenReturn(false);

      // Act
      final result = await command.run();

      // Assert
      verify(() => logger.err('iOS is not activated.')).called(1);
      verify(() => logger.info('')).called(1);
      expect(result, ExitCode.config.code);
    });
  });
}
