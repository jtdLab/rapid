import 'package:args/args.dart';
import 'package:mason/mason.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rapid_cli/src/commands/android/add/feature/feature.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/project/melos_file.dart';
import 'package:rapid_cli/src/project/project.dart';
import 'package:test/test.dart';
import 'package:universal_io/io.dart';

import '../../../../../helpers/helpers.dart';

const expectedUsage = [
  // ignore: no_adjacent_strings_in_list
  'Adds a feature to the Android part of an existing Rapid project.\n'
      '\n'
      'Usage: rapid android add feature <name> [arguments]\n'
      '-h, --help    Print this usage information.\n'
      '\n'
      '\n'
      '    --desc    The description of this new feature.\n'
      '              (defaults to "A Rapid feature.")\n'
      '\n'
      'Run "rapid help" to see global options.'
];

abstract class MelosBoostrapCommand {
  Future<void> call({String cwd});
}

abstract class MelosCleanCommand {
  Future<void> call({String cwd});
}

class MockArgResults extends Mock implements ArgResults {}

class MockProgress extends Mock implements Progress {}

class MockLogger extends Mock implements Logger {}

class MockMelosFile extends Mock implements MelosFile {}

class MockProject extends Mock implements Project {}

class MockMelosBootstrapCommand extends Mock implements MelosBoostrapCommand {}

class MockMelosCleanCommand extends Mock implements MelosCleanCommand {}

class MockMasonGenerator extends Mock implements MasonGenerator {}

class FakeDirectoryGeneratorTarget extends Fake
    implements DirectoryGeneratorTarget {}

void main() {
  Directory cwd = Directory.current;

  late List<String> progressLogs;
  late Progress progress;
  late Logger logger;
  const projectName = 'test_app';
  late MelosFile melosFile;
  late Project project;
  late MelosBoostrapCommand melosBootstrap;
  late MelosCleanCommand melosClean;
  final generatedFiles = List.filled(
    62,
    const GeneratedFile.created(path: ''),
  );
  late MasonGenerator generator;
  late String featureName;
  late ArgResults argResults;

  late FeatureCommand command;

  setUpAll(() {
    registerFallbackValue(FakeDirectoryGeneratorTarget());
  });

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
    when(() => melosFile.name()).thenReturn(projectName);
    project = MockProject();
    when(() => project.melosFile).thenReturn(melosFile);
    when(() => project.isActivated(Platform.android)).thenReturn(true);
    melosBootstrap = MockMelosBootstrapCommand();
    when(() => melosBootstrap(cwd: any(named: 'cwd'))).thenAnswer((_) async {});
    melosClean = MockMelosCleanCommand();
    when(() => melosClean(cwd: any(named: 'cwd'))).thenAnswer((_) async {});
    generator = MockMasonGenerator();
    when(() => generator.id).thenReturn('generator_id');
    when(() => generator.description).thenReturn('generator description');
    when(
      () => generator.generate(
        any(),
        vars: any(named: 'vars'),
        logger: any(named: 'logger'),
      ),
    ).thenAnswer((_) async => generatedFiles);
    featureName = 'my_cool_feature';
    argResults = MockArgResults();
    when(() => argResults.rest).thenReturn([featureName]);

    command = FeatureCommand(
      logger: logger,
      project: project,
      generator: (_) async => generator,
      melosBootstrap: melosBootstrap,
      melosClean: melosClean,
    )..argResultOverrides = argResults;
  });

  tearDown(() {
    Directory.current = cwd;
  });

  test('feat is a valid alias', () {
    // Arrange
    command = FeatureCommand(project: project);

    // Act + Assert
    expect(command.aliases, contains('feat'));
  });

  test(
    'help',
    withRunner((commandRunner, logger, printLogs) async {
      // Act
      final result = await commandRunner.run(
        ['android', 'add', 'feature', '--help'],
      );

      // Assert
      expect(printLogs, equals(expectedUsage));
      expect(result, equals(ExitCode.success.code));

      printLogs.clear();

      // Act
      final resultAbbr = await commandRunner.run(
        ['android', 'add', 'feature', '-h'],
      );

      // Assert
      expect(printLogs, equals(expectedUsage));
      expect(resultAbbr, equals(ExitCode.success.code));
    }),
  );

  test('can be instantiated without explicit logger', () {
    // Act
    command = FeatureCommand(project: project);

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
      final result = await commandRunner.run(['android', 'add', 'feature']);

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
          .run(['android', 'add', 'feature', 'name1', 'name2']);

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
        ['android', 'add', 'feature', featureName],
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
    verify(() => project.isActivated(Platform.android)).called(1);
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
          'platform': 'android',
          'android': true
        },
        logger: logger,
      ),
    ).called(1);
    expect(
      progressLogs,
      equals(['Generated ${generatedFiles.length} file(s)']),
    );
    verify(() => logger.progress('Running "melos clean" in . ')).called(1);
    verify(() => melosClean()).called(1);
    verify(() => logger.progress('Running "melos bootstrap" in . ')).called(1);
    verify(() => melosBootstrap()).called(1);
    verify(() => logger.success('Added Android feature $featureName.'))
        .called(1);
    expect(result, ExitCode.success.code);
  });

  test('completes successfully with correct output w/ --desc', () async {
    // Arrange
    final description = 'My cool description.';
    when(() => argResults['desc']).thenReturn(description);

    // Act
    final result = await command.run();

    // Assert
    verify(() => project.isActivated(Platform.android)).called(1);
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
          'platform': 'android',
          'android': true
        },
        logger: logger,
      ),
    ).called(1);
    expect(
      progressLogs,
      equals(['Generated ${generatedFiles.length} file(s)']),
    );
    verify(() => logger.progress('Running "melos clean" in . ')).called(1);
    verify(() => melosClean()).called(1);
    verify(() => logger.progress('Running "melos bootstrap" in . ')).called(1);
    verify(() => melosBootstrap()).called(1);
    verify(() => logger.success('Added Android feature $featureName.'))
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