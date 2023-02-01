import 'package:mason/mason.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rapid_cli/src/commands/deactivate/ios/ios.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/project/project.dart';
import 'package:test/test.dart';
import 'package:universal_io/io.dart';

import '../../../../helpers/helpers.dart';

const expectedUsage = [
  'Removes support for iOS from this project.\n'
      '\n'
      'Usage: rapid deactivate ios\n'
      '-h, --help    Print this usage information.\n'
      '\n'
      'Run "rapid help" to see global options.'
];

class _MockLogger extends Mock implements Logger {}

class _MockProject extends Mock implements Project {}

void main() {
  group('deactivate ios', () {
    Directory cwd = Directory.current;

    late Logger logger;

    late Project project;

    late DeactivateIosCommand command;

    setUp(() {
      Directory.current = Directory.systemTemp.createTempSync();

      logger = _MockLogger();

      project = _MockProject();
      when(() => project.removePlatform(Platform.ios, logger: logger))
          .thenAnswer((_) async {});
      when(() => project.exists()).thenReturn(true);
      when(() => project.platformIsActivated(Platform.ios)).thenReturn(true);

      command = DeactivateIosCommand(
        logger: logger,
        project: project,
      );
    });

    tearDown(() {
      Directory.current = cwd;
    });

    test('i is a valid alias', () {
      // Assert
      expect(command.aliases, contains('i'));
    });

    test(
      'help',
      withRunner((commandRunner, logger, printLogs) async {
        // Act
        final result = await commandRunner.run(['deactivate', 'ios', '--help']);

        // Assert
        expect(printLogs, equals(expectedUsage));
        expect(result, equals(ExitCode.success.code));

        printLogs.clear();

        // Act
        final resultAbbr = await commandRunner.run(['deactivate', 'ios', '-h']);

        // Assert
        expect(printLogs, equals(expectedUsage));
        expect(resultAbbr, equals(ExitCode.success.code));
      }),
    );

    test('can be instantiated without explicit logger', () {
      // Act
      final command = DeactivateIosCommand(project: project);

      // Assert
      expect(command, isNotNull);
    });

    test('completes successfully with correct output', () async {
      // Act
      final result = await command.run();

      // Assert
      verify(() => project.platformIsActivated(Platform.ios)).called(1);
      verify(() => logger.info('Deactivating iOS ...')).called(1);
      verify(() => project.removePlatform(Platform.ios, logger: logger))
          .called(1);
      verify(() => logger.success('iOS is now deactivated.')).called(1);
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
      expect(result, ExitCode.noInput.code);
    });

    test('exits with 78 when ios is not activated', () async {
      // Arrange
      when(() => project.platformIsActivated(Platform.ios)).thenReturn(false);

      // Act
      final result = await command.run();

      // Assert
      verify(() => project.platformIsActivated(Platform.ios)).called(1);
      verify(() => logger.err('iOS is already deactivated.')).called(1);
      expect(result, ExitCode.config.code);
    });
  });
}
