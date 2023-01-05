import 'package:mason/mason.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rapid_cli/src/commands/android/feature/feature.dart';
import 'package:rapid_cli/src/project/project.dart';
import 'package:test/test.dart';
import 'package:universal_io/io.dart';

import '../../../../helpers/helpers.dart';

const expectedUsage = [
  'Work with features of the Android part of an existing Rapid project.\n'
      '\n'
      'Usage: rapid android features <subcommand>\n'
      '-h, --help    Print this usage information.\n'
      '\n'
      'Available subcommands:\n'
      '  add   Add components to features of the Android part of an existing Rapid project.\n'
      '\n'
      'Run "rapid help" to see global options.'
];

class _MockProgress extends Mock implements Progress {}

class _MockLogger extends Mock implements Logger {}

class _MockProject extends Mock implements Project {}

void main() {
  group('android feature', () {
    Directory cwd = Directory.current;

    late List<String> progressLogs;
    late Progress progress;
    late Logger logger;
    late Project project;

    late AndroidFeatureCommand command;

    setUp(() {
      Directory.current = Directory.systemTemp.createTempSync();

      progressLogs = <String>[];
      progress = _MockProgress();
      when(() => progress.complete(any())).thenAnswer((_) {
        final message = _.positionalArguments.elementAt(0) as String?;
        if (message != null) progressLogs.add(message);
      });
      logger = _MockLogger();
      when(() => logger.progress(any())).thenReturn(progress);
      when(() => logger.err(any())).thenReturn(null);
      project = _MockProject();

      command = AndroidFeatureCommand(
        logger: logger,
        project: project,
      );
    });

    tearDown(() {
      Directory.current = cwd;
    });

    test('feat is a valid alias', () {
      // Arrange
      command = AndroidFeatureCommand(project: project);

      // Act + Assert
      expect(command.aliases, contains('feat'));
    });

    test(
      'help',
      withRunner((commandRunner, logger, printLogs) async {
        // Act
        final result = await commandRunner.run(
          ['android', 'feature', '--help'],
        );

        // Assert
        expect(printLogs, equals(expectedUsage));
        expect(result, equals(ExitCode.success.code));

        printLogs.clear();

        // Act
        final resultAbbr = await commandRunner.run(
          ['android', 'feature', '-h'],
        );

        // Assert
        expect(printLogs, equals(expectedUsage));
        expect(resultAbbr, equals(ExitCode.success.code));
      }),
    );

    test('can be instantiated without explicit logger', () {
      // Act
      command = AndroidFeatureCommand(project: project);

      // Assert
      expect(command, isNotNull);
    });
  });
}
