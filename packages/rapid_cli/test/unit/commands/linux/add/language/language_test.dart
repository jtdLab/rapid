import 'package:args/args.dart';
import 'package:mason/mason.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rapid_cli/src/cli/cli.dart';
import 'package:rapid_cli/src/commands/linux/add/language/language.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/project/project.dart';
import 'package:test/test.dart';
import 'dart:io';

import '../../../../common.dart';
import '../../../../mocks.dart';

const expectedUsage = [
  'Add a language to the Linux part of an existing Rapid project.\n'
      '\n'
      'Usage: rapid linux add language <language>\n'
      '-h, --help    Print this usage information.\n'
      '\n'
      'Run "rapid help" to see global options.'
];

void main() {
  group('linux add language', () {
    Directory cwd = Directory.current;

    late Logger logger;

    late Project project;

    late FlutterGenl10nCommand flutterGenl10n;

    late DartFormatFixCommand dartFormatFix;

    late ArgResults argResults;
    late String language;

    late LinuxAddLanguageCommand command;

    setUp(() {
      Directory.current = Directory.systemTemp.createTempSync();

      logger = MockLogger();

      project = MockProject();
      when(
        () => project.addLanguage(
          any(),
          platform: Platform.linux,
          logger: logger,
        ),
      ).thenAnswer((_) async {});
      when(() => project.existsAll()).thenReturn(true);
      when(() => project.platformIsActivated(Platform.linux)).thenReturn(true);

      argResults = MockArgResults();
      language = 'fr';
      when(() => argResults.rest).thenReturn([language]);

      command = LinuxAddLanguageCommand(
        logger: logger,
        project: project,
        flutterGenl10n: flutterGenl10n,
        dartFormatFix: dartFormatFix,
      )..argResultOverrides = argResults;
    });

    tearDown(() {
      Directory.current = cwd;
    });

    test('lang is a valid alias', () {
      // Arrange
      command = LinuxAddLanguageCommand(project: project);

      // Act + Assert
      expect(command.aliases, contains('lang'));
    });

    test(
      'help',
      withRunner((commandRunner, logger, printLogs) async {
        // Act
        final result = await commandRunner.run(
          ['linux', 'add', 'language', '--help'],
        );

        // Assert
        expect(printLogs, equals(expectedUsage));
        expect(result, equals(ExitCode.success.code));

        printLogs.clear();

        // Act
        final resultAbbr = await commandRunner.run(
          ['linux', 'add', 'language', '-h'],
        );

        // Assert
        expect(printLogs, equals(expectedUsage));
        expect(resultAbbr, equals(ExitCode.success.code));
      }),
    );

    test('can be instantiated without explicit logger', () {
      // Act
      command = LinuxAddLanguageCommand(project: project);

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
        final result = await commandRunner.run(['linux', 'add', 'language']);

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
            await commandRunner.run(['linux', 'add', 'language', 'de', 'fr']);

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
            await commandRunner.run(['linux', 'add', 'language', language]);

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
          platform: Platform.linux,
          logger: logger,
        ),
      ).called(1);
      verify(
        () => logger.success(
          'Added $language to the Linux part of your project.',
        ),
      ).called(1);
      verify(() => logger.info('')).called(1);
      expect(result, ExitCode.success.code);
    });

    test('exits with 78 when no Linux features exist', () async {
      // Arrange
      when(
        () => project.addLanguage(
          any(),
          platform: Platform.linux,
          logger: logger,
        ),
      ).thenThrow(NoFeaturesFound());

      // Act
      final result = await command.run();

      // Assert
      verify(
        () => logger.err(
          'No Linux features found!\n'
          'Run "rapid linux add feature" to add your first Linux feature.',
        ),
      ).called(1);
      verify(() => logger.info('')).called(1);
      expect(result, ExitCode.config.code);
    });

    test(
        'exits with 78 when some Linux features have different default languages',
        () async {
      // Arrange
      when(
        () => project.addLanguage(
          any(),
          platform: Platform.linux,
          logger: logger,
        ),
      ).thenThrow(FeaturesHaveDiffrentDefaultLanguage());

      // Act
      final result = await command.run();

      // Assert
      verify(
        () => logger.err(
          'The Linux part of your project is corrupted.\n'
          'Because not all features have the same default language.\n\n'
          'Run "rapid doctor" to see which features are affected.',
        ),
      ).called(1);
      verify(() => logger.info('')).called(1);
      expect(result, ExitCode.config.code);
    });

    test('exits with 78 when some Linux features have different languages',
        () async {
      // Arrange
      when(
        () => project.addLanguage(
          any(),
          platform: Platform.linux,
          logger: logger,
        ),
      ).thenThrow(FeaturesSupportDiffrentLanguages());

      // Act
      final result = await command.run();

      // Assert
      verify(
        () => logger.err(
          'The Linux part of your project is corrupted.\n'
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
          platform: Platform.linux,
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

    test('exits with 78 when Linux is not activated', () async {
      // Arrange
      when(() => project.platformIsActivated(Platform.linux)).thenReturn(false);

      // Act
      final result = await command.run();

      // Assert
      verify(() => logger.err('Linux is not activated.')).called(1);
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
