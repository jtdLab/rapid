import 'dart:io';

import 'package:args/args.dart';
import 'package:mason/mason.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rapid_cli/src/commands/windows/set/default_language/default_language.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/project/project.dart';
import 'package:test/test.dart';

import '../../../../common.dart';
import '../../../../mocks.dart';

const expectedUsage = [
  'Set the default language of the Windows part of an existing Rapid project.\n'
      '\n'
      'Usage: rapid windows set default_language <language>\n'
      '-h, --help    Print this usage information.\n'
      '\n'
      'Run "rapid help" to see global options.'
];

void main() {
  group('windows set default_language', () {
    Directory cwd = Directory.current;

    late Logger logger;

    late Project project;

    late ArgResults argResults;
    late String language;

    late WindowsSetDefaultLanguageCommand command;

    setUp(() {
      Directory.current = Directory.systemTemp.createTempSync();

      logger = MockLogger();

      project = MockProject();
      when(
        () => project.setDefaultLanguage(
          any(),
          platform: Platform.windows,
          logger: logger,
        ),
      ).thenAnswer((_) async {});
      when(() => project.existsAll()).thenReturn(true);
      when(() => project.platformIsActivated(Platform.windows))
          .thenReturn(true);

      argResults = MockArgResults();
      language = 'de';
      when(() => argResults.rest).thenReturn([language]);

      command = WindowsSetDefaultLanguageCommand(
        logger: logger,
        project: project,
      )..argResultOverrides = argResults;
    });

    tearDown(() {
      Directory.current = cwd;
    });

    test('default_lang is a valid alias', () {
      // Arrange
      command = WindowsSetDefaultLanguageCommand(project: project);

      // Act + Assert
      expect(command.aliases, contains('default_lang'));
    });

    test(
      'help',
      withRunner((commandRunner, logger, printLogs) async {
        // Act
        final result = await commandRunner.run(
          ['windows', 'set', 'default_language', '--help'],
        );

        // Assert
        expect(printLogs, equals(expectedUsage));
        expect(result, equals(ExitCode.success.code));

        printLogs.clear();

        // Act
        final resultAbbr = await commandRunner.run(
          ['windows', 'set', 'default_language', '-h'],
        );

        // Assert
        expect(printLogs, equals(expectedUsage));
        expect(resultAbbr, equals(ExitCode.success.code));
      }),
    );

    test('can be instantiated without explicit logger', () {
      // Act
      command = WindowsSetDefaultLanguageCommand(project: project);
      // Assert
      expect(command, isNotNull);
    });

    test(
      'throws UsageException when language is missing',
      withRunnerOnProject(
          (commandRunner, logger, melosFile, project, printLogs) async {
        // Arrange
        const expectedErrorMessage = 'No option specified for the language.';

        // Act
        final result =
            await commandRunner.run(['windows', 'set', 'default_language']);

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
        final result = await commandRunner
            .run(['windows', 'set', 'default_language', 'de', 'fr']);

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
        const language = 'hello';
        const expectedErrorMessage = '"$language" is not a valid language.\n\n'
            'See https://www.iana.org/assignments/language-subtag-registry/language-subtag-registry for more information.';

        // Act
        final result = await commandRunner
            .run(['windows', 'set', 'default_language', language]);

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
      verify(() => logger.info('Setting default language ...')).called(1);
      verify(
        () => project.setDefaultLanguage(
          language,
          platform: Platform.windows,
          logger: logger,
        ),
      ).called(1);
      verify(
        () => logger.success(
          'Set $language as the default language of the Windows part of your project.',
        ),
      ).called(1);
      verify(() => logger.info('')).called(1);
      expect(result, ExitCode.success.code);
    });

    test('exits with 78 when no Windows features exist', () async {
      // Arrange
      when(
        () => project.setDefaultLanguage(
          any(),
          platform: Platform.windows,
          logger: logger,
        ),
      ).thenThrow(NoFeaturesFound());

      // Act
      final result = await command.run();

      // Assert
      verify(
        () => logger.err(
          'No Windows features found!\n'
          'Run "rapid windows add feature" to add your first Windows feature.',
        ),
      ).called(1);
      verify(() => logger.info('')).called(1);
      expect(result, ExitCode.config.code);
    });

    test(
        'exits with 78 when some Windows features have different default languages',
        () async {
      // Arrange
      when(
        () => project.setDefaultLanguage(
          any(),
          platform: Platform.windows,
          logger: logger,
        ),
      ).thenThrow(FeaturesHaveDiffrentDefaultLanguage());

      // Act
      final result = await command.run();

      // Assert
      verify(
        () => logger.err(
          'The Windows part of your project is corrupted.\n'
          'Because not all features have the same default language.\n\n'
          'Run "rapid doctor" to see which features are affected.',
        ),
      ).called(1);
      verify(() => logger.info('')).called(1);
      expect(result, ExitCode.config.code);
    });

    test('exits with 78 when some Windows features have different languages',
        () async {
      // Arrange
      when(
        () => project.setDefaultLanguage(
          any(),
          platform: Platform.windows,
          logger: logger,
        ),
      ).thenThrow(FeaturesHaveDiffrentLanguages());

      // Act
      final result = await command.run();

      // Assert
      verify(
        () => logger.err(
          'The Windows part of your project is corrupted.\n'
          'Because not all features support the same languages.\n\n'
          'Run "rapid doctor" to see which features are affected.',
        ),
      ).called(1);
      verify(() => logger.info('')).called(1);
      expect(result, ExitCode.config.code);
    });

    test('exits with 78 when language is the default language of all features',
        () async {
      // Arrange
      when(
        () => project.setDefaultLanguage(
          any(),
          platform: Platform.windows,
          logger: logger,
        ),
      ).thenThrow(DefaultLanguageAlreadySetToRequestedLanguage());

      // Act
      final result = await command.run();

      // Assert
      verify(
        () => logger.err(
          'The language "$language" already is the default language.',
        ),
      ).called(1);
      verify(() => logger.info('')).called(1);
      expect(result, ExitCode.config.code);
    });

    test('exits with 78 when language is not present in all features',
        () async {
      // Arrange
      when(
        () => project.setDefaultLanguage(
          any(),
          platform: Platform.windows,
          logger: logger,
        ),
      ).thenThrow(FeaturesDoNotSupportLanguage());

      // Act
      final result = await command.run();

      // Assert
      verify(
        () => logger.err('The language "$language" is not present.'),
      ).called(1);
      verify(() => logger.info('')).called(1);
      expect(result, ExitCode.config.code);
    });

    test('exits with 78 when Windows is not activated', () async {
      // Arrange
      when(() => project.platformIsActivated(Platform.windows))
          .thenReturn(false);

      // Act
      final result = await command.run();

      // Assert
      verify(() => logger.err('Windows is not activated.')).called(1);
      verify(() => logger.info('')).called(1);
      expect(result, ExitCode.config.code);
    });

    test('exits with 66 when project does not exist', () async {
      // Arrange
      when(() => project.existsAll()).thenReturn(false);

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
