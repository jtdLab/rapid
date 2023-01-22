import 'package:args/args.dart';
import 'package:mason/mason.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rapid_cli/src/cli/cli.dart';
import 'package:rapid_cli/src/commands/windows/add/language/language.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/project/feature.dart';
import 'package:rapid_cli/src/project/melos_file.dart';
import 'package:rapid_cli/src/project/platform_directory.dart';
import 'package:rapid_cli/src/project/project.dart';
import 'package:test/test.dart';
import 'package:universal_io/io.dart';

import '../../../../../helpers/helpers.dart';

const expectedUsage = [
  'Add a language to the Windows part of an existing Rapid project.\n'
      '\n'
      'Usage: rapid windows add language <language>\n'
      '-h, --help    Print this usage information.\n'
      '\n'
      'Run "rapid help" to see global options.'
];

abstract class _FlutterGenl10nCommand {
  Future<void> call({String cwd, required Logger logger});
}

abstract class _FlutterFormatFixCommand {
  Future<void> call({String cwd, required Logger logger});
}

class _MockLogger extends Mock implements Logger {}

class _MockProgress extends Mock implements Progress {}

class _MockProject extends Mock implements Project {}

class _MockMelosFile extends Mock implements MelosFile {}

class _MockPlatformDirectory extends Mock implements PlatformDirectory {}

class _MockFeature extends Mock implements Feature {}

class _MockFlutterGenl10nCommand extends Mock
    implements _FlutterGenl10nCommand {}

class _MockFlutterFormatFixCommand extends Mock
    implements _FlutterFormatFixCommand {}

class _MockMasonGenerator extends Mock implements MasonGenerator {}

class _MockArgResults extends Mock implements ArgResults {}

class _FakeDirectoryGeneratorTarget extends Fake
    implements DirectoryGeneratorTarget {}

