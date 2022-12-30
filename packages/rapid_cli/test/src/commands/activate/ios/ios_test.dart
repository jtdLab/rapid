import 'package:args/args.dart';
import 'package:mason/mason.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rapid_cli/src/commands/activate/ios/ios.dart';
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
  'Adds support for iOS to this project.\n'
      '\n'
      'Usage: rapid activate ios\n'
      '-h, --help        Print this usage information.\n'
      '    --org-name    The organization for the native iOS project.\n'
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
  group('ios', () {
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
    late FlutterConfigEnablePlatformCommand flutterConfigEnableIos;
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

    late IosCommand command;

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
      when(() => project.isActivated(Platform.ios)).thenReturn(false);
      flutterConfigEnableIos = MockFlutterConfigEnablePlatformCommand();
      when(() => flutterConfigEnableIos()).thenAnswer((_) async {});
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

      command = IosCommand(
        logger: logger,
        project: project,
        flutterConfigEnableIos: flutterConfigEnableIos,
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

    test('i is a valid alias', () {
      // Act
      final command = IosCommand(project: project);

      // Assert
      expect(command.aliases, contains('i'));
    });

    test(
      'help',
      withRunner((commandRunner, logger, project, printLogs) async {
        // Act
        final result = await commandRunner.run(['activate', 'ios', '--help']);

        // Assert
        expect(printLogs, equals(expectedUsage));
        expect(result, equals(ExitCode.success.code));

        printLogs.clear();

        // Act
        final resultAbbr = await commandRunner.run(['activate', 'ios', '-h']);

        // Assert
        expect(printLogs, equals(expectedUsage));
        expect(resultAbbr, equals(ExitCode.success.code));
      }),
    );

    test('can be instantiated without explicit logger', () {
      // Act
      final command = IosCommand(project: project);

      // Assert
      expect(command, isNotNull);
    });

    test('completes successfully with correct output', () async {
      // Act
      final result = await command.run();

      // Assert
      verifyNever(() => logger.err('iOS already activated.'));
      verify(() => logger.info('Activating iOS ...')).called(1);
      verify(() => logger.progress('Running "flutter config --enable-ios"'))
          .called(1);
      verify(() => flutterConfigEnableIos()).called(1);
      verify(() => logger.progress('Generating iOS files')).called(1);
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
        equals(['Generated ${generatedFiles.length} iOS file(s)']),
      );
      verify(() => logger.progress('Updating package $appPackagePath '))
          .called(1);
      verify(() => appPackagePubspec.setDependency('${projectName}_ios_app'))
          .called(1);
      verify(() => mainFileDev.addPlatform(Platform.ios)).called(1);
      verify(() => mainFileTest.addPlatform(Platform.ios)).called(1);
      verify(() => mainFileProd.addPlatform(Platform.ios)).called(1);
      verify(() => logger.progress('Updating package $diPackagePath '))
          .called(1);
      verify(() =>
              diPackagePubspec.setDependency('${projectName}_ios_home_page'))
          .called(1);
      verify(() => injectionFile.addPackage('${projectName}_ios_home_page'))
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
      verify(() => logger.info('iOS activated!')).called(1);
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
      verifyNever(() => logger.err('iOS already activated.'));
      verify(() => logger.info('Activating iOS ...')).called(1);
      verify(() => logger.progress('Running "flutter config --enable-ios"'))
          .called(1);
      verify(() => flutterConfigEnableIos()).called(1);
      verify(() => logger.progress('Generating iOS files')).called(1);
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
        equals(['Generated ${generatedFiles.length} iOS file(s)']),
      );
      verify(() => logger.progress('Updating package $appPackagePath '))
          .called(1);
      verify(() => appPackagePubspec.setDependency('${projectName}_ios_app'))
          .called(1);
      verify(() => mainFileDev.addPlatform(Platform.ios)).called(1);
      verify(() => mainFileTest.addPlatform(Platform.ios)).called(1);
      verify(() => mainFileProd.addPlatform(Platform.ios)).called(1);
      verify(() => logger.progress('Updating package $diPackagePath '))
          .called(1);
      verify(() =>
              diPackagePubspec.setDependency('${projectName}_ios_home_page'))
          .called(1);
      verify(() => injectionFile.addPackage('${projectName}_ios_home_page'))
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

      verify(() => logger.info('iOS activated!')).called(1);
      expect(result, ExitCode.success.code);
    });

    test('exits with 78 when iOS is already activated', () async {
      // Arrange
      when(() => project.isActivated(Platform.ios)).thenReturn(true);

      // Act
      final result = await command.run();

      // Assert
      verify(() => logger.err('iOS is already activated.')).called(1);
      expect(result, ExitCode.config.code);
    });
  });
}
