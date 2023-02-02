import 'package:args/args.dart';
import 'package:mason/mason.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rapid_cli/src/commands/web/add/language/language.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/project/project.dart';
import 'package:test/test.dart';
import 'package:universal_io/io.dart';

import '../../../../../helpers/helpers.dart';

const expectedUsage = [
  'Add a language to the Web part of an existing Rapid project.\n'
      '\n'
      'Usage: rapid web add language <language>\n'
      '-h, --help    Print this usage information.\n'
      '\n'
      'Run "rapid help" to see global options.'
];

class _MockLogger extends Mock implements Logger {}

class _MockProject extends Mock implements Project {}

class _MockArgResults extends Mock implements ArgResults {}

void main() {
  group('web add language', () {
    Directory cwd = Directory.current;

    late Logger logger;

    late Project project;

    late ArgResults argResults;
    late String language;

    late WebAddLanguageCommand command;

    setUp(() {
      Directory.current = Directory.systemTemp.createTempSync();

      logger = _MockLogger();

      project = _MockProject();
      when(
        () => project.addLanguage(
          any(),
          platform: Platform.web,
          logger: logger,
        ),
      ).thenAnswer((_) async {});
      when(() => project.exists()).thenReturn(true);
      when(() => project.platformIsActivated(Platform.web)).thenReturn(true);

      argResults = _MockArgResults();
      language = 'fr';
      when(() => argResults.rest).thenReturn([language]);

      command = WebAddLanguageCommand(
        logger: logger,
        project: project,
      )..argResultOverrides = argResults;
    });

    tearDown(() {
      Directory.current = cwd;
    });

    test('lang is a valid alias', () {
      // Arrange
      command = WebAddLanguageCommand(project: project);

      // Act + Assert
      expect(command.aliases, contains('lang'));
    });

    test(
      'help',
      withRunner((commandRunner, logger, printLogs) async {
        // Act
        final result = await commandRunner.run(
          ['web', 'add', 'language', '--help'],
        );

        // Assert
        expect(printLogs, equals(expectedUsage));
        expect(result, equals(ExitCode.success.code));

        printLogs.clear();

        // Act
        final resultAbbr = await commandRunner.run(
          ['web', 'add', 'language', '-h'],
        );

        // Assert
        expect(printLogs, equals(expectedUsage));
        expect(resultAbbr, equals(ExitCode.success.code));
      }),
    );

    test('can be instantiated without explicit logger', () {
      // Act
      command = WebAddLanguageCommand(project: project);

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
        final result = await commandRunner.run(['web', 'add', 'language']);

        // Assert
        expect(result, equals(ExitCode.usage.code));
        verify(() => logger.err(expectedErrorMessage)).called(1);
        verify(() => logger.info('')).called(1);
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
            await commandRunner.run(['web', 'add', 'language', 'de', 'fr']);

        // Assert
        expect(result, equals(ExitCode.usage.code));
        verify(() => logger.err(expectedErrorMessage)).called(1);
        verify(() => logger.info('')).called(1);
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
            await commandRunner.run(['web', 'add', 'language', language]);

        // Assert
        expect(result, equals(ExitCode.usage.code));
        verify(() => logger.err(expectedErrorMessage)).called(1);
        verify(() => logger.info('')).called(1);
      }),
    );

    test('completes successfully with correct output', () async {
      // Act
      final result = await command.run();

      // Assert
      verify(() => logger.info('Adding Language ...')).called(1);
      verify(
        () => project.addLanguage(
          language,
          platform: Platform.web,
          logger: logger,
        ),
      ).called(1);
      verify(
        () => logger.success(
          'Added $language to the Web part of your project.',
        ),
      ).called(1);
      verify(() => logger.info('')).called(1);
      expect(result, ExitCode.success.code);
    });

    test('exits with 78 when no Web features exist', () async {
      // Arrange
      when(
        () => project.addLanguage(
          any(),
          platform: Platform.web,
          logger: logger,
        ),
      ).thenThrow(NoFeaturesFound());

      // Act
      final result = await command.run();

      // Assert
      verify(
        () => logger.err(
          'No Web features found!\n'
          'Run "rapid web add feature" to add your first Web feature.',
        ),
      ).called(1);
      verify(() => logger.info('')).called(1);
      expect(result, ExitCode.config.code);
    });

    test(
        'exits with 78 when some Web features have different default languages',
        () async {
      // Arrange
      when(
        () => project.addLanguage(
          any(),
          platform: Platform.web,
          logger: logger,
        ),
      ).thenThrow(FeaturesHaveDiffrentDefaultLanguage());

      // Act
      final result = await command.run();

      // Assert
      verify(
        () => logger.err(
          'The Web part of your project is corrupted.\n'
          'Because not all features have the same default language.\n\n'
          'Run "rapid doctor" to see which features are affected.',
        ),
      ).called(1);
      verify(() => logger.info('')).called(1);
      expect(result, ExitCode.config.code);
    });

    test('exits with 78 when some Web features have different languages',
        () async {
      // Arrange
      when(
        () => project.addLanguage(
          any(),
          platform: Platform.web,
          logger: logger,
        ),
      ).thenThrow(FeaturesHaveDiffrentLanguages());

      // Act
      final result = await command.run();

      // Assert
      verify(
        () => logger.err(
          'The Web part of your project is corrupted.\n'
          'Because not all features support the same languages.\n\n'
          'Run "rapid doctor" to see which features are affected.',
        ),
      ).called(1);
      verify(() => logger.info('')).called(1);
      expect(result, ExitCode.config.code);
    });

    test('exits with 78 when language is already present in all features',
        () async {
      // Arrange
      when(
        () => project.addLanguage(
          any(),
          platform: Platform.web,
          logger: logger,
        ),
      ).thenThrow(FeaturesAlreadySupportLanguage());

      // Act
      final result = await command.run();

      // Assert
      verify(
        () => logger.err('The language "fr" is already present.'),
      ).called(1);
      verify(() => logger.info('')).called(1);
      expect(result, ExitCode.config.code);
    });

    test('exits with 78 when Web is not activated', () async {
      // Arrange
      when(() => project.platformIsActivated(Platform.web)).thenReturn(false);

      // Act
      final result = await command.run();

      // Assert
      verify(() => logger.err('Web is not activated.')).called(1);
      verify(() => logger.info('')).called(1);
      expect(result, ExitCode.config.code);
    });

    test('exits with 66 when project does not exist', () async {
      // Arrange
      when(() => project.exists()).thenReturn(false);

      // Act
      final result = await command.run();

      // Assert
      verify(
        () => logger.err(
          'This command should be run from the root of an existing Rapid project.',
        ),
      ).called(1);
      verify(() => logger.info('')).called(1);
      expect(result, ExitCode.noInput.code);
    });
  });
}
