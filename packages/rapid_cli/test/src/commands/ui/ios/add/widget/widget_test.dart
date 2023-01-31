import 'package:args/args.dart';
import 'package:mason/mason.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rapid_cli/src/commands/ui/ios/add/widget/widget.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/project/melos_file.dart';
import 'package:rapid_cli/src/project/platform_ui_package.dart';
import 'package:rapid_cli/src/project/project.dart';
import 'package:test/test.dart';
import 'package:universal_io/io.dart';

import '../../../../../../helpers/helpers.dart';

const expectedUsage = [
  'Add a widget to the iOS UI part of an existing Rapid project.\n'
      '\n'
      'Usage: rapid ui ios add widget <name> [arguments]\n'
      '-h, --help          Print this usage information.\n'
      '\n'
      '\n'
      '-o, --output-dir    The output directory relative to <platform_ui_package>/lib/ .\n'
      '                    (defaults to ".")\n'
      '\n'
      'Run "rapid help" to see global options.'
];

class _MockLogger extends Mock implements Logger {}

class _MockProgress extends Mock implements Progress {}

class _MockProject extends Mock implements Project {}

class _MockMelosFile extends Mock implements MelosFile {}

class _MockPlatformUiPackage extends Mock implements PlatformUiPackage {}

class _MockMasonGenerator extends Mock implements MasonGenerator {}

class _MockArgResults extends Mock implements ArgResults {}

class _FakeDirectoryGeneratorTarget extends Fake
    implements DirectoryGeneratorTarget {}

void main() {
  group('ui ios add widget', () {
    Directory cwd = Directory.current;

    late Logger logger;
    late List<String> progressLogs;

    late Project project;
    late MelosFile melosFile;
    const projectName = 'test_app';
    late PlatformUiPackage platformUiPackage;
    const platformUiPackagePath = 'foo/bar/baz';

    late MasonGenerator generator;
    final generatedFiles = List.filled(
      23,
      const GeneratedFile.created(path: ''),
    );

    late ArgResults argResults;
    late String? outputDir;
    late String name;

    late UiIosAddWidgetCommand command;

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
      platformUiPackage = _MockPlatformUiPackage();
      when(() => platformUiPackage.path).thenReturn(platformUiPackagePath);
      when(() => project.melosFile).thenReturn(melosFile);
      when(() => project.isActivated(Platform.ios)).thenReturn(true);
      when(() => project.platformUiPackage(Platform.ios))
          .thenReturn(platformUiPackage);

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
      outputDir = null;
      name = 'FooBar';
      when(() => argResults['output-dir']).thenReturn(outputDir);
      when(() => argResults.rest).thenReturn([name]);

      command = UiIosAddWidgetCommand(
        logger: logger,
        project: project,
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
          ['ui', 'ios', 'add', 'widget', '--help'],
        );

        // Assert
        expect(printLogs, equals(expectedUsage));
        expect(result, equals(ExitCode.success.code));

        printLogs.clear();

        // Act
        final resultAbbr = await commandRunner.run(
          ['ui', 'ios', 'add', 'widget', '-h'],
        );

        // Assert
        expect(printLogs, equals(expectedUsage));
        expect(resultAbbr, equals(ExitCode.success.code));
      }),
    );

    test('can be instantiated without explicit logger', () {
      // Act
      command = UiIosAddWidgetCommand(project: project);

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
        final result = await commandRunner.run(['ui', 'ios', 'add', 'widget']);

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
          'ui',
          'ios',
          'add',
          'widget',
          'name1',
          'name2',
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
      verify(() => logger.progress('Generating files')).called(1);
      verify(
        () => generator.generate(
          any(
            that: isA<DirectoryGeneratorTarget>().having(
              (g) => g.dir.path,
              'dir',
              platformUiPackagePath,
            ),
          ),
          vars: <String, dynamic>{
            'project_name': projectName,
            'name': name,
            'output_dir': '.',
          },
          logger: logger,
        ),
      ).called(1);
      expect(
        progressLogs,
        equals(['Generated ${generatedFiles.length} file(s)']),
      );
      verify(() => logger.success('Added iOS Widget ${name.pascalCase}.'))
          .called(1);
      expect(result, ExitCode.success.code);
    });

    test('completes successfully with correct output with custom --output-dir',
        () async {
      // Arrange
      outputDir = 'foo/bar';
      when(() => argResults['output-dir']).thenReturn(outputDir);

      // Act
      final result = await command.run();

      // Assert
      verify(() => logger.progress('Generating files')).called(1);
      verify(
        () => generator.generate(
          any(
            that: isA<DirectoryGeneratorTarget>().having(
              (g) => g.dir.path,
              'dir',
              platformUiPackagePath,
            ),
          ),
          vars: <String, dynamic>{
            'project_name': projectName,
            'name': name,
            'output_dir': outputDir,
          },
          logger: logger,
        ),
      ).called(1);
      expect(
        progressLogs,
        equals(['Generated ${generatedFiles.length} file(s)']),
      );
      verify(() => logger.success('Added iOS Widget ${name.pascalCase}.'))
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

    test('exits with 78 when iOS is not activated', () async {
      // Arrange
      when(() => project.isActivated(Platform.ios)).thenReturn(false);

      // Act
      final result = await command.run();

      // Assert
      verify(() => logger.err('iOS is not activated.')).called(1);
      expect(result, ExitCode.config.code);
    });
  });
}
