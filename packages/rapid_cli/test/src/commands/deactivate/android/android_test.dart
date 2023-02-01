import 'package:mason/mason.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rapid_cli/src/commands/deactivate/android/android.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/project/project.dart';
import 'package:test/test.dart';
import 'package:universal_io/io.dart';

import '../../../../helpers/helpers.dart';

const expectedUsage = [
  'Removes support for Android from this project.\n'
      '\n'
      'Usage: rapid deactivate android\n'
      '-h, --help    Print this usage information.\n'
      '\n'
      'Run "rapid help" to see global options.'
];

class _MockLogger extends Mock implements Logger {}

class _MockProject extends Mock implements Project {}

void main() {
  group('deactivate android', () {
    Directory cwd = Directory.current;

    late Logger logger;

    late Project project;

    late DeactivateAndroidCommand command;

    setUp(() {
      Directory.current = Directory.systemTemp.createTempSync();

      logger = _MockLogger();

      project = _MockProject();
      when(() => project.removePlatform(Platform.android, logger: logger))
          .thenAnswer((_) async {});
      when(() => project.exists()).thenReturn(true);
      when(() => project.platformIsActivated(Platform.android))
          .thenReturn(true);

      command = DeactivateAndroidCommand(
        logger: logger,
        project: project,
      );
    });

    tearDown(() {
      Directory.current = cwd;
    });

    test('a is a valid alias', () {
      // Assert
      expect(command.aliases, contains('a'));
    });

    test(
      'help',
      withRunner((commandRunner, logger, printLogs) async {
        // Act
        final result =
            await commandRunner.run(['deactivate', 'android', '--help']);

        // Assert
        expect(printLogs, equals(expectedUsage));
        expect(result, equals(ExitCode.success.code));

        printLogs.clear();

        // Act
        final resultAbbr =
            await commandRunner.run(['deactivate', 'android', '-h']);

        // Assert
        expect(printLogs, equals(expectedUsage));
        expect(resultAbbr, equals(ExitCode.success.code));
      }),
    );

    test('can be instantiated without explicit logger', () {
      // Act
      final command = DeactivateAndroidCommand(project: project);

      // Assert
      expect(command, isNotNull);
    });

    test('completes successfully with correct output', () async {
      // Act
      final result = await command.run();

      // Assert
      verify(() => project.platformIsActivated(Platform.android)).called(1);
      verify(() => logger.info('Deactivating Android ...')).called(1);
      verify(() => project.removePlatform(Platform.android, logger: logger))
          .called(1);
      verify(() => logger.success('Android is now deactivated.')).called(1);
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

    test('exits with 78 when android is not activated', () async {
      // Arrange
      when(() => project.platformIsActivated(Platform.android))
          .thenReturn(false);

      // Act
      final result = await command.run();

      // Assert
      verify(() => project.platformIsActivated(Platform.android)).called(1);
      verify(() => logger.err('Android is already deactivated.')).called(1);
      expect(result, ExitCode.config.code);
    });
  });
}
