import 'package:args/args.dart';
import 'package:mason/mason.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rapid_cli/src/cli/cli.dart';
import 'package:rapid_cli/src/commands/activate/web/web.dart';
import 'package:rapid_cli/src/core/dart_package.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/project/app_package.dart';
import 'package:rapid_cli/src/project/di_package.dart';
import 'package:rapid_cli/src/project/melos_file.dart';
import 'package:rapid_cli/src/project/project.dart';
import 'package:test/test.dart';
import 'package:universal_io/io.dart';

import '../../../../helpers/helpers.dart';

const expectedUsage = [
  'Adds support for Web to this project.\n'
      '\n'
      'Usage: rapid activate web\n'
      '-h, --help    Print this usage information.\n'
      '\n'
      'Run "rapid help" to see global options.'
];

abstract class _FlutterConfigEnablePlatformCommand {
  Future<void> call();
}

abstract class _FlutterPubGetCommand {
  Future<void> call({String cwd});
}

abstract class _FlutterPubRunBuildRunnerBuildDeleteConflictingOutputsCommand {
  Future<void> call({String cwd});
}

abstract class _MelosBootstrapCommand {
  Future<void> call({String cwd});
}

abstract class _MelosCleanCommand {
  Future<void> call({String cwd});
}

abstract class _FlutterFormatFixCommand {
  Future<void> call({String cwd});
}

class _MockLogger extends Mock implements Logger {}

class _MockProgress extends Mock implements Progress {}

class _MockProject extends Mock implements Project {}

class _MockMelosFile extends Mock implements MelosFile {}

class _MockAppPackage extends Mock implements AppPackage {}

class _MockPubspecFile extends Mock implements PubspecFile {}

class _MockMainFile extends Mock implements MainFile {}

class _MockDiPackage extends Mock implements DiPackage {}

class _MockInjectionFile extends Mock implements InjectionFile {}

class MockFlutterConfigEnablePlatformCommand extends Mock
    implements _FlutterConfigEnablePlatformCommand {}

class _MockFlutterPubGetCommand extends Mock implements _FlutterPubGetCommand {}

class MockFlutterPubRunBuildRunnerBuildDeleteConflictingOutputsCommand
    extends Mock
    implements _FlutterPubRunBuildRunnerBuildDeleteConflictingOutputsCommand {}

class _MockMelosBootstrapCommand extends Mock
    implements _MelosBootstrapCommand {}

class _MockFlutterFormatFixCommand extends Mock
    implements _FlutterFormatFixCommand {}

class _MockMelosCleanCommand extends Mock implements _MelosCleanCommand {}

class _MockMasonGenerator extends Mock implements MasonGenerator {}

class _MockArgResults extends Mock implements ArgResults {}

class _FakeDirectoryGeneratorTarget extends Fake
    implements DirectoryGeneratorTarget {}

