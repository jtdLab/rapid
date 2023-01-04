import 'package:args/args.dart';
import 'package:mason/mason.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rapid_cli/src/commands/android/feature/add/bloc/bloc.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/project/feature.dart';
import 'package:rapid_cli/src/project/melos_file.dart';
import 'package:rapid_cli/src/project/platform_directory.dart';
import 'package:rapid_cli/src/project/project.dart';
import 'package:recase/recase.dart';
import 'package:test/test.dart';
import 'package:universal_io/io.dart';

import '../../../../../../helpers/helpers.dart';

const expectedUsage = [
  // ignore: no_adjacent_strings_in_list
  'Adds a bloc to a feature of the Android part of an existing Rapid project.\n'
      '\n'
      'Usage: rapid android feature add bloc <name> [arguments]\n'
      '-h, --help            Print this usage information.\n'
      '\n'
      '\n'
      '    --feature-name    The name of the feature this new bloc will be added to.\n'
      '                      This must be the name of an existing Android feature.\n'
      '\n'
      'Run "rapid help" to see global options.'
];

abstract class FlutterPubRunBuildRunnerBuildDeleteConflictingOutputsCommand {
  Future<void> call({String cwd});
}

class MockArgResults extends Mock implements ArgResults {}

class MockProgress extends Mock implements Progress {}

class MockLogger extends Mock implements Logger {}

class MockMelosFile extends Mock implements MelosFile {}

class MockFeature extends Mock implements Feature {}

class MockPlatformDirectory extends Mock implements PlatformDirectory {}

class MockProject extends Mock implements Project {}

class MockFlutterPubRunBuildRunnerBuildDeleteConflictingOutputsCommand
    extends Mock
    implements FlutterPubRunBuildRunnerBuildDeleteConflictingOutputsCommand {}

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
  const featurePackagePath = 'foo/bar/baz';
  late Feature feature;
  late PlatformDirectory platformDirectory;
  late Project project;
  late FlutterPubRunBuildRunnerBuildDeleteConflictingOutputsCommand
      flutterPubRunBuildRunnerBuildDeleteConflictingOutputs;
  final generatedFiles = List.filled(
    62,
    const GeneratedFile.created(path: ''),
  );
  late MasonGenerator generator;
  late String blocName;
  late String featureName;
  late ArgResults argResults;

  late BlocCommand command;

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
    feature = MockFeature();
    when(() => feature.path).thenReturn(featurePackagePath);
    platformDirectory = MockPlatformDirectory();
    when(() => platformDirectory.featureExists(any())).thenReturn(true);
    when(() => platformDirectory.findFeature(any())).thenReturn(feature);
    project = MockProject();
    when(() => project.platformDirectory(Platform.android))
        .thenReturn(platformDirectory);
    when(() => project.melosFile).thenReturn(melosFile);
    when(() => project.isActivated(Platform.android)).thenReturn(true);
    flutterPubRunBuildRunnerBuildDeleteConflictingOutputs =
        MockFlutterPubRunBuildRunnerBuildDeleteConflictingOutputsCommand();
    when(() => flutterPubRunBuildRunnerBuildDeleteConflictingOutputs(
        cwd: any(named: 'cwd'))).thenAnswer((_) async {});
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
    blocName = 'FooBar';
    featureName = 'my_cool_feature';
    argResults = MockArgResults();
    when(() => argResults['feature-name']).thenReturn(featureName);
    when(() => argResults.rest).thenReturn([blocName]);

    command = BlocCommand(
      logger: logger,
      project: project,
      flutterPubRunBuildRunnerBuildDeleteConflictingOutputs:
          flutterPubRunBuildRunnerBuildDeleteConflictingOutputs,
      generator: (_) async => generator,
    )..argResultOverrides = argResults;
  });

  tearDown(() {
    Directory.current = cwd;
  });

  test(
    'help',
    withRunner((commandRunner, logger, printLogs) async {
      // Act
      final result = await commandRunner.run(
        ['android', 'feature', 'add', 'bloc', '--help'],
      );

      // Assert
      expect(printLogs, equals(expectedUsage));
      expect(result, equals(ExitCode.success.code));

      printLogs.clear();

      // Act
      final resultAbbr = await commandRunner.run(
        ['android', 'feature', 'add', 'bloc', '-h'],
      );

      // Assert
      expect(printLogs, equals(expectedUsage));
      expect(resultAbbr, equals(ExitCode.success.code));
    }),
  );

  test('can be instantiated without explicit logger', () {
    // Act
    command = BlocCommand(project: project);

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
      final result = await commandRunner.run(
          ['android', 'feature', 'add', 'bloc', '--feature-name', 'some_feat']);

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
      final result = await commandRunner.run([
        'android',
        'feature',
        'add',
        'bloc',
        'name1',
        'name2',
        '--feature-name',
        'some_feat'
      ]);

      // Assert
      expect(result, equals(ExitCode.usage.code));
      verify(() => logger.err(expectedErrorMessage)).called(1);
    }),
  );

  test(
    'throws UsageException when name is invalid',
    withRunnerOnProject(
        (commandRunner, logger, melosFile, project, printLogs) async {
      // Arrange
      blocName = '_*fff';
      final expectedErrorMessage =
          '"$blocName" is not a valid dart class name.';

      // Act
      final result = await commandRunner.run([
        'android',
        'feature',
        'add',
        'bloc',
        blocName,
        '--feature-name',
        featureName
      ]);

      // Assert
      expect(result, equals(ExitCode.usage.code));
      verify(() => logger.err(expectedErrorMessage)).called(1);
    }),
  );

  test(
    'throws UsageException when --feature-name is missing',
    withRunnerOnProject(
        (commandRunner, logger, melosFile, project, printLogs) async {
      // Arrange
      const expectedErrorMessage = 'No option specified for the feature name.';

      // Act
      final result = await commandRunner
          .run(['android', 'feature', 'add', 'bloc', 'FooBar']);

      // Assert
      expect(result, equals(ExitCode.usage.code));
      verify(() => logger.err(expectedErrorMessage)).called(1);
    }),
  );

  test(
    'throws UsageException when --feature-name is invalid',
    withRunnerOnProject(
        (commandRunner, logger, melosFile, project, printLogs) async {
      // Arrange
      featureName = 'My*Feature';
      final expectedErrorMessage =
          '"$featureName" is not a valid package name.\n\n'
          'See https://dart.dev/tools/pub/pubspec#name for more information.';

      // Act
      final result = await commandRunner.run([
        'android',
        'feature',
        'add',
        'bloc',
        'FooBar',
        '--feature-name',
        featureName
      ]);

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
          'feature_name': featureName,
          'name': blocName,
          'platform': 'android',
        },
        logger: logger,
      ),
    ).called(1);
    expect(
      progressLogs,
      equals(['Generated ${generatedFiles.length} file(s)']),
    );
    verify(() => logger.progress(
            'Running "flutter pub run build_runner build --delete-conflicting-outputs" in $featurePackagePath '))
        .called(1);
    verify(() => flutterPubRunBuildRunnerBuildDeleteConflictingOutputs(
        cwd: featurePackagePath)).called(1);
    verify(() => logger.success(
            'Added ${blocName.pascalCase}Bloc to Android feature $featureName.'))
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

  test('exits with 78 when the feature does not exists', () async {
    // Arrange
    when(() => platformDirectory.featureExists(any())).thenReturn(false);

    // Act
    final result = await command.run();

    // Assert
    verify(() =>
            logger.err('The feature "$featureName" does not exist on Android.'))
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
}