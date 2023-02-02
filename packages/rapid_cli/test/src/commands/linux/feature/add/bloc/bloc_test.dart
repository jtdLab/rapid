import 'package:args/args.dart';
import 'package:mason/mason.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rapid_cli/src/commands/linux/feature/add/bloc/bloc.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/project/project.dart';
import 'package:test/test.dart';
import 'package:universal_io/io.dart';

import '../../../../../../helpers/helpers.dart';

const expectedUsage = [
  'Adds a bloc to a feature of the Linux part of an existing Rapid project.\n'
      '\n'
      'Usage: rapid linux feature add bloc <name> [arguments]\n'
      '-h, --help            Print this usage information.\n'
      '\n'
      '\n'
      '    --feature-name    The name of the feature this new bloc will be added to.\n'
      '                      This must be the name of an existing Linux feature.\n'
      '\n'
      'Run "rapid help" to see global options.'
];

class _MockLogger extends Mock implements Logger {}

class _MockProject extends Mock implements Project {}

class _MockArgResults extends Mock implements ArgResults {}

void main() {
  group('linux feature add bloc', () {
    Directory cwd = Directory.current;

    late Logger logger;

    late Project project;

    late ArgResults argResults;
    late String featureName;
    late String name;

    late LinuxFeatureAddBlocCommand command;

    setUp(() {
      Directory.current = Directory.systemTemp.createTempSync();

      logger = _MockLogger();

      project = _MockProject();
      when(
        () => project.addBloc(
          name: any(named: 'name'),
          featureName: any(named: 'featureName'),
          platform: Platform.linux,
          logger: logger,
        ),
      ).thenAnswer((_) async {});
      when(() => project.exists()).thenReturn(true);
      when(() => project.platformIsActivated(Platform.linux)).thenReturn(true);

      argResults = _MockArgResults();
      featureName = 'my_cool_feature';
      name = 'FooBar';
      when(() => argResults['feature-name']).thenReturn(featureName);
      when(() => argResults.rest).thenReturn([name]);

      command = LinuxFeatureAddBlocCommand(
        logger: logger,
        project: project,
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
          ['linux', 'feature', 'add', 'bloc', '--help'],
        );

        // Assert
        expect(printLogs, equals(expectedUsage));
        expect(result, equals(ExitCode.success.code));

        printLogs.clear();

        // Act
        final resultAbbr = await commandRunner.run(
          ['linux', 'feature', 'add', 'bloc', '-h'],
        );

        // Assert
        expect(printLogs, equals(expectedUsage));
        expect(resultAbbr, equals(ExitCode.success.code));
      }),
    );

    test('can be instantiated without explicit logger', () {
      // Act
      command = LinuxFeatureAddBlocCommand(project: project);

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
            ['linux', 'feature', 'add', 'bloc', '--feature-name', 'some_feat']);

        // Assert
        expect(result, equals(ExitCode.usage.code));
        verify(() => logger.err(expectedErrorMessage)).called(1);
        verify(() => logger.info('')).called(1);
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
          'linux',
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
        verify(() => logger.info('')).called(1);
      }),
    );

    test(
      'throws UsageException when name is not a valid dart class name',
      withRunnerOnProject(
          (commandRunner, logger, melosFile, project, printLogs) async {
        // Arrange
        name = '_*fff';
        final expectedErrorMessage = '"$name" is not a valid dart class name.';

        // Act
        final result = await commandRunner.run([
          'linux',
          'feature',
          'add',
          'bloc',
          name,
          '--feature-name',
          featureName
        ]);

        // Assert
        expect(result, equals(ExitCode.usage.code));
        verify(() => logger.err(expectedErrorMessage)).called(1);
        verify(() => logger.info('')).called(1);
      }),
    );

    test(
      'throws UsageException when --feature-name is missing',
      withRunnerOnProject(
          (commandRunner, logger, melosFile, project, printLogs) async {
        // Arrange
        const expectedErrorMessage =
            'No option specified for the feature name.';

        // Act
        final result = await commandRunner
            .run(['linux', 'feature', 'add', 'bloc', 'FooBar']);

        // Assert
        expect(result, equals(ExitCode.usage.code));
        verify(() => logger.err(expectedErrorMessage)).called(1);
        verify(() => logger.info('')).called(1);
      }),
    );

    test(
      'throws UsageException when --feature-name is not a valid package name',
      withRunnerOnProject(
          (commandRunner, logger, melosFile, project, printLogs) async {
        // Arrange
        featureName = 'My*Feature';
        final expectedErrorMessage =
            '"$featureName" is not a valid package name.\n\n'
            'See https://dart.dev/tools/pub/pubspec#name for more information.';

        // Act
        final result = await commandRunner.run([
          'linux',
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
        verify(() => logger.info('')).called(1);
      }),
    );

    test('completes successfully with correct output', () async {
      // Act
      final result = await command.run();

      // Assert
      verify(() => logger.info('Adding Bloc ...')).called(1);
      verify(
        () => project.addBloc(
          name: name,
          featureName: featureName,
          platform: Platform.linux,
          logger: logger,
        ),
      ).called(1);
      verify(
        () => logger.success(
          'Added ${name.pascalCase}Bloc to Linux feature $featureName.',
        ),
      ).called(1);
      verify(() => logger.info('')).called(1);
      expect(result, ExitCode.success.code);
    });

    test('exits with 78 when the feature does not exists', () async {
      // Arrange
      when(
        () => project.addBloc(
          name: any(named: 'name'),
          featureName: any(named: 'featureName'),
          platform: Platform.linux,
          logger: logger,
        ),
      ).thenThrow(FeatureDoesNotExist());

      // Act
      final result = await command.run();

      // Assert
      verify(
        () => logger.err(
          'The feature $featureName does not exist on Linux.',
        ),
      ).called(1);
      verify(() => logger.info('')).called(1);
      expect(result, ExitCode.config.code);
    });

    test('exits with 78 when the bloc already exists for the feature',
        () async {
      // Arrange
      when(
        () => project.addBloc(
          name: any(named: 'name'),
          featureName: any(named: 'featureName'),
          platform: Platform.linux,
          logger: logger,
        ),
      ).thenThrow(BlocAlreadyExists());

      // Act
      final result = await command.run();

      // Assert
      verify(
        () => logger.err(
          'The bloc $name does already exist in $featureName on Linux.',
        ),
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
