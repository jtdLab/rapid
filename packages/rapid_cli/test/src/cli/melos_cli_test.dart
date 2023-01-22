import 'dart:async';

import 'package:mason/mason.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rapid_cli/src/cli/cli.dart';
import 'package:test/test.dart';
import 'package:universal_io/io.dart';

abstract class _StartProcess {
  Future<Process> call(
    String command,
    List<String> args, {
    bool runInShell = false,
    String? workingDirectory,
  });
}

class _MockLogger extends Mock implements Logger {}

class _MockProgress extends Mock implements Progress {}

class _MockStartProcess extends Mock implements _StartProcess {}

class _MockProcess extends Mock implements Process {}

void main() {
  group('Melos', () {
    late Logger logger;
    late Progress progress;
    late List<String> progressLogs;
    late _StartProcess startProcess;
    late Process process;

    setUp(() {
      logger = _MockLogger();
      progress = _MockProgress();
      progressLogs = <String>[];
      when(() => progress.complete(any())).thenAnswer((_) {
        final message = _.positionalArguments.elementAt(0) as String?;
        if (message != null) progressLogs.add(message);
      });
      when(() => logger.progress(any())).thenReturn(progress);
      startProcess = _MockStartProcess();
      process = _MockProcess();
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

    group('.bootstrap', () {
      test('completes when the process succeeds', () async {
        await ProcessOverrides.runZoned(
          () => expectLater(
            Melos.bootstrap(logger: logger),
            completes,
          ),
          startProcess: startProcess,
        );
        verify(() => logger.progress('Running "melos bootstrap" in . '))
            .called(1);
        verify(() => progress.complete()).called(1);
      });

      test('throws when process fails', () async {
        when(() => process.exitCode)
            .thenAnswer((_) async => ExitCode.software.code);
        await ProcessOverrides.runZoned(
          () => expectLater(
            Melos.bootstrap(logger: logger),
            throwsException,
          ),
          startProcess: startProcess,
        );
        verify(() => logger.progress('Running "melos bootstrap" in . '))
            .called(1);
        verify(() => progress.fail()).called(1);
      });
    });

    group('.bootstrap (scoped)', () {
      test('completes when the process succeeds', () async {
        await ProcessOverrides.runZoned(
          () => expectLater(
            Melos.bootstrap(scope: 'foo', logger: logger),
            completes,
          ),
          startProcess: startProcess,
        );
        verify(() =>
                logger.progress('Running "melos bootstrap --scope foo" in . '))
            .called(1);
        verify(() => progress.complete()).called(1);
      });

      test('throws when process fails', () async {
        when(() => process.exitCode)
            .thenAnswer((_) async => ExitCode.software.code);
        await ProcessOverrides.runZoned(
          () => expectLater(
            Melos.bootstrap(scope: 'foo', logger: logger),
            throwsException,
          ),
          startProcess: startProcess,
        );
        verify(() =>
                logger.progress('Running "melos bootstrap --scope foo" in . '))
            .called(1);
        verify(() => progress.fail()).called(1);
      });
    });

    group('.clean', () {
      test('completes when the process succeeds', () async {
        await ProcessOverrides.runZoned(
          () => expectLater(
            Melos.clean(logger: logger),
            completes,
          ),
          startProcess: startProcess,
        );
        verify(() => logger.progress('Running "melos clean" in . ')).called(1);
        verify(() => progress.complete()).called(1);
      });

      test('throws when process fails', () async {
        when(() => process.exitCode)
            .thenAnswer((_) async => ExitCode.software.code);
        await ProcessOverrides.runZoned(
          () => expectLater(
            Melos.clean(logger: logger),
            throwsException,
          ),
          startProcess: startProcess,
        );
        verify(() => logger.progress('Running "melos clean" in . ')).called(1);
        verify(() => progress.fail()).called(1);
      });
    });
  });
}
