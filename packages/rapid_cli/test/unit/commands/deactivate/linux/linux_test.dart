import 'package:mason/mason.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rapid_cli/src/commands/deactivate/linux/linux.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/project/project.dart';
import 'package:test/test.dart';
import 'dart:io';

import '../../../common.dart';
import '../../../mocks.dart';

const expectedUsage = [
  'Removes support for Linux from this project.\n'
      '\n'
      'Usage: rapid deactivate linux\n'
      '-h, --help    Print this usage information.\n'
      '\n'
      'Run "rapid help" to see global options.'
];

void main() {
  group('deactivate linux', () {
    Directory cwd = Directory.current;

    late Logger logger;

    late Project project;

    late DeactivateLinuxCommand command;

    setUp(() {
      Directory.current = Directory.systemTemp.createTempSync();

      logger = MockLogger();

      project = MockProject();
      when(() => project.removePlatform(Platform.linux, logger: logger))
          .thenAnswer((_) async {});
      when(() => project.exists()).thenReturn(true);
      when(() => project.platformIsActivated(Platform.linux)).thenReturn(true);

      command = DeactivateLinuxCommand(
        logger: logger,
        project: project,
      );
    });

    tearDown(() {
      Directory.current = cwd;
    });

    test('l is a valid alias', () {
      // Assert
      expect(command.aliases, contains('l'));
    });

    test('lin is a valid alias', () {
      // Assert
      expect(command.aliases, contains('lin'));
    });

    test(
      'help',
      withRunner((commandRunner, logger, printLogs) async {
        // Act
        final result =
            await commandRunner.run(['deactivate', 'linux', '--help']);

        // Assert
        expect(printLogs, equals(expectedUsage));
        expect(result, equals(ExitCode.success.code));

        printLogs.clear();

        // Act
        final resultAbbr =
            await commandRunner.run(['deactivate', 'linux', '-h']);

        // Assert
        expect(printLogs, equals(expectedUsage));
        expect(resultAbbr, equals(ExitCode.success.code));
      }),
    );

    test('can be instantiated without explicit logger', () {
      // Act
      final command = DeactivateLinuxCommand(project: project);

      // Assert
      expect(command, isNotNull);
    });

    test('completes successfully with correct output', () async {
      // Act
      final result = await command.run();

      // Assert
      verify(() => project.platformIsActivated(Platform.linux)).called(1);
      verify(() => logger.info('Deactivating Linux ...')).called(1);
      verify(() => project.removePlatform(Platform.linux, logger: logger))
          .called(1);
      verify(() => logger.success('Linux is now deactivated.')).called(1);
      verify(() => logger.info('')).called(1);
      expect(result, ExitCode.success.code);
    });

    test('exits with 66 when project does not exist', () async {
      // Arrange
      when(() => project.exists()).thenReturn(false);

      // Act
      final result = await command.run();

      // Assert
      verify(() => logger.err(
              'This command should be run from the root of an existing Rapid project.'))
          .called(1);
      verify(() => logger.info('')).called(1);
      expect(result, ExitCode.noInput.code);
    });

    test('exits with 78 when linux is not activated', () async {
      // Arrange
      when(() => project.platformIsActivated(Platform.linux)).thenReturn(false);

      // Act
      final result = await command.run();

      // Assert
      verify(() => project.platformIsActivated(Platform.linux)).called(1);
      verify(() => logger.err('Linux is already deactivated.')).called(1);
      verify(() => logger.info('')).called(1);
      expect(result, ExitCode.config.code);
    });
  });
}
