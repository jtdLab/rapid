import 'package:args/args.dart';
import 'package:mason/mason.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rapid_cli/src/cli/cli.dart';
import 'package:rapid_cli/src/commands/activate/web/web.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/project/project.dart';
import 'package:test/test.dart';
import 'dart:io';

import '../../../common.dart';
import '../../../mocks.dart';

const expectedUsage = [
  'Adds support for Web to this project.\n'
      '\n'
      'Usage: rapid activate web\n'
      '-h, --help        Print this usage information.\n'
      '    --desc        The description for the native Web project.\n'
      '                  (defaults to "A Rapid app.")\n'
      '    --language    The default language for Web\n'
      '                  (defaults to "en")\n'
      '\n'
      'Run "rapid help" to see global options.'
];

void main() {
  group('activate web', () {
    final cwd = Directory.current;

    late Logger logger;

    late Project project;

    final MelosBootstrapCommand melosBootstrap;

    final FlutterPubGetCommand flutterPubGet;

    final FlutterPubRunBuildRunnerBuildDeleteConflictingOutputsCommand
        flutterPubRunBuildRunnerBuildDeleteConflictingOutputs;

    final FlutterGenl10nCommand flutterGenl10n;

    final DartFormatFixCommand dartFormatFix;

    late FlutterConfigEnablePlatformCommand flutterConfigEnableWeb;

    late ArgResults argResults;
    late String? desc;
    late String language;

    late ActivateWebCommand command;

    setUp(() {
      Directory.current = Directory.systemTemp.createTempSync();

      logger = MockLogger();

      project = MockProject();
      when(
        () => project.addPlatform(
          Platform.web,
          description: any(named: 'description'),
          orgName: any(named: 'orgName'),
          language: any(named: 'language'),
          logger: logger,
        ),
      ).thenAnswer((_) async {});
      when(() => project.existsAll()).thenReturn(true);
      when(() => project.platformIsActivated(Platform.web)).thenReturn(false);

      flutterConfigEnableWeb = MockFlutterConfigEnablePlatformCommand();
      when(() => flutterConfigEnableWeb(logger: logger))
          .thenAnswer((_) async {});

      argResults = MockArgResults();
      language = 'de';
      when(() => argResults['language']).thenReturn(language);

      command = ActivateWebCommand(
        logger: logger,
        project: project,
        melosBootstrap: melosBootstrap,
        flutterPubGet: flutterPubGet,
        flutterPubRunBuildRunnerBuildDeleteConflictingOutputs:
            flutterPubRunBuildRunnerBuildDeleteConflictingOutputs,
        flutterGenl10n: flutterGenl10n,
        dartFormatFix: dartFormatFix,
        flutterConfigEnableWeb: flutterConfigEnableWeb,
      )..argResultOverrides = argResults;
    });

    tearDown(() {
      Directory.current = cwd;
    });

    test(
      'help',
      withRunner((commandRunner, logger, printLogs) async {
        // Act
        final result = await commandRunner.run(['activate', 'web', '--help']);

        // Assert
        expect(printLogs, equals(expectedUsage));
        expect(result, equals(ExitCode.success.code));

        printLogs.clear();

        // Act
        final resultAbbr = await commandRunner.run(['activate', 'web', '-h']);

        // Assert
        expect(printLogs, equals(expectedUsage));
        expect(resultAbbr, equals(ExitCode.success.code));
      }),
    );

    test('can be instantiated without explicit logger and project', () {
      // Act
      final command = ActivateWebCommand();

      // Assert
      expect(command, isNotNull);
    });

    test(
      'throws UsageException when language is invalid',
      withRunnerOnProject((commandRunner, logger, _, project, printLogs) async {
        // Arrange
        when(() => project.platformIsActivated(Platform.web)).thenReturn(false);
        const language = 'xxyyzz';
        const expectedErrorMessage = '"$language" is not a valid language.\n\n'
            'See https://www.iana.org/assignments/language-subtag-registry/language-subtag-registry for more information.';

        // Act
        final result = await commandRunner.run(
          ['activate', 'web', '--language', language],
        );

        // Assert
        expect(result, equals(ExitCode.usage.code));
        verify(() => logger.err(expectedErrorMessage)).called(1);
      }),
    );

    test('completes successfully with correct output', () async {
      // Act
      final result = await command.run();

      // Assert
      verifyNever(() => logger.err('Web is already activated.'));
      verify(() => logger.info('Activating Web ...')).called(1);
      verify(() => flutterConfigEnableWeb(logger: logger)).called(1);
      verify(
        () => project.addPlatform(
          Platform.web,
          description: 'A Rapid app.',
          language: language,
          logger: logger,
        ),
      ).called(1);
      verify(() => logger.success('Web activated!')).called(1);
      verify(() => logger.info('')).called(1);
      expect(result, ExitCode.success.code);
    });

    test('completes successfully with correct output w/ custom desc', () async {
      // Arrange
      desc = 'My description.';
      when(() => argResults['desc']).thenReturn(desc);

      // Act
      final result = await command.run();

      // Assert
      verifyNever(() => logger.err('Web is already activated.'));
      verify(() => logger.info('Activating Web ...')).called(1);
      verify(() => flutterConfigEnableWeb(logger: logger)).called(1);
      verify(
        () => project.addPlatform(
          Platform.web,
          description: desc,
          language: language,
          logger: logger,
        ),
      ).called(1);
      verify(() => logger.success('Web activated!')).called(1);
      verify(() => logger.info('')).called(1);
      expect(result, ExitCode.success.code);
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

    test('exits with 78 when Web is already activated', () async {
      // Arrange
      when(() => project.platformIsActivated(Platform.web)).thenReturn(true);

      // Act
      final result = await command.run();

      // Assert
      verify(() => logger.err('Web is already activated.')).called(1);
      verify(() => logger.info('')).called(1);
      expect(result, ExitCode.config.code);
    });
  });
}
