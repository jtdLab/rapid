import 'package:args/args.dart';
import 'package:mason/mason.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rapid_cli/src/commands/activate/windows/windows.dart';
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
  'Adds support for Windows to this project.\n'
      '\n'
      'Usage: rapid activate windows\n'
      '-h, --help        Print this usage information.\n'
      '    --org-name    The organization for the native Windows project.\n'
      '                  (defaults to "com.example")\n'
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

abstract class _MelosBoostrapCommand {
  Future<void> call({String cwd});
}

abstract class _MelosCleanCommand {
  Future<void> call({String cwd});
}

class _MockArgResults extends Mock implements ArgResults {}

class _MockLogger extends Mock implements Logger {}

class _MockProgress extends Mock implements Progress {}

class _MockMelosFile extends Mock implements MelosFile {}

class _MockPubspecFile extends Mock implements PubspecFile {}

class _MockMainFile extends Mock implements MainFile {}

class _MockAppPackage extends Mock implements AppPackage {}

class _MockInjectionFile extends Mock implements InjectionFile {}

class _MockDiPackage extends Mock implements DiPackage {}

class _MockProject extends Mock implements Project {}

class MockFlutterConfigEnablePlatformCommand extends Mock
    implements _FlutterConfigEnablePlatformCommand {}

class _MockFlutterPubGetCommand extends Mock implements _FlutterPubGetCommand {}

class MockFlutterPubRunBuildRunnerBuildDeleteConflictingOutputsCommand
    extends Mock
    implements _FlutterPubRunBuildRunnerBuildDeleteConflictingOutputsCommand {}

class _MockMelosBootstrapCommand extends Mock implements _MelosBoostrapCommand {
}

class _MockMelosCleanCommand extends Mock implements _MelosCleanCommand {}

class _MockMasonGenerator extends Mock implements MasonGenerator {}

class FakeDirectoryGeneratorTarget extends Fake
    implements DirectoryGeneratorTarget {}

