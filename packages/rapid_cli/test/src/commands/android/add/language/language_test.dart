import 'package:args/args.dart';
import 'package:mason/mason.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rapid_cli/src/commands/android/add/language/language.dart';
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
  'Adds a language to the Android part of an existing Rapid project.\n'
      '\n'
      'Usage: rapid android add language <language>\n'
      '-h, --help    Print this usage information.\n'
      '\n'
      'Run "rapid help" to see global options.'
];

abstract class _FlutterGenl10nCommand {
  Future<void> call({String cwd});
}

class _MockArgResults extends Mock implements ArgResults {}

class _MockProgress extends Mock implements Progress {}

class _MockLogger extends Mock implements Logger {}

class _MockMelosFile extends Mock implements MelosFile {}

class _MockPlatformDirectory extends Mock implements PlatformDirectory {}

class _MockProject extends Mock implements Project {}

class _MockFlutterGenl10nCommand extends Mock
    implements _FlutterGenl10nCommand {}

class _MockMasonGenerator extends Mock implements MasonGenerator {}

class FakeDirectoryGeneratorTarget extends Fake
    implements DirectoryGeneratorTarget {}

void main() {
  Directory cwd = Directory.current;

  late List<String> progressLogs;
  late Progress progress;
  late Logger logger;
  late MelosFile melosFile;
  late List<Feature> features;
  late PlatformDirectory platformDirectory;
  late Project project;
  late _FlutterGenl10nCommand flutterGenl10n;
  final generatedFiles = List.filled(
    62,
    const GeneratedFile.created(path: ''),
  );
  late MasonGenerator generator;
  const language = 'en';
  late ArgResults argResults;

  late LanguageCommand command;

  setUpAll(() {
    registerFallbackValue(FakeDirectoryGeneratorTarget());
  });

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
    melosFile = _MockMelosFile();
    when(() => melosFile.exists()).thenReturn(true);
    features = []; // TODO
    platformDirectory = _MockPlatformDirectory();
    when(() => platformDirectory.getFeatures(exclude: any(named: 'exclude')))
        .thenReturn(features);
    project = _MockProject();
    when(() => project.isActivated(Platform.android)).thenReturn(true);
    when(() => project.melosFile).thenReturn(melosFile);
    when(() => project.platformDirectory(Platform.android))
        .thenReturn(platformDirectory);
    flutterGenl10n = _MockFlutterGenl10nCommand();
    when(() => flutterGenl10n(cwd: any(named: 'cwd'))).thenAnswer((_) async {});
    generator = _MockMasonGenerator();
    when(() => generator.id).thenReturn('generator_id');
    when(() => generator.description).thenReturn('generator description');
    when(
      () => generator.generate(
        any(),
        vars: any(named: 'vars'),
        logger: any(named: 'logger'),
      ),
    ).thenAnswer((_) async => generatedFiles);
    argResults = _MockArgResults();
    when(() => argResults.rest).thenReturn([language]);

    command = LanguageCommand(
      logger: logger,
      project: project,
      flutterGenl10n: flutterGenl10n,
      generator: (_) async => generator,
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
        ['android', 'add', 'language', '--help'],
      );

      // Assert
      expect(printLogs, equals(expectedUsage));
      expect(result, equals(ExitCode.success.code));

      printLogs.clear();

      // Act
      final resultAbbr = await commandRunner.run(
        ['android', 'add', 'language', '-h'],
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
      final result = await commandRunner.run(['android', 'add', 'language']);

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
      final result =
          await commandRunner.run(['android', 'add', 'language', 'de', 'fr']);

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
          await commandRunner.run(['android', 'add', 'language', language]);

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
    /* verify(
      () => generator.generate(
        any(
          that: isA<DirectoryGeneratorTarget>().having(
            (g) => g.dir.path,
            'dir',
            '.',
          ),
        ),
        vars: <String, dynamic>{
          'feature_name': featureName,
          'language': language,
        },
        logger: logger,
      ),
    ).called(1); */
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
