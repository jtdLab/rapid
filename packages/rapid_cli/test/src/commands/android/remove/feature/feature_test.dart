import 'package:args/args.dart';
import 'package:mason/mason.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rapid_cli/src/commands/android/remove/feature/feature.dart';
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
  'Removes a feature from the Android part of an existing Rapid project.\n'
      '\n'
      'Usage: rapid android remove feature <name>\n'
      '-h, --help    Print this usage information.\n'
      '\n'
      'Run "rapid help" to see global options.'
];

abstract class _MelosBoostrapCommand {
  Future<void> call({String cwd});
}

abstract class _MelosCleanCommand {
  Future<void> call({String cwd});
}

class _MockArgResults extends Mock implements ArgResults {}

class _MockProgress extends Mock implements Progress {}

class _MockLogger extends Mock implements Logger {}

class _MockMelosFile extends Mock implements MelosFile {}

class _MockFeature extends Mock implements Feature {}

class _MockPlatformDirectory extends Mock implements PlatformDirectory {}

class _MockProject extends Mock implements Project {}

class _MockMelosBootstrapCommand extends Mock implements _MelosBoostrapCommand {
}

class _MockMelosCleanCommand extends Mock implements _MelosCleanCommand {}

void main() {
  group('android remove feature', () {
    Directory cwd = Directory.current;

    late List<String> progressLogs;
    late Progress progress;
    late Logger logger;
    late MelosFile melosFile;
    late Feature feature;
    late PlatformDirectory platformDirectory;
    late Project project;
    late _MelosBoostrapCommand melosBootstrap;
    late _MelosCleanCommand melosClean;
    late String featureName;
    late ArgResults argResults;

    late AndroidRemoveFeatureCommand command;

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
      feature = _MockFeature();
      platformDirectory = _MockPlatformDirectory();
      when(() => platformDirectory.featureExists(any())).thenReturn(true);
      when(() => platformDirectory.findFeature(any())).thenReturn(feature);
      melosBootstrap = _MockMelosBootstrapCommand();
      when(() => melosBootstrap(cwd: any(named: 'cwd')))
          .thenAnswer((_) async {});
      melosClean = _MockMelosCleanCommand();
      when(() => melosClean(cwd: any(named: 'cwd'))).thenAnswer((_) async {});
      project = _MockProject();
      when(() => project.isActivated(Platform.android)).thenReturn(true);
      when(() => project.melosFile).thenReturn(melosFile);
      when(() => project.platformDirectory(Platform.android))
          .thenReturn(platformDirectory);
      featureName = 'my_cool_feature';
      argResults = _MockArgResults();
      when(() => argResults.rest).thenReturn([featureName]);

      command = AndroidRemoveFeatureCommand(
        logger: logger,
        project: project,
        melosBootstrap: melosBootstrap,
        melosClean: melosClean,
      )..argResultOverrides = argResults;
    });

    tearDown(() {
      Directory.current = cwd;
    });

    test('feat is a valid alias', () {
      // Arrange
      command = AndroidRemoveFeatureCommand(project: project);

      // Act + Assert
      expect(command.aliases, contains('feat'));
    });

    test(
      'help',
      withRunner((commandRunner, logger, printLogs) async {
        // Act
        final result = await commandRunner.run(
          ['android', 'remove', 'feature', '--help'],
        );

        // Assert
        expect(printLogs, equals(expectedUsage));
        expect(result, equals(ExitCode.success.code));

        printLogs.clear();

        // Act
        final resultAbbr = await commandRunner.run(
          ['android', 'remove', 'feature', '-h'],
        );

        // Assert
        expect(printLogs, equals(expectedUsage));
        expect(resultAbbr, equals(ExitCode.success.code));
      }),
    );

    test('can be instantiated without explicit logger', () {
      // Act
      command = AndroidRemoveFeatureCommand(project: project);

      // Assert
      expect(command, isNotNull);
    });

    test(
      'throws UsageException when name is missing',
      withRunnerOnProject(
          (commandRunner, logger, melosFile, project, printLogs) async {
        // Arrange
        const expectedErrorMessage = 'No option specified for the name.';

        // Act
        final result =
            await commandRunner.run(['android', 'remove', 'feature']);

        // Assert
        expect(result, equals(ExitCode.usage.code));
        verify(() => logger.err(expectedErrorMessage)).called(1);
      }),
    );

    test(
      'throws UsageException when multiple names are provided',
      withRunnerOnProject(
          (commandRunner, logger, melosFile, project, printLogs) async {
        // Arrange
        const expectedErrorMessage = 'Multiple names specified.';

        // Act
        final result = await commandRunner
            .run(['android', 'remove', 'feature', 'name1', 'name2']);

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
      verify(() => platformDirectory.featureExists(featureName)).called(1);
      verify(() => platformDirectory.findFeature(featureName)).called(1);
      verify(() => feature.delete()).called(1);
      verify(() => logger.progress('Running "melos clean" in . ')).called(1);
      verify(() => melosBootstrap()).called(1);
      verify(() => logger.progress('Running "melos bootstrap" in . '))
          .called(1);
      verify(() => melosClean()).called(1);
      verify(() => logger.success('Removed Android feature $featureName.'))
          .called(1);
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

    test('exits with 78 when the feature does not exist', () async {
      // Arrange
      when(() => platformDirectory.featureExists(any())).thenReturn(false);

      // Act
      final result = await command.run();

      // Assert
      verify(() => logger.err(
          'The feature "$featureName" does not exist on Android.')).called(1);
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
