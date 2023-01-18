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
  group('Flutter', () {
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

    group('.installed', () {
      test('returns true when the process succeeds', () {
        ProcessOverrides.runZoned(
          () => expect(
            Flutter.installed(logger: logger),
            completion(true),
          ),
          runProcess: process.run,
        );
      });

      test('returns false when process fails', () {
        when(() => processResult.exitCode).thenReturn(ExitCode.software.code);
        ProcessOverrides.runZoned(
          () => expect(
            Flutter.installed(logger: logger),
            completion(false),
          ),
          runProcess: process.run,
        );
      });
    });

    group('.pubGet', () {
      test('completes when the process succeeds', () {
        ProcessOverrides.runZoned(
          () => expectLater(
            Flutter.pubGet(logger: logger),
            completes,
          ),
          runProcess: process.run,
        );
      });

/*       test('throws when process fails', () {
        when(() => processResult.exitCode).thenReturn(ExitCode.software.code);
        ProcessOverrides.runZoned(
          () => expectLater(
            Flutter.pubGet(logger: logger),
            throwsException,
          ),
          runProcess: process.run,
        );
      }); */
    });

    group('.configEnableAndroid', () {
      test('completes when the process succeeds', () {
        ProcessOverrides.runZoned(
          () => expectLater(
            Flutter.configEnableAndroid(logger: logger),
            completes,
          ),
          runProcess: process.run,
        );
      });

/*       test('throws when process fails', () {
        when(() => processResult.exitCode).thenReturn(ExitCode.software.code);
        ProcessOverrides.runZoned(
          () => expectLater(
            Flutter.configEnableAndroid(logger: logger),
            throwsException,
          ),
          runProcess: process.run,
        );
      }); */
    });

    group('.configEnableIos', () {
      test('completes when the process succeeds', () {
        ProcessOverrides.runZoned(
          () => expectLater(
            Flutter.configEnableIos(logger: logger),
            completes,
          ),
          runProcess: process.run,
        );
      });

/*       test('throws when process fails', () {
        when(() => processResult.exitCode).thenReturn(ExitCode.software.code);
        ProcessOverrides.runZoned(
          () => expectLater(
            Flutter.configEnableIos(logger: logger),
            throwsException,
          ),
          runProcess: process.run,
        );
      }); */
    });

    group('.configEnableLinux', () {
      test('completes when the process succeeds', () {
        ProcessOverrides.runZoned(
          () => expectLater(
            Flutter.configEnableLinux(logger: logger),
            completes,
          ),
          runProcess: process.run,
        );
      });

/*       test('throws when process fails', () {
        when(() => processResult.exitCode).thenReturn(ExitCode.software.code);
        ProcessOverrides.runZoned(
          () => expectLater(
            Flutter.configEnableLinux(logger: logger),
            throwsException,
          ),
          runProcess: process.run,
        );
      }); */
    });

    group('.configEnableMacos', () {
      test('completes when the process succeeds', () {
        ProcessOverrides.runZoned(
          () => expectLater(
            Flutter.configEnableMacos(logger: logger),
            completes,
          ),
          runProcess: process.run,
        );
      });

/*       test('throws when process fails', () {
        when(() => processResult.exitCode).thenReturn(ExitCode.software.code);
        ProcessOverrides.runZoned(
          () => expectLater(
            Flutter.configEnableMacos(logger: logger),
            throwsException,
          ),
          runProcess: process.run,
        );
      }); */
    });

    group('.configEnableWeb', () {
      test('completes when the process succeeds', () {
        ProcessOverrides.runZoned(
          () => expectLater(
            Flutter.configEnableWeb(logger: logger),
            completes,
          ),
          runProcess: process.run,
        );
      });

/*       test('throws when process fails', () {
        when(() => processResult.exitCode).thenReturn(ExitCode.software.code);
        ProcessOverrides.runZoned(
          () => expectLater(
            Flutter.configEnableWeb(logger: logger),
            throwsException,
          ),
          runProcess: process.run,
        );
      }); */
    });

    group('.configEnableWindows', () {
      test('completes when the process succeeds', () {
        ProcessOverrides.runZoned(
          () => expectLater(
            Flutter.configEnableWindows(logger: logger),
            completes,
          ),
          runProcess: process.run,
        );
      });

/*       test('throws when process fails', () {
        when(() => processResult.exitCode).thenReturn(ExitCode.software.code);
        ProcessOverrides.runZoned(
          () => expectLater(
            Flutter.configEnableWindows(logger: logger),
            throwsException,
          ),
          runProcess: process.run,
        );
      }); */
    });

    group('.pubRunBuildRunnerBuildDeleteConflictingOutputs', () {
      test('completes when the process succeeds', () {
        ProcessOverrides.runZoned(
          () => expectLater(
            Flutter.pubRunBuildRunnerBuildDeleteConflictingOutputs(
              logger: logger,
            ),
            completes,
          ),
          runProcess: process.run,
        );
      });

/*       test('throws when process fails', () {
        when(() => processResult.exitCode).thenReturn(ExitCode.software.code);
        ProcessOverrides.runZoned(
          () => expectLater(
            Flutter.pubRunBuildRunnerBuildDeleteConflictingOutputs(
              logger: logger,
            ),
            throwsException,
          ),
          runProcess: process.run,
        );
      }); */
    });

    group('.genl10n', () {
      test('completes when the process succeeds', () {
        ProcessOverrides.runZoned(
          () => expectLater(
            Flutter.genl10n(logger: logger),
            completes,
          ),
          runProcess: process.run,
        );
      });

/*       test('throws when process fails', () {
        when(() => processResult.exitCode).thenReturn(ExitCode.software.code);
        ProcessOverrides.runZoned(
          () => expectLater(
            Flutter.genl10n(logger: logger),
            throwsException,
          ),
          runProcess: process.run,
        );
      }); */
    });

    group('.formatFix', () {
      test('completes when the process succeeds', () {
        ProcessOverrides.runZoned(
          () => expectLater(
            Flutter.formatFix(logger: logger),
            completes,
          ),
          runProcess: process.run,
        );
      });

/*       test('throws when process fails', () {
        when(() => processResult.exitCode).thenReturn(ExitCode.software.code);
        ProcessOverrides.runZoned(
          () => expectLater(
            Flutter.formatFix(logger: logger),
            throwsException,
          ),
          runProcess: process.run,
        );
      }); */
    });
  });
}
