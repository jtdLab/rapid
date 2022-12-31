import 'package:mason/mason.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rapid_cli/src/commands/deactivate/android/android.dart';
import 'package:rapid_cli/src/core/dart_package.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/project/app_package.dart';
import 'package:rapid_cli/src/project/di_package.dart';
import 'package:rapid_cli/src/project/project.dart';
import 'package:test/test.dart';
import 'package:universal_io/io.dart';

import '../../../../helpers/helpers.dart';

const expectedUsage = [
  // ignore: no_adjacent_strings_in_list
  'Removes support for Android from this project.\n'
      '\n'
      'Usage: rapid deactivate android\n'
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

class MockDirectory extends Mock implements Directory {}

class MockDartPackage extends Mock implements DartPackage {}

class MockProject extends Mock implements Project {}

class MockFlutterPubRunBuildRunnerBuildDeleteConflictingOutputsCommand
    extends Mock
    implements FlutterPubRunBuildRunnerBuildDeleteConflictingOutputsCommand {}

void main() {
  group('android', () {
    Directory cwd = Directory.current;

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
    late Directory platformDirectory;
    late DartPackage platformUiPackage;
    late Project project;
    late FlutterPubRunBuildRunnerBuildDeleteConflictingOutputsCommand
        flutterPubRunBuildRunnerBuildDeleteConflictingOutputs;

    late AndroidCommand command;

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
      diPackage = MockDiPackage();
      when(() => diPackage.path).thenReturn('foo/bar/baz');
      when(() => diPackage.pubspecFile).thenReturn(diPackagePubspec);
      when(() => diPackage.injectionFile).thenReturn(injectionFile);
      platformDirectory = MockDirectory();
      platformUiPackage = MockDartPackage();
      project = MockProject();
      when(() => project.appPackage).thenReturn(appPackage);
      when(() => project.diPackage).thenReturn(diPackage);
      when(() => project.platformDirectory(Platform.android))
          .thenReturn(platformDirectory);
      when(() => project.platformUiPackage(Platform.android))
          .thenReturn(platformUiPackage);
      when(() => project.isActivated(Platform.android)).thenReturn(true);
      flutterPubRunBuildRunnerBuildDeleteConflictingOutputs =
          MockFlutterPubRunBuildRunnerBuildDeleteConflictingOutputsCommand();
      when(() => flutterPubRunBuildRunnerBuildDeleteConflictingOutputs(
          cwd: any(named: 'cwd'))).thenAnswer((_) async {});

      command = AndroidCommand(
        logger: logger,
        project: project,
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
      withRunner((commandRunner, logger, project, printLogs) async {
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
      final command = AndroidCommand(project: project);

      // Assert
      expect(command, isNotNull);
    });

    test('completes successfully with correct output', () async {
      // Act
      final result = await command.run();

      // Assert
      verify(() => project.isActivated(Platform.android)).called(1);
      verify(() => appPackagePubspec.removeDependencyByPattern('android'))
          .called(1);
      verify(() => mainFileDev.removePlatform(Platform.android)).called(1);
      verify(() => mainFileTest.removePlatform(Platform.android)).called(1);
      verify(() => mainFileProd.removePlatform(Platform.android)).called(1);
      verify(() => diPackagePubspec.removeDependencyByPattern('android'))
          .called(1);
      verify(() => injectionFile.removePlatform(Platform.android)).called(1);
      verify(() => flutterPubRunBuildRunnerBuildDeleteConflictingOutputs(
          cwd: diPackage.path)).called(1);
      verify(() => platformDirectory.deleteSync(recursive: true)).called(1);
      verify(() => platformUiPackage.delete()).called(1);
      verify(() => logger.success('Android is now deactivated.')).called(1);
      expect(result, ExitCode.success.code);
    });

    test('completes with correct output when android is not activated',
        () async {
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