void main() {
  group('activate web', () {
    final cwd = Directory.current;

    late Logger logger;
    late Progress progress;
    late List<String> progressLogs;

    late Project project;
    late MelosFile melosFile;
    const projectName = 'test_app';
    late AppPackage appPackage;
    const appPackagePath = 'bam/boz';
    late PubspecFile appPackagePubspec;
    late MainFile mainFileDev;
    late MainFile mainFileTest;
    late MainFile mainFileProd;

    late PubspecFile diPackagePubspec;
    late InjectionFile injectionFile;
    const diPackagePath = 'foo/bar/baz';
    late DiPackage diPackage;

    late FlutterConfigEnablePlatformCommand flutterConfigEnableWeb;

    late FlutterPubGetCommand flutterPubGet;

    late FlutterPubRunBuildRunnerBuildDeleteConflictingOutputsCommand
        flutterPubRunBuildRunnerBuildDeleteConflictingOutputs;

    late MelosBootstrapCommand melosBootstrap;

    late MelosCleanCommand melosClean;

    late FlutterFormatFixCommand flutterFormatFix;

    late MasonGenerator generator;
    final generatedFiles = List.filled(
      23,
      const GeneratedFile.created(path: ''),
    );

    late ArgResults argResults;

    late ActivateWebCommand command;

    setUpAll(() {
      registerFallbackValue(_FakeDirectoryGeneratorTarget());
    });

    setUp(() {
      Directory.current = Directory.systemTemp.createTempSync();

      logger = _MockLogger();
      progress = _MockProgress();
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
      appPackage = _MockAppPackage();
      appPackagePubspec = _MockPubspecFile();
      mainFileDev = _MockMainFile();
      mainFileTest = _MockMainFile();
      mainFileProd = _MockMainFile();
      when(() => appPackage.path).thenReturn(appPackagePath);
      when(() => appPackage.pubspecFile).thenReturn(appPackagePubspec);
      when(() => appPackage.mainFiles)
          .thenReturn({mainFileDev, mainFileTest, mainFileProd});
      diPackage = _MockDiPackage();
      diPackagePubspec = _MockPubspecFile();
      injectionFile = _MockInjectionFile();
      when(() => diPackage.path).thenReturn(diPackagePath);
      when(() => diPackage.pubspecFile).thenReturn(diPackagePubspec);
      when(() => diPackage.injectionFile).thenReturn(injectionFile);
      when(() => project.melosFile).thenReturn(melosFile);
      when(() => project.appPackage).thenReturn(appPackage);
      when(() => project.diPackage).thenReturn(diPackage);
      when(() => project.isActivated(Platform.web)).thenReturn(false);

      flutterConfigEnableWeb = MockFlutterConfigEnablePlatformCommand();
      when(() => flutterConfigEnableWeb()).thenAnswer((_) async {});

      flutterPubGet = _MockFlutterPubGetCommand();
      when(() => flutterPubGet(cwd: any(named: 'cwd')))
          .thenAnswer((_) async {});

      flutterPubRunBuildRunnerBuildDeleteConflictingOutputs =
          MockFlutterPubRunBuildRunnerBuildDeleteConflictingOutputsCommand();
      when(() => flutterPubRunBuildRunnerBuildDeleteConflictingOutputs(
          cwd: any(named: 'cwd'))).thenAnswer((_) async {});

      melosBootstrap = _MockMelosBootstrapCommand();
      when(() => melosBootstrap(cwd: any(named: 'cwd')))
          .thenAnswer((_) async {});

      melosClean = _MockMelosCleanCommand();
      when(() => melosClean(cwd: any(named: 'cwd'))).thenAnswer((_) async {});

      flutterFormatFix = _MockFlutterFormatFixCommand();
      when(() => flutterFormatFix(cwd: any(named: 'cwd')))
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

      command = ActivateWebCommand(
        logger: logger,
        project: project,
        flutterConfigEnableWeb: flutterConfigEnableWeb,
        flutterPubGetCommand: flutterPubGet,
        flutterPubRunBuildRunnerBuildDeleteConflictingOutputs:
            flutterPubRunBuildRunnerBuildDeleteConflictingOutputs,
        melosBootstrap: melosBootstrap,
        melosClean: melosClean,
        flutterFormatFix: flutterFormatFix,
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

    test('can be instantiated without explicit logger', () {
      // Act
      final command = ActivateWebCommand(project: project);

      // Assert
      expect(command, isNotNull);
    });

    test('completes successfully with correct output', () async {
      // Act
      final result = await command.run();

      // Assert
      verifyNever(() => logger.err('Web already activated.'));
      verify(() => logger.info('Activating Web ...')).called(1);
      verify(() => logger.progress('Running "flutter config --enable-web"'))
          .called(1);
      verify(() => flutterConfigEnableWeb()).called(1);
      verify(() => logger.progress('Generating Web files')).called(1);
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
          },
          logger: logger,
        ),
      ).called(1);
      expect(
        progressLogs,
        equals(['Generated ${generatedFiles.length} Web file(s)']),
      );
      verify(() => logger.progress('Updating package $appPackagePath '))
          .called(1);
      verify(() => appPackagePubspec.setDependency('${projectName}_web_app'))
          .called(1);
      verify(() => mainFileDev.addSetupCodeForPlatform(Platform.web)).called(1);
      verify(() => mainFileTest.addSetupCodeForPlatform(Platform.web))
          .called(1);
      verify(() => mainFileProd.addSetupCodeForPlatform(Platform.web))
          .called(1);
      verify(() => logger.progress('Updating package $diPackagePath '))
          .called(1);
      verify(() =>
              diPackagePubspec.setDependency('${projectName}_web_home_page'))
          .called(1);
      verify(() => injectionFile.addPackage('${projectName}_web_home_page'))
          .called(1);
      verify(() => logger.progress('Running "melos clean" in . ')).called(1);
      verify(() => melosClean()).called(1);
      verify(() => logger.progress('Running "melos bootstrap" in . '))
          .called(1);
      verify(() => melosBootstrap()).called(1);
      verify(() =>
              logger.progress('Running "flutter pub get" in $diPackagePath '))
          .called(1);
      verify(() => flutterPubGet(cwd: diPackagePath)).called(1);
      verify(() => logger.progress(
              'Running "flutter pub run build_runner build --delete-conflicting-outputs" in $diPackagePath '))
          .called(1);
      verify(() => flutterPubRunBuildRunnerBuildDeleteConflictingOutputs(
          cwd: diPackagePath)).called(1);
      verify(() => logger.progress('Running "flutter format . --fix" in . '))
          .called(1);
      verify(() => flutterFormatFix()).called(1);
      verify(() => progress.complete()).called(8);
      verify(() => logger.info('Web activated!')).called(1);
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

    test('exits with 78 when Web is already activated', () async {
      // Arrange
      when(() => project.isActivated(Platform.web)).thenReturn(true);

      // Act
      final result = await command.run();

      // Assert
      verify(() => logger.err('Web is already activated.')).called(1);
      expect(result, ExitCode.config.code);
    });
  });
}
