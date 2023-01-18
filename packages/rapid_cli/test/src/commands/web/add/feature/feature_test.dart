import 'package:args/args.dart';
import 'package:mason/mason.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rapid_cli/src/cli/cli.dart';
import 'package:rapid_cli/src/commands/web/add/feature/feature.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/project/melos_file.dart';
import 'package:rapid_cli/src/project/project.dart';
import 'package:test/test.dart';
import 'package:universal_io/io.dart';

import '../../../../../helpers/helpers.dart';

const expectedUsage = [
  'Add a feature to the Web part of an existing Rapid project.\n'
      '\n'
      'Usage: rapid web add feature <name> [arguments]\n'
      '-h, --help       Print this usage information.\n'
      '\n'
      '\n'
      '    --desc       The description of this new feature.\n'
      '                 (defaults to "A Rapid feature.")\n'
      '    --routing    Wheter the new feature can be registered in the routing package.\n'
      '\n'
      'Run "rapid help" to see global options.'
];

abstract class _MelosBootstrapCommand {
  Future<void> call({String cwd, required Logger logger});
}

abstract class _MelosCleanCommand {
  Future<void> call({String cwd, required Logger logger});
}

abstract class _FlutterFormatFixCommand {
  Future<void> call({String cwd, required Logger logger});
}

class _MockLogger extends Mock implements Logger {}

class _MockProgress extends Mock implements Progress {}

class _MockProject extends Mock implements Project {}

class _MockMelosFile extends Mock implements MelosFile {}

class _MockMelosBootstrapCommand extends Mock
    implements _MelosBootstrapCommand {}

class _MockMelosCleanCommand extends Mock implements _MelosCleanCommand {}

class _MockFlutterFormatFixCommand extends Mock
    implements _FlutterFormatFixCommand {}

class _MockMasonGenerator extends Mock implements MasonGenerator {}

class _MockArgResults extends Mock implements ArgResults {}

class _FakeDirectoryGeneratorTarget extends Fake
    implements DirectoryGeneratorTarget {}

