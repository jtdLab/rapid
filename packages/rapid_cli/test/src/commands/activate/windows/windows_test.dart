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
  // ignore: no_adjacent_strings_in_list
  'Adds support for Windows to this project.\n'
      '\n'
      'Usage: rapid activate windows\n'
      '-h, --help        Print this usage information.\n'
      '    --org-name    The organization for the native Windows project.\n'
      '                  (defaults to "com.example")\n'
      '\n'
      'Run "rapid help" to see global options.'
];

// ignore: one_member_abstracts
abstract class FlutterConfigEnablePlatformCommand {
  Future<void> call();
}

abstract class FlutterPubGetCommand {
  Future<void> call({String cwd});
}

abstract class FlutterPubRunBuildRunnerBuildDeleteConflictingOutputsCommand {
  Future<void> call({String cwd});
}

abstract class MelosBoostrapCommand {
  Future<void> call({String cwd});
}

abstract class MelosCleanCommand {
  Future<void> call({String cwd});
}

class MockArgResults extends Mock implements ArgResults {}

class MockLogger extends Mock implements Logger {}

class MockProgress extends Mock implements Progress {}

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
  group('windows', () {
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
    late FlutterConfigEnablePlatformCommand flutterConfigEnableWindows;
    late FlutterPubGetCommand flutterPubGet;
    late FlutterPubRunBuildRunnerBuildDeleteConflictingOutputsCommand
        flutterPubRunBuildRunnerBuildDeleteConflictingOutputs;
    late MelosBoostrapCommand melosBootstrap;
    late MelosCleanCommand melosClean;
    final generatedFiles = List.filled(
      62,
      const GeneratedFile.created(path: ''),
    );
    late MasonGenerator generator;
    late ArgResults argResults;

    late WindowsCommand command;

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
      when(() => project.melosFile).thenReturn(melosFile);
      when(() => project.appPackage).thenReturn(appPackage);
      when(() => project.diPackage).thenReturn(diPackage);
      when(() => project.isActivated(Platform.windows)).thenReturn(false);
      flutterConfigEnableWindows = MockFlutterConfigEnablePlatformCommand();
      when(() => flutterConfigEnableWindows()).thenAnswer((_) async {});
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
      argResults = MockArgResults();
      when(() => argResults['org-name']).thenReturn(null);

      command = WindowsCommand(
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
      final command = WindowsCommand(project: project);

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
      final command = WindowsCommand(project: project);

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
