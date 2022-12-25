import 'package:mason/mason.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rapid_cli/src/commands/activate/web/web.dart';
import 'package:rapid_cli/src/core/app_package.dart';
import 'package:rapid_cli/src/core/di_package.dart';
import 'package:rapid_cli/src/core/melos_file.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/core/project.dart';
import 'package:rapid_cli/src/core/project_package.dart';
import 'package:rapid_cli/src/core/root_dir.dart';
import 'package:test/test.dart';
import 'package:universal_io/io.dart';

import '../../../helpers/helpers.dart';

const expectedUsage = [
  // ignore: no_adjacent_strings_in_list
  'Adds support for Web to this project.\n'
      '\n'
      'Usage: rapid activate web\n'
      '-h, --help    Print this usage information.\n'
      '\n'
      'Run "rapid help" to see global options.'
];

// ignore: one_member_abstracts
abstract class FlutterConfigEnablePlatformCommand {
  Future<void> call();
}

abstract class FlutterPubGetCommand {
  Future<void> call({required String cwd});
}

abstract class FlutterPubRunBuildRunnerBuildDeleteConflictingOutputsCommand {
  Future<void> call({required String cwd});
}

abstract class MelosBoostrapCommand {
  Future<void> call({required String cwd});
}

abstract class MelosCleanCommand {
  Future<void> call({required String cwd});
}

class MockLogger extends Mock implements Logger {}

class MockProgress extends Mock implements Progress {}

class MockRootDir extends Mock implements RootDir {}

class MockMelosFile extends Mock implements MelosFile {}

class MockPubspecFile extends Mock implements PubspecFile {}

class MockMainFile extends Mock implements MainFile {}

class MockAppPackage extends Mock implements AppPackage {}

class MockInjectionFile extends Mock implements InjectionFile {}

class MockDiPackage extends Mock implements DiPackage {}

class MockProject extends Mock implements Project {}

class MockFlutterConfigEnablePlatformCommand extends Mock
    implements FlutterConfigEnablePlatformCommand {}

class MockFlutterPubGetCommand extends Mock implements FlutterPubGetCommand {}

class MockFlutterPubRunBuildRunnerBuildDeleteConflictingOutputsCommand
    extends Mock
    implements FlutterPubRunBuildRunnerBuildDeleteConflictingOutputsCommand {}

class MockMelosBootstrapCommand extends Mock implements MelosBoostrapCommand {}

class MockMelosCleanCommand extends Mock implements MelosCleanCommand {}

class MockMasonGenerator extends Mock implements MasonGenerator {}

class FakeDirectoryGeneratorTarget extends Fake
    implements DirectoryGeneratorTarget {}

