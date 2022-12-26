import 'dart:async';

import 'package:mason/mason.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rapid_cli/src/cli/cli.dart';
import 'package:test/test.dart';
import 'package:universal_io/io.dart';

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

class _MockProcess extends Mock implements _TestProcess {}

class _MockProcessResult extends Mock implements ProcessResult {}

void main() {
  group('Flutter', () {
    late ProcessResult processResult;
    late _TestProcess process;

    setUp(() {
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

    group('.installed', () {
      test('returns true when the process succeeds', () {
        ProcessOverrides.runZoned(
          () => expect(Flutter.installed(), completion(true)),
          runProcess: process.run,
        );
      });

      test('returns false when process fails', () {
        when(() => processResult.exitCode).thenReturn(ExitCode.software.code);
        ProcessOverrides.runZoned(
          () => expect(Flutter.installed(), completion(false)),
          runProcess: process.run,
        );
      });
    });

    group('.pubGet', () {
      test('completes when the process succeeds', () {
        ProcessOverrides.runZoned(
          () => expectLater(Flutter.pubGet(), completes),
          runProcess: process.run,
        );
      });

      test('throws when process fails', () {
        when(() => processResult.exitCode).thenReturn(ExitCode.software.code);
        ProcessOverrides.runZoned(
          () => expectLater(Flutter.pubGet(), throwsException),
          runProcess: process.run,
        );
      });
    });

    group('.configEnableAndroid', () {
      test('completes when the process succeeds', () {
        ProcessOverrides.runZoned(
          () => expectLater(Flutter.configEnableAndroid(), completes),
          runProcess: process.run,
        );
      });

      test('throws when process fails', () {
        when(() => processResult.exitCode).thenReturn(ExitCode.software.code);
        ProcessOverrides.runZoned(
          () => expectLater(Flutter.configEnableAndroid(), throwsException),
          runProcess: process.run,
        );
      });
    });

    group('.configEnableIos', () {
      test('completes when the process succeeds', () {
        ProcessOverrides.runZoned(
          () => expectLater(Flutter.configEnableIos(), completes),
          runProcess: process.run,
        );
      });

      test('throws when process fails', () {
        when(() => processResult.exitCode).thenReturn(ExitCode.software.code);
        ProcessOverrides.runZoned(
          () => expectLater(Flutter.configEnableIos(), throwsException),
          runProcess: process.run,
        );
      });
    });

    group('.configEnableLinux', () {
      test('completes when the process succeeds', () {
        ProcessOverrides.runZoned(
          () => expectLater(Flutter.configEnableLinux(), completes),
          runProcess: process.run,
        );
      });

      test('throws when process fails', () {
        when(() => processResult.exitCode).thenReturn(ExitCode.software.code);
        ProcessOverrides.runZoned(
          () => expectLater(Flutter.configEnableLinux(), throwsException),
          runProcess: process.run,
        );
      });
    });

    group('.configEnableMacos', () {
      test('completes when the process succeeds', () {
        ProcessOverrides.runZoned(
          () => expectLater(Flutter.configEnableMacos(), completes),
          runProcess: process.run,
        );
      });

      test('throws when process fails', () {
        when(() => processResult.exitCode).thenReturn(ExitCode.software.code);
        ProcessOverrides.runZoned(
          () => expectLater(Flutter.configEnableMacos(), throwsException),
          runProcess: process.run,
        );
      });
    });

    group('.configEnableWeb', () {
      test('completes when the process succeeds', () {
        ProcessOverrides.runZoned(
          () => expectLater(Flutter.configEnableWeb(), completes),
          runProcess: process.run,
        );
      });

      test('throws when process fails', () {
        when(() => processResult.exitCode).thenReturn(ExitCode.software.code);
        ProcessOverrides.runZoned(
          () => expectLater(Flutter.configEnableWeb(), throwsException),
          runProcess: process.run,
        );
      });
    });

    group('.configEnableWindows', () {
      test('completes when the process succeeds', () {
        ProcessOverrides.runZoned(
          () => expectLater(Flutter.configEnableWindows(), completes),
          runProcess: process.run,
        );
      });

      test('throws when process fails', () {
        when(() => processResult.exitCode).thenReturn(ExitCode.software.code);
        ProcessOverrides.runZoned(
          () => expectLater(Flutter.configEnableWindows(), throwsException),
          runProcess: process.run,
        );
      });
    });

    group('.pubRunBuildRunnerBuildDeleteConflictingOutputs', () {
      test('completes when the process succeeds', () {
        ProcessOverrides.runZoned(
          () => expectLater(
            Flutter.pubRunBuildRunnerBuildDeleteConflictingOutputs(),
            completes,
          ),
          runProcess: process.run,
        );
      });

      test('throws when process fails', () {
        when(() => processResult.exitCode).thenReturn(ExitCode.software.code);
        ProcessOverrides.runZoned(
          () => expectLater(
            Flutter.pubRunBuildRunnerBuildDeleteConflictingOutputs(),
            throwsException,
          ),
          runProcess: process.run,
        );
      });
    });
  });
}