void main() {
  group('web add feature', () {
    Directory cwd = Directory.current;

    late Logger logger;
    late List<String> progressLogs;

    late Project project;
    late MelosFile melosFile;
    const projectName = 'test_app';

    late MelosBootstrapCommand melosBootstrap;

    late MelosCleanCommand melosClean;

    late FlutterFormatFixCommand flutterFormatFix;

    late MasonGenerator generator;
    final generatedFiles = List.filled(
      23,
      const GeneratedFile.created(path: ''),
    );

    late ArgResults argResults;
    late String featureName;

    late WebAddFeatureCommand command;

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
      when(() => melosFile.name()).thenReturn(projectName);
      when(() => project.melosFile).thenReturn(melosFile);
      when(() => project.isActivated(Platform.web)).thenReturn(true);

      melosBootstrap = _MockMelosBootstrapCommand();
      when(() => melosBootstrap(cwd: any(named: 'cwd'), logger: logger))
          .thenAnswer((_) async {});

      melosClean = _MockMelosCleanCommand();
      when(() => melosClean(cwd: any(named: 'cwd'), logger: logger))
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
      featureName = 'my_cool_feature';
      when(() => argResults.rest).thenReturn([featureName]);

      command = WebAddFeatureCommand(
        logger: logger,
        project: project,
        melosBootstrap: melosBootstrap,
        melosClean: melosClean,
        flutterFormatFix: flutterFormatFix,
        generator: (_) async => generator,
      )..argResultOverrides = argResults;
    });

    tearDown(() {
      Directory.current = cwd;
    });

    test('feat is a valid alias', () {
      // Arrange
      command = WebAddFeatureCommand(project: project);

      // Act + Assert
      expect(command.aliases, contains('feat'));
    });

    test(
      'help',
      withRunner((commandRunner, logger, printLogs) async {
        // Act
        final result = await commandRunner.run(
          ['web', 'add', 'feature', '--help'],
        );

        // Assert
        expect(printLogs, equals(expectedUsage));
        expect(result, equals(ExitCode.success.code));

        printLogs.clear();

        // Act
        final resultAbbr = await commandRunner.run(
          ['web', 'add', 'feature', '-h'],
        );

        // Assert
        expect(printLogs, equals(expectedUsage));
        expect(resultAbbr, equals(ExitCode.success.code));
      }),
    );

    test('can be instantiated without explicit logger', () {
      // Act
      command = WebAddFeatureCommand(project: project);

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
        final result = await commandRunner.run(['web', 'add', 'feature']);

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
            .run(['web', 'add', 'feature', 'name1', 'name2']);

        // Assert
        expect(result, equals(ExitCode.usage.code));
        verify(() => logger.err(expectedErrorMessage)).called(1);
      }),
    );

    // TODO more test cases for invalid patterns
    test(
      'throws UsageException when name is invalid',
      withRunnerOnProject(
          (commandRunner, logger, melosFile, project, printLogs) async {
        // Arrange
        featureName = 'My Feature';
        final expectedErrorMessage =
            '"$featureName" is not a valid package name.\n\n'
            'See https://dart.dev/tools/pub/pubspec#name for more information.';

        // Act
        final result = await commandRunner.run(
          ['web', 'add', 'feature', featureName],
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
      verify(() => project.isActivated(Platform.web)).called(1);
      verify(() => logger.progress('Generating files')).called(1);
      verify(
        () => generator.generate(
          any(
            that: isA<DirectoryGeneratorTarget>().having(
              (g) => g.dir.path,
              'dir',
              '.',
            ),
          ),
          vars: <String, dynamic>{
            'project_name': projectName,
            'name': featureName,
            'description': 'A Rapid feature.',
            'platform': 'web',
            'web': true
          },
          logger: logger,
        ),
      ).called(1);
      expect(
        progressLogs,
        equals(['Generated ${generatedFiles.length} file(s)']),
      );
      verify(() => logger.progress('Running "melos clean" in . ')).called(1);
      verify(() => melosClean(logger: logger)).called(1);
      verify(() => logger.progress('Running "melos bootstrap" in . '))
          .called(1);
      verify(() => melosBootstrap(logger: logger)).called(1);
      verify(() => flutterFormatFix(logger: logger)).called(1);
      verify(() => logger.success('Added Web feature $featureName.')).called(1);
      expect(result, ExitCode.success.code);
    });

    test('completes successfully with correct output w/ --desc', () async {
      // Arrange
      final description = 'My cool description.';
      when(() => argResults['desc']).thenReturn(description);

      // Act
      final result = await command.run();

      // Assert
      verify(() => project.isActivated(Platform.web)).called(1);
      verify(() => logger.progress('Generating files')).called(1);
      verify(
        () => generator.generate(
          any(
            that: isA<DirectoryGeneratorTarget>().having(
              (g) => g.dir.path,
              'dir',
              '.',
            ),
          ),
          vars: <String, dynamic>{
            'project_name': projectName,
            'name': featureName,
            'description': description,
            'platform': 'web',
            'web': true
          },
          logger: logger,
        ),
      ).called(1);
      expect(
        progressLogs,
        equals(['Generated ${generatedFiles.length} file(s)']),
      );
      verify(() => logger.progress('Running "melos clean" in . ')).called(1);
      verify(() => melosClean(logger: logger)).called(1);
      verify(() => logger.progress('Running "melos bootstrap" in . '))
          .called(1);
      verify(() => melosBootstrap(logger: logger)).called(1);
      verify(() => flutterFormatFix(logger: logger)).called(1);
      verify(() => logger.success('Added Web feature $featureName.')).called(1);
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

    test('exits with 78 when Web is not activated', () async {
      // Arrange
      when(() => project.isActivated(Platform.web)).thenReturn(false);

      // Act
      final result = await command.run();

      // Assert
      verify(() => logger.err('Web is not activated.')).called(1);
      expect(result, ExitCode.config.code);
    });
  });
}