void main() {
  group('activate windows', () {
    final cwd = Directory.current;

    late List<String> progressLogs;
    late Logger logger;
    late Progress progress;
    const projectName = 'test_app';
    late MelosFile melosFile;
    late PubspecFile appPackagePubspec;
    late MainFile mainFileDev;
    late MainFile mainFileTest;
    late MainFile mainFileProd;
    const appPackagePath = 'bam/boz';
    late AppPackage appPackage;
    late PubspecFile diPackagePubspec;
    late InjectionFile injectionFile;
    const diPackagePath = 'foo/bar/baz';
    late DiPackage diPackage;
    late Project project;
    late _FlutterConfigEnablePlatformCommand flutterConfigEnableWindows;
    late _FlutterPubGetCommand flutterPubGet;
    late _FlutterPubRunBuildRunnerBuildDeleteConflictingOutputsCommand
        flutterPubRunBuildRunnerBuildDeleteConflictingOutputs;
    late _MelosBoostrapCommand melosBootstrap;
    late _MelosCleanCommand melosClean;
    final generatedFiles = List.filled(
      23,
      const GeneratedFile.created(path: ''),
    );
    late MasonGenerator generator;
    late ArgResults argResults;

    late ActivateWindowsCommand command;

    setUpAll(() {
      registerFallbackValue(FakeDirectoryGeneratorTarget());
    });

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
      melosFile = _MockMelosFile();
      when(() => melosFile.exists()).thenReturn(true);
      when(() => melosFile.name()).thenReturn(projectName);
      appPackagePubspec = _MockPubspecFile();
      mainFileDev = _MockMainFile();
      mainFileTest = _MockMainFile();
      mainFileProd = _MockMainFile();
      appPackage = _MockAppPackage();
      when(() => appPackage.path).thenReturn(appPackagePath);
      when(() => appPackage.pubspecFile).thenReturn(appPackagePubspec);
      when(() => appPackage.mainFiles)
          .thenReturn({mainFileDev, mainFileTest, mainFileProd});
      diPackagePubspec = _MockPubspecFile();
      injectionFile = _MockInjectionFile();
      diPackage = _MockDiPackage();
      when(() => diPackage.path).thenReturn(diPackagePath);
      when(() => diPackage.pubspecFile).thenReturn(diPackagePubspec);
      when(() => diPackage.injectionFile).thenReturn(injectionFile);
      project = _MockProject();
      when(() => project.melosFile).thenReturn(melosFile);
      when(() => project.appPackage).thenReturn(appPackage);
      when(() => project.diPackage).thenReturn(diPackage);
      when(() => project.isActivated(Platform.windows)).thenReturn(false);
      flutterConfigEnableWindows = MockFlutterConfigEnablePlatformCommand();
      when(() => flutterConfigEnableWindows()).thenAnswer((_) async {});
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

      command = ActivateWindowsCommand(
        logger: logger,
        project: project,
        flutterConfigEnableWindows: flutterConfigEnableWindows,
        flutterPubGetCommand: flutterPubGet,
        flutterPubRunBuildRunnerBuildDeleteConflictingOutputs:
            flutterPubRunBuildRunnerBuildDeleteConflictingOutputs,
        melosBootstrap: melosBootstrap,
        melosClean: melosClean,
        generator: (_) async => generator,
      )..argResultOverrides = argResults;
    });

    tearDown(() {
      Directory.current = cwd;
    });

    test('i is win valid alias', () {
      // Act
      final command = ActivateWindowsCommand(project: project);

      // Assert
      expect(command.aliases, contains('win'));
    });

    test(
      'help',
      withRunner((commandRunner, logger, printLogs) async {
        // Act
        final result =
            await commandRunner.run(['activate', 'windows', '--help']);

        // Assert
        expect(printLogs, equals(expectedUsage));
        expect(result, equals(ExitCode.success.code));

        printLogs.clear();

        // Act
        final resultAbbr =
            await commandRunner.run(['activate', 'windows', '-h']);

        // Assert
        expect(printLogs, equals(expectedUsage));
        expect(resultAbbr, equals(ExitCode.success.code));
      }),
    );

    test('can be instantiated without explicit logger', () {
      // Act
      final command = ActivateWindowsCommand(project: project);

      // Assert
      expect(command, isNotNull);
    });

    test('completes successfully with correct output', () async {
      // Act
      final result = await command.run();

      // Assert
      verifyNever(() => logger.err('Windows already activated.'));
      verify(() => logger.info('Activating Windows ...')).called(1);
      verify(() => logger.progress(
          'Running "flutter config --enable-windows-desktop"')).called(1);
      verify(() => flutterConfigEnableWindows()).called(1);
      verify(() => logger.progress('Generating Windows files')).called(1);
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
            'org_name': 'com.example',
          },
          logger: logger,
        ),
      ).called(1);
      expect(
        progressLogs,
        equals(['Generated ${generatedFiles.length} Windows file(s)']),
      );
      verify(() => logger.progress('Updating package $appPackagePath '))
          .called(1);
      verify(() =>
              appPackagePubspec.setDependency('${projectName}_windows_app'))
          .called(1);
      verify(() => mainFileDev.addSetupCodeForPlatform(Platform.windows))
          .called(1);
      verify(() => mainFileTest.addSetupCodeForPlatform(Platform.windows))
          .called(1);
      verify(() => mainFileProd.addSetupCodeForPlatform(Platform.windows))
          .called(1);
      verify(() => logger.progress('Updating package $diPackagePath '))
          .called(1);
      verify(() => diPackagePubspec
          .setDependency('${projectName}_windows_home_page')).called(1);
      verify(() => injectionFile.addPackage('${projectName}_windows_home_page'))
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
      verify(() => logger.info('Windows activated!')).called(1);
      expect(result, ExitCode.success.code);
    });

    // TODO maybe share test logic better between this and the test before this all but the custom org name is same
    test('completes successfully with correct output w/ custom org-name',
        () async {
      // Arrange
      const customOrgName = 'custom.org.name';
      when(() => argResults['org-name']).thenReturn(customOrgName);

      // Act
      final result = await command.run();

      // Assert
      verifyNever(() => logger.err('Windows already activated.'));
      verify(() => logger.info('Activating Windows ...')).called(1);
      verify(() => logger.progress(
          'Running "flutter config --enable-windows-desktop"')).called(1);
      verify(() => flutterConfigEnableWindows()).called(1);
      verify(() => logger.progress('Generating Windows files')).called(1);
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
            'org_name': customOrgName,
          },
          logger: logger,
        ),
      ).called(1);
      expect(
        progressLogs,
        equals(['Generated ${generatedFiles.length} Windows file(s)']),
      );
      verify(() => logger.progress('Updating package $appPackagePath '))
          .called(1);
      verify(() =>
              appPackagePubspec.setDependency('${projectName}_windows_app'))
          .called(1);
      verify(() => mainFileDev.addSetupCodeForPlatform(Platform.windows))
          .called(1);
      verify(() => mainFileTest.addSetupCodeForPlatform(Platform.windows))
          .called(1);
      verify(() => mainFileProd.addSetupCodeForPlatform(Platform.windows))
          .called(1);
      verify(() => logger.progress('Updating package $diPackagePath '))
          .called(1);
      verify(() => diPackagePubspec
          .setDependency('${projectName}_windows_home_page')).called(1);
      verify(() => injectionFile.addPackage('${projectName}_windows_home_page'))
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

      verify(() => logger.info('Windows activated!')).called(1);
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

    test('exits with 78 when Windows is already activated', () async {
      // Arrange
      when(() => project.isActivated(Platform.windows)).thenReturn(true);

      // Act
      final result = await command.run();

      // Assert
      verify(() => logger.err('Windows is already activated.')).called(1);
      expect(result, ExitCode.config.code);
    });
  });
}
