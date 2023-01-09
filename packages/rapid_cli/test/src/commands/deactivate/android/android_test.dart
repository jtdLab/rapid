import 'package:mason/mason.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rapid_cli/src/cli/cli.dart';
import 'package:rapid_cli/src/commands/deactivate/android/android.dart';
import 'package:rapid_cli/src/core/dart_package.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/project/app_package.dart';
import 'package:rapid_cli/src/project/di_package.dart';
import 'package:rapid_cli/src/project/melos_file.dart';
import 'package:rapid_cli/src/project/platform_directory.dart';
import 'package:rapid_cli/src/project/project.dart';
import 'package:test/test.dart';
import 'package:universal_io/io.dart';

import '../../../../helpers/helpers.dart';

const expectedUsage = [
  'Removes support for Android from this project.\n'
      '\n'
      'Usage: rapid deactivate android\n'
      '-h, --help    Print this usage information.\n'
      '\n'
      'Run "rapid help" to see global options.'
];

abstract class _FlutterPubGetCommand {
  Future<void> call({required String cwd});
}

abstract class _FlutterPubRunBuildRunnerBuildDeleteConflictingOutputsCommand {
  Future<void> call({required String cwd});
}

class _MockLogger extends Mock implements Logger {}

class _MockProgress extends Mock implements Progress {}

class _MockMelosFile extends Mock implements MelosFile {}

class _MockAppPackage extends Mock implements AppPackage {}

class _MockPubspecFile extends Mock implements PubspecFile {}

class _MockMainFile extends Mock implements MainFile {}

class _MockDiPackage extends Mock implements DiPackage {}

class _MockInjectionFile extends Mock implements InjectionFile {}

class _MockPlatformDirectory extends Mock implements PlatformDirectory {}

class _MockDartPackage extends Mock implements DartPackage {}

class _MockProject extends Mock implements Project {}

class _MockFlutterPubGetCommand extends Mock implements _FlutterPubGetCommand {}

class _MockFlutterPubRunBuildRunnerBuildDeleteConflictingOutputsCommand
    extends Mock
    implements _FlutterPubRunBuildRunnerBuildDeleteConflictingOutputsCommand {}

void main() {
  group('deactivate android', () {
    Directory cwd = Directory.current;

    late Logger logger;
    late Progress progress;
    late List<String> progressLogs;

    late Project project;
    late MelosFile melosFile;
    late AppPackage appPackage;
    const appPackagePath = 'foo/bar';
    late PubspecFile appPackagePubspec;
    late MainFile mainFileDev;
    late MainFile mainFileTest;
    late MainFile mainFileProd;
    late DiPackage diPackage;
    const diPackagePath = 'bam/baz';
    late PubspecFile diPackagePubspec;
    late InjectionFile injectionFile;
    late PlatformDirectory platformDirectory;
    late DartPackage platformUiPackage;

    late FlutterPubGetCommand flutterPubGet;

    late FlutterPubRunBuildRunnerBuildDeleteConflictingOutputsCommand
        flutterPubRunBuildRunnerBuildDeleteConflictingOutputs;

    late DeactivateAndroidCommand command;

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
      platformDirectory = _MockPlatformDirectory();
      platformUiPackage = _MockDartPackage();
      when(() => project.melosFile).thenReturn(melosFile);
      when(() => project.appPackage).thenReturn(appPackage);
      when(() => project.diPackage).thenReturn(diPackage);
      when(() => project.platformDirectory(Platform.android))
          .thenReturn(platformDirectory);
      when(() => project.platformUiPackage(Platform.android))
          .thenReturn(platformUiPackage);
      when(() => project.isActivated(Platform.android)).thenReturn(true);

      flutterPubGet = _MockFlutterPubGetCommand();
      when(() => flutterPubGet(cwd: any(named: 'cwd')))
          .thenAnswer((_) async {});

      flutterPubRunBuildRunnerBuildDeleteConflictingOutputs =
          _MockFlutterPubRunBuildRunnerBuildDeleteConflictingOutputsCommand();
      when(() => flutterPubRunBuildRunnerBuildDeleteConflictingOutputs(
          cwd: any(named: 'cwd'))).thenAnswer((_) async {});

      command = DeactivateAndroidCommand(
        logger: logger,
        project: project,
        flutterPubGet: flutterPubGet,
        flutterPubRunBuildRunnerBuildDeleteConflictingOutputs:
            flutterPubRunBuildRunnerBuildDeleteConflictingOutputs,
      );
    });

    tearDown(() {
      Directory.current = cwd;
    });

    test('a is a valid alias', () {
      // Assert
      expect(command.aliases, contains('a'));
    });

    test(
      'help',
      withRunner((commandRunner, logger, printLogs) async {
        // Act
        final result =
            await commandRunner.run(['deactivate', 'android', '--help']);

        // Assert
        expect(printLogs, equals(expectedUsage));
        expect(result, equals(ExitCode.success.code));

        printLogs.clear();

        // Act
        final resultAbbr =
            await commandRunner.run(['deactivate', 'android', '-h']);

        // Assert
        expect(printLogs, equals(expectedUsage));
        expect(resultAbbr, equals(ExitCode.success.code));
      }),
    );

    test('can be instantiated without explicit logger', () {
      // Act
      final command = DeactivateAndroidCommand(project: project);

      // Assert
      expect(command, isNotNull);
    });

    test('completes successfully with correct output', () async {
      // Act
      final result = await command.run();

      // Assert
      verify(() => project.isActivated(Platform.android)).called(1);
      verify(() => logger.info('Deactivating Android ...')).called(1);
      verify(() => logger.progress('Updating package $appPackagePath '))
          .called(1);
      verify(() => appPackagePubspec.removeDependencyByPattern('android'))
          .called(1);
      verify(() => mainFileDev.removeSetupForPlatform(Platform.android))
          .called(1);
      verify(() => mainFileTest.removeSetupForPlatform(Platform.android))
          .called(1);
      verify(() => mainFileProd.removeSetupForPlatform(Platform.android))
          .called(1);
      verify(() => flutterPubGet(cwd: appPackagePath)).called(1);
      verify(() => logger.progress('Updating package $diPackagePath '))
          .called(1);
      verify(() => diPackagePubspec.removeDependencyByPattern('android'))
          .called(1);
      verify(() => injectionFile.removePackagesByPlatform(Platform.android))
          .called(1);
      verify(() => flutterPubGet(cwd: diPackagePath)).called(1);
      verify(() => flutterPubRunBuildRunnerBuildDeleteConflictingOutputs(
          cwd: diPackagePath)).called(1);
      verify(() => platformDirectory.delete()).called(1);
      verify(() => platformUiPackage.delete()).called(1);
      verify(() => logger.success('Android is now deactivated.')).called(1);
      verify(() => progress.complete()).called(2);
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

    test('exits with 78 when android is not activated', () async {
      // Arrange
      when(() => project.isActivated(Platform.android)).thenReturn(false);

      // Act
      final result = await command.run();

      // Assert
      verify(() => project.isActivated(Platform.android)).called(1);
      verify(() => logger.err('Android already deactivated.')).called(1);
      expect(result, ExitCode.config.code);
    });
  });
}
