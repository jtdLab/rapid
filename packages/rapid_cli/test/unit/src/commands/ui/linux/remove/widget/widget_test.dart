import 'package:args/args.dart';
import 'package:mason/mason.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rapid_cli/src/commands/ui/linux/remove/widget/widget.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/project/project.dart';
import 'package:test/test.dart';
import 'package:universal_io/io.dart';

import '../../../../../../helpers/helpers.dart';
import '../../../../../mocks.dart';

const expectedUsage = [
  'Remove a widget from the Linux UI part of an existing Rapid project.\n'
      '\n'
      'Usage: rapid ui linux remove widget <name> [arguments]\n'
      '-h, --help    Print this usage information.\n'
      '\n'
      '\n'
      '-d, --dir     The directory relative to <platform_ui_package>/lib/ .\n'
      '              (defaults to ".")\n'
      '\n'
      'Run "rapid help" to see global options.'
];

void main() {
  group('ui linux remove widget', () {
    Directory cwd = Directory.current;

    late Logger logger;

    late Project project;

    late ArgResults argResults;
    late String? dir;
    late String name;

    late UiLinuxRemoveWidgetCommand command;

    setUp(() {
      Directory.current = Directory.systemTemp.createTempSync();

      logger = MockLogger();

      project = MockProject();
      when(() => project.exists()).thenReturn(true);
      when(() => project.platformIsActivated(Platform.linux)).thenReturn(true);
      when(
        () => project.removeWidget(
          name: any(named: 'name'),
          dir: any(named: 'dir'),
          platform: Platform.linux,
          logger: logger,
        ),
      ).thenAnswer((_) async {});

      argResults = MockArgResults();
      dir = null;
      name = 'FooBar';
      when(() => argResults['dir']).thenReturn(dir);
      when(() => argResults.rest).thenReturn([name]);

      command = UiLinuxRemoveWidgetCommand(
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
          ['ui', 'linux', 'remove', 'widget', '--help'],
        );

        // Assert
        expect(printLogs, equals(expectedUsage));
        expect(result, equals(ExitCode.success.code));

        printLogs.clear();

        // Act
        final resultAbbr = await commandRunner.run(
          ['ui', 'linux', 'remove', 'widget', '-h'],
        );

        // Assert
        expect(printLogs, equals(expectedUsage));
        expect(resultAbbr, equals(ExitCode.success.code));
      }),
    );

    test('can be instantiated without explicit logger', () {
      // Act
      command = UiLinuxRemoveWidgetCommand(project: project);

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
            await commandRunner.run(['ui', 'linux', 'remove', 'widget']);

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
          'linux',
          'remove',
          'widget',
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
          'ui',
          'linux',
          'remove',
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
      verify(() => logger.info('Removing Linux Widget ...')).called(1);
      verify(
        () => project.removeWidget(
          name: name,
          dir: '.',
          platform: Platform.linux,
          logger: logger,
        ),
      ).called(1);
      verify(() => logger.success('Removed Linux Widget $name.')).called(1);
      verify(() => logger.info('')).called(1);
      expect(result, ExitCode.success.code);
    });

    test('completes successfully with correct output with custom -dir',
        () async {
      // Arrange
      dir = 'foo/bar';
      when(() => argResults['dir']).thenReturn(dir);

      // Act
      final result = await command.run();

      // Assert
      verify(() => logger.info('Removing Linux Widget ...')).called(1);
      verify(
        () => project.removeWidget(
          name: name,
          dir: dir!,
          platform: Platform.linux,
          logger: logger,
        ),
      ).called(1);
      verify(() => logger.success('Removed Linux Widget $name.')).called(1);
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

    test('exits with 78 when Linux is not activated', () async {
      // Arrange
      when(() => project.platformIsActivated(Platform.linux)).thenReturn(false);

      // Act
      final result = await command.run();

      // Assert
      verify(() => logger.err('Linux is not activated.')).called(1);
      verify(() => logger.info('')).called(1);
      expect(result, ExitCode.config.code);
    });

    test('exits with 78 when the referenced widget does not exist', () async {
      // Arrange
      when(
        () => project.removeWidget(
          name: any(named: 'name'),
          dir: any(named: 'dir'),
          platform: Platform.linux,
          logger: logger,
        ),
      ).thenThrow(WidgetAlreadyExists());

      // Act
      final result = await command.run();

      // Assert
      verify(() => logger.err('Linux Widget $name not found.')).called(1);
      verify(() => logger.info('')).called(1);
      expect(result, ExitCode.config.code);
    });
  });
}
