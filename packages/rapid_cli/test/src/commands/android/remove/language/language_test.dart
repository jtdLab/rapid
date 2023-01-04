import 'package:args/args.dart';
import 'package:mason/mason.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rapid_cli/src/commands/android/remove/language/language.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/project/feature.dart';
import 'package:rapid_cli/src/project/melos_file.dart';
import 'package:rapid_cli/src/project/platform_directory.dart';
import 'package:rapid_cli/src/project/project.dart';
import 'package:test/test.dart';
import 'package:universal_io/io.dart';

import '../../../../../helpers/helpers.dart';

const expectedUsage = [
  // ignore: no_adjacent_strings_in_list
  'Removes a language from the Android part of an existing Rapid project.\n'
      '\n'
      'Usage: rapid android remove language <language>\n'
      '-h, --help    Print this usage information.\n'
      '\n'
      'Run "rapid help" to see global options.'
];

abstract class FlutterGenl10nCommand {
  Future<void> call({String cwd});
}

class MockArgResults extends Mock implements ArgResults {}

class MockProgress extends Mock implements Progress {}

class MockLogger extends Mock implements Logger {}

class MockMelosFile extends Mock implements MelosFile {}

class MockPlatformDirectory extends Mock implements PlatformDirectory {}

class MockProject extends Mock implements Project {}

class MockFlutterGenl10nCommand extends Mock implements FlutterGenl10nCommand {}

void main() {
  Directory cwd = Directory.current;

  late List<String> progressLogs;
  late Progress progress;
  late Logger logger;
  late MelosFile melosFile;
  late List<Feature> features;
  late PlatformDirectory platformDirectory;
  late Project project;
  late FlutterGenl10nCommand flutterGenl10n;
  const language = 'en';
  late ArgResults argResults;

  late LanguageCommand command;

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
    features = []; // TODO
    platformDirectory = MockPlatformDirectory();
    when(() => platformDirectory.getFeatures(exclude: any(named: 'exclude')))
        .thenReturn(features);
    project = MockProject();
    when(() => project.isActivated(Platform.android)).thenReturn(true);
    when(() => project.melosFile).thenReturn(melosFile);
    when(() => project.platformDirectory(Platform.android))
        .thenReturn(platformDirectory);
    flutterGenl10n = MockFlutterGenl10nCommand();
    when(() => flutterGenl10n(cwd: any(named: 'cwd'))).thenAnswer((_) async {});
    argResults = MockArgResults();
    when(() => argResults.rest).thenReturn([language]);

    command = LanguageCommand(
      logger: logger,
      project: project,
      flutterGenl10n: flutterGenl10n,
    )..argResultOverrides = argResults;
  });

  tearDown(() {
    Directory.current = cwd;
  });

  test('lang is a valid alias', () {
    // Arrange
    command = LanguageCommand(project: project);

    // Act + Assert
    expect(command.aliases, contains('lang'));
  });

  test(
    'help',
    withRunner((commandRunner, logger, printLogs) async {
      // Act
      final result = await commandRunner.run(
        ['android', 'remove', 'language', '--help'],
      );

      // Assert
      expect(printLogs, equals(expectedUsage));
      expect(result, equals(ExitCode.success.code));

      printLogs.clear();

      // Act
      final resultAbbr = await commandRunner.run(
        ['android', 'remove', 'language', '-h'],
      );

      // Assert
      expect(printLogs, equals(expectedUsage));
      expect(resultAbbr, equals(ExitCode.success.code));
    }),
  );

  test('can be instantiated without explicit logger', () {
    // Act
    command = LanguageCommand(project: project);
    // Assert
    expect(command, isNotNull);
  });

  test(
    'throws UsageException when languages is missing',
    withRunnerOnProject(
        (commandRunner, logger, melosFile, project, printLogs) async {
      // Arrange
      const expectedErrorMessage = 'No option specified for the language.';

      // Act
      final result = await commandRunner.run(['android', 'remove', 'language']);

      // Assert
      expect(result, equals(ExitCode.usage.code));
      verify(() => logger.err(expectedErrorMessage)).called(1);
    }),
  );

  test(
    'throws UsageException when multiple languages are provided',
    withRunnerOnProject(
        (commandRunner, logger, melosFile, project, printLogs) async {
      // Arrange
      const expectedErrorMessage = 'Multiple languages specified.';

      // Act
      final result = await commandRunner
          .run(['android', 'remove', 'language', 'de', 'fr']);

      // Assert
      expect(result, equals(ExitCode.usage.code));
      verify(() => logger.err(expectedErrorMessage)).called(1);
    }),
  );

  test(
    'throws UsageException when invalid language is provided',
    withRunnerOnProject(
        (commandRunner, logger, melosFile, project, printLogs) async {
      // Arrange
      const language = 'hello';
      const expectedErrorMessage = '"$language" is not a valid language.\n\n'
          'See https://www.iana.org/assignments/language-subtag-registry/language-subtag-registry for more information.';

      // Act
      final result =
          await commandRunner.run(['android', 'remove', 'language', language]);

      // Assert
      expect(result, equals(ExitCode.usage.code));
      verify(() => logger.err(expectedErrorMessage)).called(1);
    }),
  );

  test('completes successfully with correct output', () async {
    // Act
    final result = await command.run();

    // Assert
    verify(() => project.isActivated(Platform.android)).called(1);
    verify(() => project.platformDirectory(Platform.android)).called(1);
    verify(() => platformDirectory.getFeatures(exclude: {'app', 'routing'}))
        .called(1);
    // TODO assert stuff
    expect(result, ExitCode.success.code);
  });

  test('exits with 66 when melos.yaml does not exist', () async {
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

  test('exits with 78 when Android is not activated', () async {
    // Arrange
    when(() => project.isActivated(Platform.android)).thenReturn(false);

    // Act
    final result = await command.run();

    // Assert
    verify(() => logger.err('Android is not activated.')).called(1);
    expect(result, ExitCode.config.code);
  });
}
