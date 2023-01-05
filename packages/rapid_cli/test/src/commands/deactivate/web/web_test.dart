import 'package:mason/mason.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rapid_cli/src/commands/deactivate/web/web.dart';
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
  'Removes support for Web from this project.\n'
      '\n'
      'Usage: rapid deactivate web\n'
      '-h, --help    Print this usage information.\n'
      '\n'
      'Run "rapid help" to see global options.'
];

abstract class _FlutterPubRunBuildRunnerBuildDeleteConflictingOutputsCommand {
  Future<void> call({required String cwd});
}

class _MockProgress extends Mock implements Progress {}

class _MockLogger extends Mock implements Logger {}

class _MockMelosFile extends Mock implements MelosFile {}

class _MockPubspecFile extends Mock implements PubspecFile {}

class _MockMainFile extends Mock implements MainFile {}

class _MockAppPackage extends Mock implements AppPackage {}

class _MockInjectionFile extends Mock implements InjectionFile {}

class _MockDiPackage extends Mock implements DiPackage {}

class _MockPlatformDirectory extends Mock implements PlatformDirectory {}

class _MockDartPackage extends Mock implements DartPackage {}

class _MockProject extends Mock implements Project {}

class MockFlutterPubRunBuildRunnerBuildDeleteConflictingOutputsCommand
    extends Mock
    implements _FlutterPubRunBuildRunnerBuildDeleteConflictingOutputsCommand {}

void main() {
  group('deactivate web', () {
    Directory cwd = Directory.current;

    late List<String> progressLogs;
    late Progress progress;
    late Logger logger;
    late MelosFile melosFile;
    late PubspecFile appPackagePubspec;
    late MainFile mainFileDev;
    late MainFile mainFileTest;
    late MainFile mainFileProd;
    late AppPackage appPackage;
    late PubspecFile diPackagePubspec;
    late InjectionFile injectionFile;
    late DiPackage diPackage;
    late PlatformDirectory platformDirectory;
    late DartPackage platformUiPackage;
    late Project project;
    late _FlutterPubRunBuildRunnerBuildDeleteConflictingOutputsCommand
        flutterPubRunBuildRunnerBuildDeleteConflictingOutputs;

    late DeactivateWebCommand command;

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
      appPackagePubspec = _MockPubspecFile();
      mainFileDev = _MockMainFile();
      mainFileTest = _MockMainFile();
      mainFileProd = _MockMainFile();
      appPackage = _MockAppPackage();
      when(() => appPackage.pubspecFile).thenReturn(appPackagePubspec);
      when(() => appPackage.mainFiles)
          .thenReturn({mainFileDev, mainFileTest, mainFileProd});
      diPackagePubspec = _MockPubspecFile();
      injectionFile = _MockInjectionFile();
      diPackage = _MockDiPackage();
      when(() => diPackage.path).thenReturn('foo/bar/baz');
      when(() => diPackage.pubspecFile).thenReturn(diPackagePubspec);
      when(() => diPackage.injectionFile).thenReturn(injectionFile);
      platformDirectory = _MockPlatformDirectory();
      platformUiPackage = _MockDartPackage();
      project = _MockProject();
      when(() => project.melosFile).thenReturn(melosFile);
      when(() => project.appPackage).thenReturn(appPackage);
      when(() => project.diPackage).thenReturn(diPackage);
      when(() => project.platformDirectory(Platform.web))
          .thenReturn(platformDirectory);
      when(() => project.platformUiPackage(Platform.web))
          .thenReturn(platformUiPackage);
      when(() => project.isActivated(Platform.web)).thenReturn(true);
      flutterPubRunBuildRunnerBuildDeleteConflictingOutputs =
          MockFlutterPubRunBuildRunnerBuildDeleteConflictingOutputsCommand();
      when(() => flutterPubRunBuildRunnerBuildDeleteConflictingOutputs(
          cwd: any(named: 'cwd'))).thenAnswer((_) async {});

      command = DeactivateWebCommand(
        logger: logger,
        project: project,
        flutterPubRunBuildRunnerBuildDeleteConflictingOutputs:
            flutterPubRunBuildRunnerBuildDeleteConflictingOutputs,
      );
    });

    tearDown(() {
      Directory.current = cwd;
    });

    test(
      'help',
      withRunner((commandRunner, logger, printLogs) async {
        // Act
        final result = await commandRunner.run(['deactivate', 'web', '--help']);

        // Assert
        expect(printLogs, equals(expectedUsage));
        expect(result, equals(ExitCode.success.code));

        printLogs.clear();

        // Act
        final resultAbbr = await commandRunner.run(['deactivate', 'web', '-h']);

        // Assert
        expect(printLogs, equals(expectedUsage));
        expect(resultAbbr, equals(ExitCode.success.code));
      }),
    );

    test('can be instantiated without explicit logger', () {
      // Act
      final command = DeactivateWebCommand(project: project);

      // Assert
      expect(command, isNotNull);
    });

    test('completes successfully with correct output', () async {
      // Act
      final result = await command.run();

      // Assert
      verify(() => project.isActivated(Platform.web)).called(1);
      verify(() => appPackagePubspec.removeDependencyByPattern('web'))
          .called(1);
      verify(() => mainFileDev.removeSetupCodeForPlatform(Platform.web))
          .called(1);
      verify(() => mainFileTest.removeSetupCodeForPlatform(Platform.web))
          .called(1);
      verify(() => mainFileProd.removeSetupCodeForPlatform(Platform.web))
          .called(1);
      verify(() => diPackagePubspec.removeDependencyByPattern('web')).called(1);
      verify(() => injectionFile.removePackagesByPlatform(Platform.web))
          .called(1);
      verify(() => flutterPubRunBuildRunnerBuildDeleteConflictingOutputs(
          cwd: diPackage.path)).called(1);
      verify(() => platformDirectory.delete()).called(1);
      verify(() => platformUiPackage.delete()).called(1);
      verify(() => logger.success('Web is now deactivated.')).called(1);
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

    test('exits with 78 when web is not activated', () async {
      // Arrange
      when(() => project.isActivated(Platform.web)).thenReturn(false);

      // Act
      final result = await command.run();

      // Assert
      verify(() => project.isActivated(Platform.web)).called(1);
      verify(() => logger.err('Web already deactivated.')).called(1);
      expect(result, ExitCode.config.code);
    });
  });
}
