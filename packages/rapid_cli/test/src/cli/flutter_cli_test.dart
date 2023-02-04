import 'dart:async';

import 'package:mason/mason.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rapid_cli/src/cli/cli.dart';
import 'package:test/test.dart';
import 'package:universal_io/io.dart';

import '../mocks.dart';

void main() {
  group('Flutter', () {
    late Logger logger;
    late Progress progress;
    late List<String> progressLogs;
    late StartProcess startProcess;
    late Process process;

    setUp(() {
      logger = MockLogger();
      progress = MockProgress();
      progressLogs = <String>[];
      when(() => progress.complete(any())).thenAnswer((_) {
        final message = _.positionalArguments.elementAt(0) as String?;
        if (message != null) progressLogs.add(message);
      });
      when(() => logger.progress(any())).thenReturn(progress);
      startProcess = MockStartProcess();
      process = MockProcess();
      when(() => process.pid).thenReturn(88);
      when(() => process.stdout).thenAnswer((_) => Stream.empty());
      when(() => process.stderr).thenAnswer((_) => Stream.empty());
      when(() => process.exitCode)
          .thenAnswer((_) async => ExitCode.success.code);
      when(
        () => startProcess(
          any(),
          any(),
          runInShell: any(named: 'runInShell'),
          workingDirectory: any(named: 'workingDirectory'),
        ),
      ).thenAnswer((_) async => process);
    });

    group('.installed', () {
      test('returns true when the process succeeds', () {
        ProcessOverrides.runZoned(
          () => expect(
            Flutter.installed(logger: logger),
            completion(true),
          ),
          startProcess: startProcess,
        );
      });

      test('returns false when process fails', () {
        when(() => process.exitCode)
            .thenAnswer((_) async => ExitCode.software.code);
        ProcessOverrides.runZoned(
          () => expect(
            Flutter.installed(logger: logger),
            completion(false),
          ),
          startProcess: startProcess,
        );
      });
    });

    group('.pubGet', () {
      test('completes when the process succeeds', () async {
        await ProcessOverrides.runZoned(
          () => expectLater(
            Flutter.pubGet(logger: logger),
            completes,
          ),
          startProcess: startProcess,
        );
        verify(() => logger.progress('Running "flutter pub get" in . '))
            .called(1);
        verify(() => progress.complete()).called(1);
      });

      test('throws when process fails', () async {
        when(() => process.exitCode)
            .thenAnswer((_) async => ExitCode.software.code);
        await ProcessOverrides.runZoned(
          () => expectLater(
            Flutter.pubGet(logger: logger),
            throwsException,
          ),
          startProcess: startProcess,
        );
        verify(() => logger.progress('Running "flutter pub get" in . '))
            .called(1);
        verify(() => progress.fail()).called(1);
      });
    });

    group('.configEnableAndroid', () {
      test('completes when the process succeeds', () async {
        await ProcessOverrides.runZoned(
          () => expectLater(
            Flutter.configEnableAndroid(logger: logger),
            completes,
          ),
          startProcess: startProcess,
        );
        verify(() =>
                logger.progress('Running "flutter config --enable-android"'))
            .called(1);
        verify(() => progress.complete()).called(1);
      });

      test('throws when process fails', () async {
        when(() => process.exitCode)
            .thenAnswer((_) async => ExitCode.software.code);
        await ProcessOverrides.runZoned(
          () => expectLater(
            Flutter.configEnableAndroid(logger: logger),
            throwsException,
          ),
          startProcess: startProcess,
        );
        verify(() =>
                logger.progress('Running "flutter config --enable-android"'))
            .called(1);
        verify(() => progress.fail()).called(1);
      });
    });

    group('.configEnableIos', () {
      test('completes when the process succeeds', () async {
        await ProcessOverrides.runZoned(
          () => expectLater(
            Flutter.configEnableIos(logger: logger),
            completes,
          ),
          startProcess: startProcess,
        );
        verify(() => logger.progress('Running "flutter config --enable-ios"'))
            .called(1);
        verify(() => progress.complete()).called(1);
      });

      test('throws when process fails', () async {
        when(() => process.exitCode)
            .thenAnswer((_) async => ExitCode.software.code);
        await ProcessOverrides.runZoned(
          () => expectLater(
            Flutter.configEnableIos(logger: logger),
            throwsException,
          ),
          startProcess: startProcess,
        );
        verify(() => logger.progress('Running "flutter config --enable-ios"'))
            .called(1);
        verify(() => progress.fail()).called(1);
      });
    });

    group('.configEnableLinux', () {
      test('completes when the process succeeds', () async {
        await ProcessOverrides.runZoned(
          () => expectLater(
            Flutter.configEnableLinux(logger: logger),
            completes,
          ),
          startProcess: startProcess,
        );
        verify(() => logger.progress(
            'Running "flutter config --enable-linux-desktop"')).called(1);
        verify(() => progress.complete()).called(1);
      });

      test('throws when process fails', () async {
        when(() => process.exitCode)
            .thenAnswer((_) async => ExitCode.software.code);
        await ProcessOverrides.runZoned(
          () => expectLater(
            Flutter.configEnableLinux(logger: logger),
            throwsException,
          ),
          startProcess: startProcess,
        );
        verify(() => logger.progress(
            'Running "flutter config --enable-linux-desktop"')).called(1);
        verify(() => progress.fail()).called(1);
      });
    });

    group('.configEnableMacos', () {
      test('completes when the process succeeds', () async {
        await ProcessOverrides.runZoned(
          () => expectLater(
            Flutter.configEnableMacos(logger: logger),
            completes,
          ),
          startProcess: startProcess,
        );
        verify(() => logger.progress(
            'Running "flutter config --enable-macos-desktop"')).called(1);
        verify(() => progress.complete()).called(1);
      });

      test('throws when process fails', () async {
        when(() => process.exitCode)
            .thenAnswer((_) async => ExitCode.software.code);
        await ProcessOverrides.runZoned(
          () => expectLater(
            Flutter.configEnableMacos(logger: logger),
            throwsException,
          ),
          startProcess: startProcess,
        );
        verify(() => logger.progress(
            'Running "flutter config --enable-macos-desktop"')).called(1);
        verify(() => progress.fail()).called(1);
      });
    });

    group('.configEnableWeb', () {
      test('completes when the process succeeds', () async {
        await ProcessOverrides.runZoned(
          () => expectLater(
            Flutter.configEnableWeb(logger: logger),
            completes,
          ),
          startProcess: startProcess,
        );
        verify(() => logger.progress('Running "flutter config --enable-web"'))
            .called(1);
        verify(() => progress.complete()).called(1);
      });

      test('throws when process fails', () async {
        when(() => process.exitCode)
            .thenAnswer((_) async => ExitCode.software.code);
        await ProcessOverrides.runZoned(
          () => expectLater(
            Flutter.configEnableWeb(logger: logger),
            throwsException,
          ),
          startProcess: startProcess,
        );
        verify(() => logger.progress('Running "flutter config --enable-web"'))
            .called(1);
        verify(() => progress.fail()).called(1);
      });
    });

    group('.configEnableWindows', () {
      test('completes when the process succeeds', () async {
        await ProcessOverrides.runZoned(
          () => expectLater(
            Flutter.configEnableWindows(logger: logger),
            completes,
          ),
          startProcess: startProcess,
        );
        verify(() => logger.progress(
            'Running "flutter config --enable-windows-desktop"')).called(1);
        verify(() => progress.complete()).called(1);
      });

      test('throws when process fails', () async {
        when(() => process.exitCode)
            .thenAnswer((_) async => ExitCode.software.code);
        await ProcessOverrides.runZoned(
          () => expectLater(
            Flutter.configEnableWindows(logger: logger),
            throwsException,
          ),
          startProcess: startProcess,
        );
        verify(() => logger.progress(
            'Running "flutter config --enable-windows-desktop"')).called(1);
        verify(() => progress.fail()).called(1);
      });
    });

    group('.pubRunBuildRunnerBuildDeleteConflictingOutputs', () {
      test('completes when the process succeeds', () async {
        await ProcessOverrides.runZoned(
          () => expectLater(
            Flutter.pubRunBuildRunnerBuildDeleteConflictingOutputs(
              logger: logger,
            ),
            completes,
          ),
          startProcess: startProcess,
        );
        verify(() => logger.progress(
                'Running "flutter pub run build_runner build --delete-conflicting-outputs" in . '))
            .called(1);
        verify(() => progress.complete()).called(1);
      });

      test('throws when process fails', () async {
        when(() => process.exitCode)
            .thenAnswer((_) async => ExitCode.software.code);
        await ProcessOverrides.runZoned(
          () => expectLater(
            Flutter.pubRunBuildRunnerBuildDeleteConflictingOutputs(
              logger: logger,
            ),
            throwsException,
          ),
          startProcess: startProcess,
        );
        verify(() => logger.progress(
                'Running "flutter pub run build_runner build --delete-conflicting-outputs" in . '))
            .called(1);
        verify(() => progress.fail()).called(1);
      });
    });

    group('.genl10n', () {
      test('completes when the process succeeds', () async {
        await ProcessOverrides.runZoned(
          () => expectLater(
            Flutter.genl10n(logger: logger),
            completes,
          ),
          startProcess: startProcess,
        );
        verify(() => logger.progress('Running "flutter gen-l10n" in . '))
            .called(1);
        verify(() => progress.complete()).called(1);
      });

      test('throws when process fails', () async {
        when(() => process.exitCode)
            .thenAnswer((_) async => ExitCode.software.code);
        await ProcessOverrides.runZoned(
          () => expectLater(
            Flutter.genl10n(logger: logger),
            throwsException,
          ),
          startProcess: startProcess,
        );
        verify(() => logger.progress('Running "flutter gen-l10n" in . '))
            .called(1);
        verify(() => progress.fail()).called(1);
      });
    });
  });
}
