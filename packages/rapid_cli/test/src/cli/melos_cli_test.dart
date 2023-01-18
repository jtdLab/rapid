import 'dart:async';

import 'package:mason/mason.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rapid_cli/src/cli/cli.dart';
import 'package:test/test.dart';
import 'package:universal_io/io.dart';

// TODO verify logs

class _TestProcess {
  Future<ProcessResult> run(
    String command,
    List<String> args, {
    bool runInShell = false,
    String? workingDirectory,
  }) {
    throw UnimplementedError();
  }
}

class _MockLogger extends Mock implements Logger {}

class _MockProgress extends Mock implements Progress {}

class _MockProcess extends Mock implements _TestProcess {}

class _MockProcessResult extends Mock implements ProcessResult {}

void main() {
  group('Melos', () {
    late Logger logger;
    late Progress progress;
    late List<String> progressLogs;
    late ProcessResult processResult;
    late _TestProcess process;

    setUp(() {
      logger = _MockLogger();
      progress = _MockProgress();
      progressLogs = <String>[];
      when(() => progress.complete(any())).thenAnswer((_) {
        final message = _.positionalArguments.elementAt(0) as String?;
        if (message != null) progressLogs.add(message);
      });
      when(() => logger.progress(any())).thenReturn(progress);
      processResult = _MockProcessResult();
      process = _MockProcess();
      when(() => processResult.exitCode).thenReturn(ExitCode.success.code);
      when(
        () => process.run(
          any(),
          any(),
          runInShell: any(named: 'runInShell'),
          workingDirectory: any(named: 'workingDirectory'),
        ),
      ).thenAnswer((_) async => processResult);
    });

    group('.bootstrap', () {
      test('completes when the process succeeds', () {
        ProcessOverrides.runZoned(
          () => expectLater(
            Melos.bootstrap(logger: logger),
            completes,
          ),
          runProcess: process.run,
        );
      });

/*       test('throws when process fails', () {
        when(() => processResult.exitCode).thenReturn(ExitCode.software.code);
        ProcessOverrides.runZoned(
          () => expectLater(
            Melos.bootstrap(logger: logger),
            throwsException,
          ),
          runProcess: process.run,
        );
      }); */
    });

    group('.clean', () {
      test('completes when the process succeeds', () {
        ProcessOverrides.runZoned(
          () => expectLater(
            Melos.clean(logger: logger),
            completes,
          ),
          runProcess: process.run,
        );
      });

/*       test('throws when process fails', () {
        when(() => processResult.exitCode).thenReturn(ExitCode.software.code);
        ProcessOverrides.runZoned(
          () => expectLater(
            Melos.clean(logger: logger),
            throwsException,
          ),
          runProcess: process.run,
        );
      }); */
    });
  });
}
