import 'package:mason/mason.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rapid_cli/src/commands/deactivate/macos/macos.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/project/project.dart';
import 'package:test/test.dart';
import 'package:universal_io/io.dart';

import '../../../../helpers/helpers.dart';

const expectedUsage = [
  'Removes support for macOS from this project.\n'
      '\n'
      'Usage: rapid deactivate macos\n'
      '-h, --help    Print this usage information.\n'
      '\n'
      'Run "rapid help" to see global options.'
];

class _MockLogger extends Mock implements Logger {}

class _MockProgress extends Mock implements Progress {}

class _MockProject extends Mock implements Project {}

void main() {
  group('deactivate macos', () {
    Directory cwd = Directory.current;

    late Logger logger;
    late Progress progress;
    late List<String> progressLogs;

    late Project project;

    late DeactivateMacosCommand command;

    setUp(() {
      Directory.current = Directory.systemTemp.createTempSync();

      logger = _MockLogger();
      progress = _MockProgress();
      progressLogs = <String>[];
      when(() => progress.complete(any())).thenAnswer((_) {
        final message = _.positionalArguments.elementAt(0) as String?;
        if (message != null) progressLogs.add(message);
      });
      when(() => logger.progress(any())).thenReturn(progress);

      project = _MockProject();
      when(() => project.deactivatePlatform(Platform.macos, logger: logger))
          .thenAnswer((_) async {});
      when(() => project.exists()).thenReturn(true);
      when(() => project.platformIsActivated(Platform.macos)).thenReturn(true);

      command = DeactivateMacosCommand(
        logger: logger,
        project: project,
      );
    });

    tearDown(() {
      Directory.current = cwd;
    });

    test('m is a valid alias', () {
      // Assert
      expect(command.aliases, contains('m'));
    });

    test('mac is a valid alias', () {
      // Assert
      expect(command.aliases, contains('mac'));
    });

    test(
      'help',
      withRunner((commandRunner, logger, printLogs) async {
        // Act
        final result =
            await commandRunner.run(['deactivate', 'macos', '--help']);

        // Assert
        expect(printLogs, equals(expectedUsage));
        expect(result, equals(ExitCode.success.code));

        printLogs.clear();

        // Act
        final resultAbbr =
            await commandRunner.run(['deactivate', 'macos', '-h']);

        // Assert
        expect(printLogs, equals(expectedUsage));
        expect(resultAbbr, equals(ExitCode.success.code));
      }),
    );

    test('can be instantiated without explicit logger', () {
      // Act
      final command = DeactivateMacosCommand(project: project);

      // Assert
      expect(command, isNotNull);
    });

    test('completes successfully with correct output', () async {
      // Act
      final result = await command.run();

      // Assert
      verify(() => project.platformIsActivated(Platform.macos)).called(1);
      verify(() => logger.info('Deactivating macOS ...')).called(1);
      verify(() => project.deactivatePlatform(Platform.macos, logger: logger))
          .called(1);
      verify(() => logger.success('macOS is now deactivated.')).called(1);
      expect(result, ExitCode.success.code);
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

    test('exits with 78 when macos is not activated', () async {
      // Arrange
      when(() => project.platformIsActivated(Platform.macos)).thenReturn(false);

      // Act
      final result = await command.run();

      // Assert
      verify(() => project.platformIsActivated(Platform.macos)).called(1);
      verify(() => logger.err('macOS is already deactivated.')).called(1);
      expect(result, ExitCode.config.code);
    });
  });
}
