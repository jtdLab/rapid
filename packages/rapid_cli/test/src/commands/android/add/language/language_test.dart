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

class _MockFeature extends Mock implements Feature {}

class _MockPlatformDirectory extends Mock implements PlatformDirectory {}

class _MockProject extends Mock implements Project {}

class _MockFlutterGenl10nCommand extends Mock
    implements _FlutterGenl10nCommand {}

class _MockMasonGenerator extends Mock implements MasonGenerator {}

class FakeDirectoryGeneratorTarget extends Fake
    implements DirectoryGeneratorTarget {}

void main() {
  group('android add language', () {
    Directory cwd = Directory.current;

    late List<String> progressLogs;
    late Progress progress;
    late Logger logger;
    late MelosFile melosFile;
    const feature1Path = 'foo/bar/one';
    const feature1Name = 'my_feature_1';
    late Feature feature1;
    const feature2Path = 'foo/bar/two';
    const feature2Name = 'my_feature_2';
    late Feature feature2;
    late List<Feature> features;
    late PlatformDirectory platformDirectory;
    late Project project;
    late _FlutterGenl10nCommand flutterGenl10n;
    final generatedFiles = List.filled(
      62,
      const GeneratedFile.created(path: ''),
    );
    late MasonGenerator generator;
    const defaultLanguage = 'en';
    late String language;
    late ArgResults argResults;

    late AndroidAddLanguageCommand command;

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
      feature1 = _MockFeature();
      when(() => feature1.defaultLanguage()).thenReturn(defaultLanguage);
      when(() => feature1.supportedLanguages())
          .thenReturn({defaultLanguage, 'de'});
      when(() => feature1.supportsLanguage(defaultLanguage)).thenReturn(true);
      when(() => feature1.supportsLanguage('de')).thenReturn(true);
      when(() => feature1.supportsLanguage('fr')).thenReturn(false);
      when(() => feature1.path).thenReturn(feature1Path);
      when(() => feature1.name).thenReturn(feature1Name);
      feature2 = _MockFeature();
      when(() => feature2.defaultLanguage()).thenReturn(defaultLanguage);
      when(() => feature2.supportedLanguages())
          .thenReturn({'de', defaultLanguage});
      when(() => feature2.supportsLanguage('de')).thenReturn(true);
      when(() => feature2.supportsLanguage(defaultLanguage)).thenReturn(true);
      when(() => feature2.supportsLanguage('fr')).thenReturn(false);
      when(() => feature2.path).thenReturn(feature2Path);
      when(() => feature2.name).thenReturn(feature2Name);
      features = [feature1, feature2];
      platformDirectory = _MockPlatformDirectory();
      when(() => platformDirectory.getFeatures(exclude: any(named: 'exclude')))
          .thenReturn(features);
      project = _MockProject();
      when(() => project.isActivated(Platform.android)).thenReturn(true);
      when(() => project.melosFile).thenReturn(melosFile);
      when(() => project.platformDirectory(Platform.android))
          .thenReturn(platformDirectory);
      flutterGenl10n = _MockFlutterGenl10nCommand();
      when(() => flutterGenl10n(cwd: any(named: 'cwd')))
          .thenAnswer((_) async {});
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
      language = 'fr';
      argResults = _MockArgResults();
      when(() => argResults.rest).thenReturn([language]);

      command = AndroidAddLanguageCommand(
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
      command = AndroidAddLanguageCommand(project: project);

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
      command = AndroidAddLanguageCommand(project: project);

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
        language = 'hello';
        final expectedErrorMessage = '"$language" is not a valid language.\n\n'
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
      verify(
        () => generator.generate(
          any(
            that: isA<DirectoryGeneratorTarget>().having(
              (g) => g.dir.path,
              'dir',
              feature1Path,
            ),
          ),
          vars: <String, dynamic>{
            'feature_name': feature1Name,
            'language': language,
          },
          logger: logger,
        ),
      ).called(1);
      verify(() => flutterGenl10n(cwd: feature1Path)).called(1);
      verify(
        () => generator.generate(
          any(
            that: isA<DirectoryGeneratorTarget>().having(
              (g) => g.dir.path,
              'dir',
              feature2Path,
            ),
          ),
          vars: <String, dynamic>{
            'feature_name': feature2Name,
            'language': language,
          },
          logger: logger,
        ),
      ).called(1);
      verify(() => flutterGenl10n(cwd: feature2Path)).called(1);
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

    test('exits with 78 when no Android features exist', () async {
      // Arrange
      features = [];
      when(() => platformDirectory.getFeatures(exclude: any(named: 'exclude')))
          .thenReturn(features);

      // Act
      final result = await command.run();

      // Assert
      verify(() => logger.err('No Android features found!\n'
              'Run "rapid android add feature" to add your first Android feature.'))
          .called(1);
      expect(result, ExitCode.config.code);
    });

    test(
        'exits with 78 when some Android features have different default languages',
        () async {
      // Arrange
      when(() => feature1.defaultLanguage()).thenReturn('de');
      features = [feature1, feature2];

      // Act
      final result = await command.run();

      // Assert
      verify(() => logger.err('The Android part of your project is corrupted.\n'
          'Because not all features have the same default language.\n\n'
          'Run "rapid doctor" to see which features are affected.')).called(1);
      expect(result, ExitCode.config.code);
    });

    test('exits with 78 when some Android features have different languages',
        () async {
      // Arrange
      when(() => feature1.supportedLanguages())
          .thenReturn({defaultLanguage, 'de'});
      when(() => feature2.supportedLanguages())
          .thenReturn({defaultLanguage, 'fr'});
      features = [feature1, feature2];

      // Act
      final result = await command.run();

      // Assert
      verify(() => logger.err('The Android part of your project is corrupted.\n'
          'Because not all features support the same languages.\n\n'
          'Run "rapid doctor" to see which features are affected.')).called(1);
      expect(result, ExitCode.config.code);
    });

    test('exits with 78 when language is already present in all features',
        () async {
      // Arrange
      language = 'de';
      when(() => argResults.rest).thenReturn([language]);

      // Act
      final result = await command.run();

      // Assert
      verify(() => project.isActivated(Platform.android)).called(1);
      verify(() => project.platformDirectory(Platform.android)).called(1);
      verify(() => platformDirectory.getFeatures(exclude: {'app', 'routing'}))
          .called(1);
      verify(() => logger.err('The language "de" is already present.'))
          .called(1);
      expect(result, ExitCode.config.code);
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
  });
}
