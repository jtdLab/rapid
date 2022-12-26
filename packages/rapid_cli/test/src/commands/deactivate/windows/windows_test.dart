import 'package:mason/mason.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rapid_cli/src/commands/deactivate/windows/windows.dart';
import 'package:rapid_cli/src/core/app_package.dart';
import 'package:rapid_cli/src/core/di_package.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/core/platform_dir.dart';
import 'package:rapid_cli/src/core/platform_ui_package.dart';
import 'package:rapid_cli/src/core/project.dart';
import 'package:rapid_cli/src/core/project_package.dart';
import 'package:test/test.dart';
import 'package:universal_io/io.dart';

import '../../../../helpers/helpers.dart';

const expectedUsage = [
  // ignore: no_adjacent_strings_in_list
  'Removes support for Windows from this project.\n'
      '\n'
      'Usage: rapid deactivate windows\n'
      '-h, --help    Print this usage information.\n'
      '\n'
      'Run "rapid help" to see global options.'
];

abstract class FlutterPubRunBuildRunnerBuildDeleteConflictingOutputsCommand {
  Future<void> call({required String cwd});
}

class MockProgress extends Mock implements Progress {}

class MockLogger extends Mock implements Logger {}

class MockPubspecFile extends Mock implements PubspecFile {}

class MockMainFile extends Mock implements MainFile {}

class MockAppPackage extends Mock implements AppPackage {}

class MockInjectionFile extends Mock implements InjectionFile {}

class MockDiPackage extends Mock implements DiPackage {}

class MockPlatformDir extends Mock implements PlatformDir {}

class MockPlatformUiPackage extends Mock implements PlatformUiPackage {}

class MockProject extends Mock implements Project {}

class MockFlutterPubRunBuildRunnerBuildDeleteConflictingOutputsCommand
    extends Mock
    implements FlutterPubRunBuildRunnerBuildDeleteConflictingOutputsCommand {}

void main() {
  group('windows', () {
    Directory cwd = Directory.current;

    const package1 = 'foo_bar';
    const package2 = 'baz_boo';

    late List<String> progressLogs;
    late Progress progress;
    late Logger logger;
    late PubspecFile appPackagePubspec;
    late MainFile mainFileDev;
    late MainFile mainFileTest;
    late MainFile mainFileProd;
    late AppPackage appPackage;
    late PubspecFile diPackagePubspec;
    late InjectionFile injectionFile;
    late DiPackage diPackage;
    late PlatformDir platformDir;
    late PlatformUiPackage platformUiPackage;
    late Project project;
    late FlutterPubRunBuildRunnerBuildDeleteConflictingOutputsCommand
        flutterPubRunBuildRunnerBuildDeleteConflictingOutputs;

    late WindowsCommand command;

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
      appPackagePubspec = MockPubspecFile();
      mainFileDev = MockMainFile();
      mainFileTest = MockMainFile();
      mainFileProd = MockMainFile();
      appPackage = MockAppPackage();
      when(() => appPackage.pubspecFile).thenReturn(appPackagePubspec);
      when(() => appPackage.mainFiles)
          .thenReturn({mainFileDev, mainFileTest, mainFileProd});
      diPackagePubspec = MockPubspecFile();
      injectionFile = MockInjectionFile();
      when(() => injectionFile.getPackagesByPlatform(Platform.windows))
          .thenReturn([package1, package2]);
      diPackage = MockDiPackage();
      when(() => diPackage.path).thenReturn('foo/bar/baz');
      when(() => diPackage.pubspecFile).thenReturn(diPackagePubspec);
      when(() => diPackage.injectionFile).thenReturn(injectionFile);
      platformDir = MockPlatformDir();
      platformUiPackage = MockPlatformUiPackage();
      project = MockProject();
      when(() => project.appPackage).thenReturn(appPackage);
      when(() => project.diPackage).thenReturn(diPackage);
      when(() => project.platformDir(Platform.windows)).thenReturn(platformDir);
      when(() => project.platformUiPackage(Platform.windows))
          .thenReturn(platformUiPackage);
      when(() => project.isActivated(Platform.windows)).thenReturn(true);
      flutterPubRunBuildRunnerBuildDeleteConflictingOutputs =
          MockFlutterPubRunBuildRunnerBuildDeleteConflictingOutputsCommand();
      when(() => flutterPubRunBuildRunnerBuildDeleteConflictingOutputs(
          cwd: any(named: 'cwd'))).thenAnswer((_) async {});

      command = WindowsCommand(
        logger: logger,
        project: project,
        flutterPubRunBuildRunnerBuildDeleteConflictingOutputs:
            flutterPubRunBuildRunnerBuildDeleteConflictingOutputs,
      );
    });

    tearDown(() {
      Directory.current = cwd;
    });

    test('win is a valid alias', () {
      // Assert
      expect(command.aliases, contains('win'));
    });

    test(
      'help',
      withRunner((commandRunner, logger, project, printLogs) async {
        // Act
        final result = await commandRunner.run(
          ['deactivate', 'windows', '--help'],
        );

        // Assert
        expect(printLogs, equals(expectedUsage));
        expect(result, equals(ExitCode.success.code));

        printLogs.clear();

        // Act
        final resultAbbr = await commandRunner.run(
          ['deactivate', 'windows', '-h'],
        );

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
      verify(() => project.isActivated(Platform.windows)).called(1);
      verify(() => appPackagePubspec.removeDependencyByPattern('windows'))
          .called(1);
      verify(() => mainFileDev.removePlatform(Platform.windows)).called(1);
      verify(() => mainFileTest.removePlatform(Platform.windows)).called(1);
      verify(() => mainFileProd.removePlatform(Platform.windows)).called(1);
      verify(() => diPackagePubspec.removeDependencyByPattern('windows'))
          .called(1);
      verify(() => injectionFile.getPackagesByPlatform(Platform.windows))
          .called(1);
      verify(() => injectionFile.removePackage(package1)).called(1);
      verify(() => injectionFile.removePackage(package2)).called(1);
      verify(() => flutterPubRunBuildRunnerBuildDeleteConflictingOutputs(
          cwd: diPackage.path)).called(1);
      verify(() => platformDir.delete()).called(1);
      verify(() => platformUiPackage.delete()).called(1);
      verify(() => logger.success('Windows is now deactivated.')).called(1);
      expect(result, ExitCode.success.code);
    });

    test('completes with correct output when windows is not activated',
        () async {
      // Arrange
      when(() => project.isActivated(Platform.windows)).thenReturn(false);

      // Act
      final result = await command.run();

      // Assert
      verify(() => project.isActivated(Platform.windows)).called(1);
      verify(() => logger.err('Windows already deactivated.')).called(1);
      expect(result, ExitCode.config.code);
    });
  });
}
