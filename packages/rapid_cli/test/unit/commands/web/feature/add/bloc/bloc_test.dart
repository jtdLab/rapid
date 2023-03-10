import 'package:args/args.dart';
import 'package:mason/mason.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rapid_cli/src/commands/web/feature/add/bloc/bloc.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/project/project.dart';
import 'package:test/test.dart';
import 'dart:io';

import '../../../../../common.dart';
import '../../../../../mocks.dart';

const expectedUsage = [
  'Adds a bloc to a feature of the Web part of an existing Rapid project.\n'
      '\n'
      'Usage: rapid web feature add bloc <name> [arguments]\n'
      '-h, --help       Print this usage information.\n'
      '\n'
      '\n'
      '-f, --feature    The name of the feature this new bloc will be added to.\n'
      '                 This must be the name of an existing Web feature.\n'
      '\n'
      'Run "rapid help" to see global options.'
];

void main() {
  group('web feature add bloc', () {
    Directory cwd = Directory.current;

    late Logger logger;

    late Project project;

    late ArgResults argResults;
    late String featureName;
    late String name;

    late WebFeatureAddBlocCommand command;

    setUp(() {
      Directory.current = Directory.systemTemp.createTempSync();

      logger = MockLogger();

      project = MockProject();
      when(
        () => project.addBloc(
          name: any(named: 'name'),
          featureName: any(named: 'featureName'),
          platform: Platform.web,
          logger: logger,
        ),
      ).thenAnswer((_) async {});
      when(() => project.existsAll()).thenReturn(true);
      when(() => project.platformIsActivated(Platform.web)).thenReturn(true);

      argResults = MockArgResults();
      featureName = 'my_cool_feature';
      name = 'FooBar';
      when(() => argResults['feature']).thenReturn(featureName);
      when(() => argResults.rest).thenReturn([name]);

      command = WebFeatureAddBlocCommand(
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
          ['web', 'feature', 'add', 'bloc', '--help'],
        );

        // Assert
        expect(printLogs, equals(expectedUsage));
        expect(result, equals(ExitCode.success.code));

        printLogs.clear();

        // Act
        final resultAbbr = await commandRunner.run(
          ['web', 'feature', 'add', 'bloc', '-h'],
        );

        // Assert
        expect(printLogs, equals(expectedUsage));
        expect(resultAbbr, equals(ExitCode.success.code));
      }),
    );

    test('can be instantiated without explicit logger', () {
      // Act
      command = WebFeatureAddBlocCommand(project: project);

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
        final result = await commandRunner
            .run(['web', 'feature', 'add', 'bloc', '--feature', 'some_feat']);

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
          'web',
          'feature',
          'add',
          'bloc',
          'name1',
          'name2',
          '--feature',
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
        final result = await commandRunner.run(
            ['web', 'feature', 'add', 'bloc', name, '--feature', featureName]);

        // Assert
        expect(result, equals(ExitCode.usage.code));
        verify(() => logger.err(expectedErrorMessage)).called(1);
        verify(() => logger.info('')).called(1);
      }),
    );

    test(
      'throws UsageException when --feature is missing',
      withRunnerOnProject(
          (commandRunner, logger, melosFile, project, printLogs) async {
        // Arrange
        const expectedErrorMessage = 'No option specified for the feature.';

        // Act
        final result = await commandRunner
            .run(['web', 'feature', 'add', 'bloc', 'FooBar']);

        // Assert
        expect(result, equals(ExitCode.usage.code));
        verify(() => logger.err(expectedErrorMessage)).called(1);
        verify(() => logger.info('')).called(1);
      }),
    );

    test(
      'throws UsageException when --feature is not a valid package name',
      withRunnerOnProject(
          (commandRunner, logger, melosFile, project, printLogs) async {
        // Arrange
        featureName = 'My*Feature';
        final expectedErrorMessage =
            '"$featureName" is not a valid package name.\n\n'
            'See https://dart.dev/tools/pub/pubspec#name for more information.';

        // Act
        final result = await commandRunner.run([
          'web',
          'feature',
          'add',
          'bloc',
          'FooBar',
          '--feature',
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
          platform: Platform.web,
          logger: logger,
        ),
      ).called(1);
      verify(
        () => logger.success(
          'Added ${name.pascalCase}Bloc to Web feature $featureName.',
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
          platform: Platform.web,
          logger: logger,
        ),
      ).thenThrow(FeatureDoesNotExist());

      // Act
      final result = await command.run();

      // Assert
      verify(
        () => logger.err(
          'The feature $featureName does not exist on Web.',
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
          platform: Platform.web,
          logger: logger,
        ),
      ).thenThrow(BlocAlreadyExists());

      // Act
      final result = await command.run();

      // Assert
      verify(
        () => logger.err(
          'The bloc $name does already exist in $featureName on Web.',
        ),
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