void main() {
  group('web', () {
    final cwd = Directory.current;

    late Directory tempDir;
    late List<String> progressLogs;
    late Logger logger;
    late Progress progress;
    late RootDir rootDir;
    late MelosFile melosFile;
    const appPackagePath = 'bam/boz';
    late PubspecFile appPackagePubspec;
    late MainFile mainFileDev;
    late MainFile mainFileTest;
    late MainFile mainFileProd;
    late AppPackage appPackage;
    late PubspecFile diPackagePubspec;
    late InjectionFile injectionFile;
    const diPackagePath = 'foo/bar/baz';
    late DiPackage diPackage;
    late Project project;
    late FlutterConfigEnablePlatformCommand flutterConfigEnableWeb;
    late FlutterPubGetCommand flutterPubGet;
    late FlutterPubRunBuildRunnerBuildDeleteConflictingOutputsCommand
        flutterPubRunBuildRunnerBuildDeleteConflictingOutputs;
    late MelosBoostrapCommand melosBootstrap;
    late MelosCleanCommand melosClean;
    late MasonGenerator generator;

    late WebCommand command;

    const projectName = 'test_app';
    final generatedFiles = List.filled(
      62,
      const GeneratedFile.created(path: ''),
    );

    setUpAll(() {
      registerFallbackValue(FakeDirectoryGeneratorTarget());
    });

    setUp(() {
      tempDir = Directory.systemTemp.createTempSync();
      Directory.current = tempDir;

      progressLogs = <String>[];
      progress = MockProgress();
      when(() => progress.complete(any())).thenAnswer((_) {
        final message = _.positionalArguments.elementAt(0) as String?;
        if (message != null) progressLogs.add(message);
      });
      logger = MockLogger();
      when(() => logger.progress(any())).thenReturn(progress);
      when(() => logger.err(any())).thenReturn(null);
      rootDir = MockRootDir();
      when(() => rootDir.directory).thenReturn(tempDir);
      when(() => rootDir.path).thenReturn(tempDir.path);
      melosFile = MockMelosFile();
      when(() => melosFile.name).thenReturn(projectName);
      appPackagePubspec = MockPubspecFile();
      mainFileDev = MockMainFile();
      mainFileTest = MockMainFile();
      mainFileProd = MockMainFile();
      appPackage = MockAppPackage();
      when(() => appPackage.path).thenReturn(appPackagePath);
      when(() => appPackage.pubspecFile).thenReturn(appPackagePubspec);
      when(() => appPackage.mainFiles)
          .thenReturn({mainFileDev, mainFileTest, mainFileProd});
      diPackagePubspec = MockPubspecFile();
      injectionFile = MockInjectionFile();
      diPackage = MockDiPackage();
      when(() => diPackage.path).thenReturn(diPackagePath);
      when(() => diPackage.pubspecFile).thenReturn(diPackagePubspec);
      when(() => diPackage.injectionFile).thenReturn(injectionFile);
      project = MockProject();
      when(() => project.rootDir).thenReturn(rootDir);
      when(() => project.melosFile).thenReturn(melosFile);
      when(() => project.appPackage).thenReturn(appPackage);
      when(() => project.diPackage).thenReturn(diPackage);
      when(() => project.isActivated(Platform.web)).thenReturn(false);
      flutterConfigEnableWeb = MockFlutterConfigEnablePlatformCommand();
      when(() => flutterConfigEnableWeb()).thenAnswer((_) async {});
      flutterPubGet = MockFlutterPubGetCommand();
      when(() => flutterPubGet(cwd: any(named: 'cwd')))
          .thenAnswer((_) async {});
      flutterPubRunBuildRunnerBuildDeleteConflictingOutputs =
          MockFlutterPubRunBuildRunnerBuildDeleteConflictingOutputsCommand();
      when(() => flutterPubRunBuildRunnerBuildDeleteConflictingOutputs(
          cwd: any(named: 'cwd'))).thenAnswer((_) async {});
      melosBootstrap = MockMelosBootstrapCommand();
      when(() => melosBootstrap(cwd: any(named: 'cwd')))
          .thenAnswer((_) async {});
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

      command = WebCommand(
        logger: logger,
        project: project,
        flutterConfigEnableWeb: flutterConfigEnableWeb,
        flutterPubGetCommand: flutterPubGet,
        flutterPubRunBuildRunnerBuildDeleteConflictingOutputs:
            flutterPubRunBuildRunnerBuildDeleteConflictingOutputs,
        melosBootstrap: melosBootstrap,
        melosClean: melosClean,
        generator: (_) async => generator,
      );
    });

    tearDown(() {
      Directory.current = cwd;
    });

    test(
      'help',
      withRunner((commandRunner, logger, project, printLogs) async {
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
      final command = WebCommand(project: project);

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
              tempDir.path,
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
      verify(() => appPackagePubspec.addDependency('${projectName}_web_app'))
          .called(1);
      verify(() => mainFileDev.addPlatform(Platform.web)).called(1);
      verify(() => mainFileTest.addPlatform(Platform.web)).called(1);
      verify(() => mainFileProd.addPlatform(Platform.web)).called(1);
      verify(() => logger.progress('Updating package $diPackagePath '))
          .called(1);
      verify(() =>
              diPackagePubspec.addDependency('${projectName}_web_home_page'))
          .called(1);
      verify(() => injectionFile.addPackage('${projectName}_web_home_page'))
          .called(1);
      verify(() => logger.progress('Running "melos clean" in ${tempDir.path} '))
          .called(1);
      verify(() => melosClean(cwd: tempDir.path)).called(1);
      verify(() =>
              logger.progress('Running "melos bootstrap" in ${tempDir.path} '))
          .called(1);
      verify(() => melosBootstrap(cwd: tempDir.path)).called(1);
      verify(() =>
              logger.progress('Running "flutter pub get" in $diPackagePath '))
          .called(1);
      verify(() => flutterPubGet(cwd: diPackagePath)).called(1);
      verify(() => logger.progress(
              'Running "flutter pub run build_runner build --delete-conflicting-outputs" in $diPackagePath '))
          .called(1);
      verify(() => flutterPubRunBuildRunnerBuildDeleteConflictingOutputs(
          cwd: diPackagePath)).called(1);

      verify(() => logger.info('Web activated!')).called(1);
      expect(result, ExitCode.success.code);
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
