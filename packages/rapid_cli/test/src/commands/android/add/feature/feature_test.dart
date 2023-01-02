import 'package:mason/mason.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rapid_cli/src/commands/android/add/feature/feature.dart';
import 'package:rapid_cli/src/project/melos_file.dart';
import 'package:rapid_cli/src/project/project.dart';
import 'package:test/test.dart';
import 'package:universal_io/io.dart';

import '../../../../../helpers/helpers.dart';

const expectedUsage = [
  // ignore: no_adjacent_strings_in_list
  'Adds a feature to the Android part of an existing Rapid project.\n'
      '\n'
      'Usage: rapid android add feature [arguments]\n'
      '-h, --help    Print this usage information.\n'
      '\n'
      '\n'
      '    --name    The name of this new feature. This must be a valid dart package name.\n'
      '    --desc    The description of this new feature.\n'
      '              (defaults to "A Rapid feature.")\n'
      '\n'
      'Run "rapid help" to see global options.'
];

class MockProgress extends Mock implements Progress {}

class MockLogger extends Mock implements Logger {}

class MockMelosFile extends Mock implements MelosFile {}

class MockProject extends Mock implements Project {}

void main() {
  Directory cwd = Directory.current;

  late List<String> progressLogs;
  late Progress progress;
  late Logger logger;
  late MelosFile melosFile;
  late Project project;

  late FeatureCommand command;

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
    melosFile = MockMelosFile();
    when(() => melosFile.exists()).thenReturn(true);
    project = MockProject();
    when(() => project.melosFile).thenReturn(melosFile);

    command = FeatureCommand(
      logger: logger,
      project: project,
    );
  });

  tearDown(() {
    Directory.current = cwd;
  });

  test('feat is a valid alias', () {
    // Arrange
    command = FeatureCommand(project: project);

    // Act + Assert
    expect(command.aliases, contains('feat'));
  });

  test(
    'help',
    withRunner((commandRunner, logger, project, printLogs) async {
      // Act
      final result = await commandRunner.run(
        ['android', 'add', 'feature', '--help'],
      );

      // Assert
      expect(printLogs, equals(expectedUsage));
      expect(result, equals(ExitCode.success.code));

      printLogs.clear();

      // Act
      final resultAbbr = await commandRunner.run(
        ['android', 'add', 'feature', '-h'],
      );

      // Assert
      expect(printLogs, equals(expectedUsage));
      expect(resultAbbr, equals(ExitCode.success.code));
    }),
  );

  test('can be instantiated without explicit logger', () {
    // Act
    command = FeatureCommand(project: project);

    // Assert
    expect(command, isNotNull);
  });

  /* test('completes successfully with correct output', () async {
    // Act
    final result = await command.run();

    // Assert
    // TODO assert stuff
    expect(result, ExitCode.success.code);
  }); */

  test('exits with 66 when melos does not exist', () async {
    // Arrange
    when(() => melosFile.exists()).thenReturn(false);

    // Act
    final result = await command.run();

    // Assert
    verify(() => logger.err('''
 Could not find a melos.yaml.
 This command should be run from the root of your Rapid project.''')).called(1);
    expect(result, ExitCode.noInput.code);
  });
}