void main() {
  group('windows add language', () {
    Directory cwd = Directory.current;

    late Logger logger;
    late List<String> progressLogs;

    late Project project;
    late MelosFile melosFile;
    late PlatformDirectory platformDirectory;
    late List<Feature> features;
    const defaultLanguage = 'en';
    late Feature feature1;
    const feature1Name = 'my_feature_1';
    const feature1Path = 'foo/bar/one';
    late Feature feature2;
    const feature2Name = 'my_feature_2';
    const feature2Path = 'foo/bar/two';

    late FlutterGenl10nCommand flutterGenl10n;

    late FlutterFormatFixCommand flutterFormatFix;

    late MasonGenerator generator;
    final generatedFiles = List.filled(
      23,
      const GeneratedFile.created(path: ''),
    );

    late ArgResults argResults;
    late String language;

    late WindowsAddLanguageCommand command;

    setUpAll(() {
      registerFallbackValue(_FakeDirectoryGeneratorTarget());
    });

    setUp(() {
      Directory.current = Directory.systemTemp.createTempSync();

      logger = _MockLogger();
      final progress = _MockProgress();
      progressLogs = <String>[];
      when(() => progress.complete(any())).thenAnswer((_) {
        final message = _.positionalArguments.elementAt(0) as String?;
        if (message != null) progressLogs.add(message);
      });
      when(() => logger.progress(any())).thenReturn(progress);

      project = _MockProject();
      melosFile = _MockMelosFile();
      when(() => melosFile.exists()).thenReturn(true);
      platformDirectory = _MockPlatformDirectory();
      feature1 = _MockFeature();
      when(() => feature1.path).thenReturn(feature1Path);
      when(() => feature1.entityName).thenReturn(feature1Name);
      when(() => feature1.defaultLanguage()).thenReturn(defaultLanguage);
      when(() => feature1.supportedLanguages())
          .thenReturn({defaultLanguage, 'de'});
      when(() => feature1.supportsLanguage(defaultLanguage)).thenReturn(true);
      when(() => feature1.supportsLanguage('de')).thenReturn(true);
      when(() => feature1.supportsLanguage('fr')).thenReturn(false);
      feature2 = _MockFeature();
      when(() => feature2.path).thenReturn(feature2Path);
      when(() => feature2.entityName).thenReturn(feature2Name);
      when(() => feature2.defaultLanguage()).thenReturn(defaultLanguage);
      when(() => feature2.supportedLanguages())
          .thenReturn({'de', defaultLanguage});
      when(() => feature2.supportsLanguage('de')).thenReturn(true);
      when(() => feature2.supportsLanguage(defaultLanguage)).thenReturn(true);
      when(() => feature2.supportsLanguage('fr')).thenReturn(false);
      features = [feature1, feature2];
      when(() => platformDirectory.getFeatures(exclude: any(named: 'exclude')))
          .thenReturn(features);
      when(() => project.isActivated(Platform.windows)).thenReturn(true);
      when(() => project.melosFile).thenReturn(melosFile);
      when(() => project.platformDirectory(Platform.windows))
          .thenReturn(platformDirectory);

      flutterGenl10n = _MockFlutterGenl10nCommand();
      when(() => flutterGenl10n(cwd: any(named: 'cwd'), logger: logger))
          .thenAnswer((_) async {});

      flutterFormatFix = _MockFlutterFormatFixCommand();
      when(() => flutterFormatFix(cwd: any(named: 'cwd'), logger: logger))
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

      argResults = _MockArgResults();
      language = 'fr';
      when(() => argResults.rest).thenReturn([language]);

      command = WindowsAddLanguageCommand(
        logger: logger,
        project: project,
        flutterGenl10n: flutterGenl10n,
        flutterFormatFix: flutterFormatFix,
        generator: (_) async => generator,
      )..argResultOverrides = argResults;
    });

    tearDown(() {
      Directory.current = cwd;
    });

    test('lang is a valid alias', () {
      // Arrange
      command = WindowsAddLanguageCommand(project: project);

      // Act + Assert
      expect(command.aliases, contains('lang'));
    });

    test(
      'help',
      withRunner((commandRunner, logger, printLogs) async {
        // Act
        final result = await commandRunner.run(
          ['windows', 'add', 'language', '--help'],
        );

        // Assert
        expect(printLogs, equals(expectedUsage));
        expect(result, equals(ExitCode.success.code));

        printLogs.clear();

        // Act
        final resultAbbr = await commandRunner.run(
          ['windows', 'add', 'language', '-h'],
        );

        // Assert
        expect(printLogs, equals(expectedUsage));
        expect(resultAbbr, equals(ExitCode.success.code));
      }),
    );

    test('can be instantiated without explicit logger', () {
      // Act
      command = WindowsAddLanguageCommand(project: project);

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
        final result = await commandRunner.run(['windows', 'add', 'language']);

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
            await commandRunner.run(['windows', 'add', 'language', 'de', 'fr']);

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
            await commandRunner.run(['windows', 'add', 'language', language]);

        // Assert
        expect(result, equals(ExitCode.usage.code));
        verify(() => logger.err(expectedErrorMessage)).called(1);
      }),
    );

    test('completes successfully with correct output', () async {
      // Act
      final result = await command.run();

      // Assert
      verify(() => project.isActivated(Platform.windows)).called(1);
      verify(() => project.platformDirectory(Platform.windows)).called(1);
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
      verify(() => flutterGenl10n(cwd: feature1Path, logger: logger)).called(1);
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
      verify(() => flutterGenl10n(cwd: feature2Path, logger: logger)).called(1);
      verify(() => flutterFormatFix(logger: logger)).called(1);
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

    test('exits with 78 when no Windows features exist', () async {
      // Arrange
      features = [];
      when(() => platformDirectory.getFeatures(exclude: any(named: 'exclude')))
          .thenReturn(features);

      // Act
      final result = await command.run();

      // Assert
      verify(() => logger.err('No Windows features found!\n'
              'Run "rapid windows add feature" to add your first Windows feature.'))
          .called(1);
      expect(result, ExitCode.config.code);
    });

    test(
        'exits with 78 when some Windows features have different default languages',
        () async {
      // Arrange
      when(() => feature1.defaultLanguage()).thenReturn('de');
      features = [feature1, feature2];

      // Act
      final result = await command.run();

      // Assert
      verify(() => logger.err('The Windows part of your project is corrupted.\n'
          'Because not all features have the same default language.\n\n'
          'Run "rapid doctor" to see which features are affected.')).called(1);
      expect(result, ExitCode.config.code);
    });

    test('exits with 78 when some Windows features have different languages',
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
      verify(() => logger.err('The Windows part of your project is corrupted.\n'
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
      verify(() => project.isActivated(Platform.windows)).called(1);
      verify(() => project.platformDirectory(Platform.windows)).called(1);
      verify(() => platformDirectory.getFeatures(exclude: {'app', 'routing'}))
          .called(1);
      verify(() => logger.err('The language "de" is already present.'))
          .called(1);
      expect(result, ExitCode.config.code);
    });

    test('exits with 78 when Windows is not activated', () async {
      // Arrange
      when(() => project.isActivated(Platform.windows)).thenReturn(false);

      // Act
      final result = await command.run();

      // Assert
      verify(() => logger.err('Windows is not activated.')).called(1);
      expect(result, ExitCode.config.code);
    });
  });
}
