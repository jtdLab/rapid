import 'package:args/args.dart';
import 'package:mason/mason.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rapid_cli/src/commands/ui/web/remove/widget/widget.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/project/melos_file.dart';
import 'package:rapid_cli/src/project/platform_ui_package.dart';
import 'package:rapid_cli/src/project/project.dart';
import 'package:test/test.dart';
import 'package:universal_io/io.dart';

import '../../../../../../helpers/helpers.dart';

const expectedUsage = [
  'Remove a widget from the Web UI part of an existing Rapid project.\n'
      '\n'
      'Usage: rapid ui web remove widget <name> [arguments]\n'
      '-h, --help    Print this usage information.\n'
      '\n'
      '\n'
      '-d, --dir     The directory relative to <platform_ui_package>/lib/ .\n'
      '              (defaults to ".")\n'
      '\n'
      'Run "rapid help" to see global options.'
];

class _MockLogger extends Mock implements Logger {}

class _MockProgress extends Mock implements Progress {}

class _MockProject extends Mock implements Project {}

class _MockMelosFile extends Mock implements MelosFile {}

class _MockPlatformUiPackage extends Mock implements PlatformUiPackage {}

class _MockWidget extends Mock implements Widget {}

class _MockMasonGenerator extends Mock implements MasonGenerator {}

class _MockFileSystemEntity extends Mock implements FileSystemEntity {}

class _MockArgResults extends Mock implements ArgResults {}

class _FakeDirectoryGeneratorTarget extends Fake
    implements DirectoryGeneratorTarget {}

void main() {
  group('ui web remove widget', () {
    Directory cwd = Directory.current;

    late Logger logger;
    late List<String> progressLogs;

    late Project project;
    late MelosFile melosFile;
    const projectName = 'test_app';
    late PlatformUiPackage platformUiPackage;
    const platformUiPackagePath = 'foo/bar/baz';
    late Widget widget;
    late List<FileSystemEntity> deletedEntities;
    late FileSystemEntity deletedEntity1;
    const String deletedEntity1Path = 'foo/bar/bam';
    late FileSystemEntity deletedEntity2;
    const String deletedEntity2Path = 'foo/bar/baz';

    late MasonGenerator generator;
    final generatedFiles = List.filled(
      23,
      const GeneratedFile.created(path: ''),
    );

    late ArgResults argResults;
    late String? dir;
    late String name;

    late UiWebRemoveWidgetCommand command;

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
      widget = _MockWidget();
      deletedEntity1 = _MockFileSystemEntity();
      when(() => deletedEntity1.path).thenReturn(deletedEntity1Path);
      deletedEntity2 = _MockFileSystemEntity();
      when(() => deletedEntity2.path).thenReturn(deletedEntity2Path);
      deletedEntities = [deletedEntity1, deletedEntity2];
      when(() => widget.delete()).thenReturn(deletedEntities);
      when(() => widget.exists()).thenReturn(true);
      when(() => platformUiPackage.path).thenReturn(platformUiPackagePath);
      when(() => platformUiPackage.exists()).thenReturn(true);
      when(() => platformUiPackage.widget(
          name: any(named: 'name'), dir: any(named: 'dir'))).thenReturn(widget);
      when(() => project.melosFile).thenReturn(melosFile);
      when(() => project.isActivated(Platform.web)).thenReturn(true);
      when(() => project.platformUiPackage(Platform.web))
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
      dir = null;
      name = 'FooBar';
      when(() => argResults['dir']).thenReturn(dir);
      when(() => argResults.rest).thenReturn([name]);

      command = UiWebRemoveWidgetCommand(
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
          ['ui', 'web', 'remove', 'widget', '--help'],
        );

        // Assert
        expect(printLogs, equals(expectedUsage));
        expect(result, equals(ExitCode.success.code));

        printLogs.clear();

        // Act
        final resultAbbr = await commandRunner.run(
          ['ui', 'web', 'remove', 'widget', '-h'],
        );

        // Assert
        expect(printLogs, equals(expectedUsage));
        expect(resultAbbr, equals(ExitCode.success.code));
      }),
    );

    test('can be instantiated without explicit logger', () {
      // Act
      command = UiWebRemoveWidgetCommand(project: project);

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
            await commandRunner.run(['ui', 'web', 'remove', 'widget']);

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
          'web',
          'remove',
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
      verify(() => project.platformUiPackage(Platform.web));
      verify(() => platformUiPackage.widget(name: name, dir: '.'));
      verify(() => widget.exists()).called(1);
      verify(() => widget.delete()).called(1);
      verify(() => logger.info(deletedEntity1Path)).called(1);
      verify(() => logger.info(deletedEntity2Path)).called(1);
      verify(() => logger.info('Deleted ${deletedEntities.length} item(s)'))
          .called(1);
      verify(() => logger.info('')).called(2);
      verify(() => logger.success('Removed Web Widget $name.')).called(1);
      expect(result, ExitCode.success.code);
    });

    test('completes successfully with correct output with custom --dir',
        () async {
      // Arrange
      dir = 'foo/bar';
      when(() => argResults['dir']).thenReturn(dir);

      // Act
      final result = await command.run();

      // Assert
      verify(() => project.platformUiPackage(Platform.web));
      verify(() => platformUiPackage.widget(name: name, dir: dir!));
      verify(() => widget.exists()).called(1);
      verify(() => widget.delete()).called(1);
      verify(() => logger.info(deletedEntity1Path)).called(1);
      verify(() => logger.info(deletedEntity2Path)).called(1);
      verify(() => logger.info('Deleted ${deletedEntities.length} item(s)'))
          .called(1);
      verify(() => logger.info('')).called(2);
      verify(() => logger.success('Removed Web Widget $name.')).called(1);
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

    test('exits with 78 when the referenced widget does not exist', () async {
      // Arrange
      when(() => widget.exists()).thenReturn(false);

      // Act
      final result = await command.run();

      // Assert
      verifyNever(() => widget.delete());
      verify(() => logger.err('Web Widget $name not found.')).called(1);
      expect(result, ExitCode.config.code);
    });
  });
}
