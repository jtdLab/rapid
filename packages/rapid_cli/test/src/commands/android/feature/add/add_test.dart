import 'package:mason/mason.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rapid_cli/src/commands/android/feature/add/add.dart';
import 'package:rapid_cli/src/project/project.dart';
import 'package:test/test.dart';
import 'package:universal_io/io.dart';

import '../../../../../helpers/helpers.dart';

const expectedUsage = [
  // ignore: no_adjacent_strings_in_list
  'Add components to features of the Android part of an existing Rapid project.\n'
      '\n'
      'Usage: rapid android feature add <subcommand>\n'
      '-h, --help    Print this usage information.\n'
      '\n'
      'Available subcommands:\n'
      '  bloc    Adds a bloc to a feature of the Android part of an existing Rapid project.\n'
      '  cubit   Adds a cubit to a feature of the Android part of an existing Rapid project.\n'
      '\n'
      'Run "rapid help" to see global options.'
];

class MockProgress extends Mock implements Progress {}

class MockLogger extends Mock implements Logger {}

class MockProject extends Mock implements Project {}

void main() {
  Directory cwd = Directory.current;

  late List<String> progressLogs;
  late Progress progress;
  late Logger logger;
  late Project project;

  late AddCommand command;

  setUp(() {
    Directory.current = Directory.systemTemp.createTempSync();

    progressLogs = <String>[];
    progress = MockProgress();
    when(() => progress.complete(any())).thenAnswer((_) {
      final message = _.positionalArguments.elementAt(0) as String?;
      if (message != null) progressLogs.add(message);
    });
    logger = MockLogger();
    when(() => logger.progress(any())).thenReturn(progress);
    when(() => logger.err(any())).thenReturn(null);
    project = MockProject();

    command = AddCommand(
      logger: logger,
      project: project,
    );
  });

  tearDown(() {
    Directory.current = cwd;
  });

  test(
    'help',
    withRunner((commandRunner, logger, printLogs) async {
      // Act
      final result = await commandRunner.run(
        ['android', 'feature', 'add', '--help'],
      );

      // Assert
      expect(printLogs, equals(expectedUsage));
      expect(result, equals(ExitCode.success.code));

      printLogs.clear();

      // Act
      final resultAbbr = await commandRunner.run(
        ['android', 'feature', 'add', '-h'],
      );

      // Assert
      expect(printLogs, equals(expectedUsage));
      expect(resultAbbr, equals(ExitCode.success.code));
    }),
  );

  test('can be instantiated without explicit logger', () {
    // Act
    command = AddCommand(project: project);

    // Assert
    expect(command, isNotNull);
  });
}
