import 'dart:async';

import 'package:mason/mason.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rapid_cli/src/command_runner.dart';
import 'package:rapid_cli/src/core/melos_file.dart';
import 'package:rapid_cli/src/core/project.dart';

class _MockLogger extends Mock implements Logger {}

class _MockMelosFile extends Mock implements MelosFile {}

class _MockProject extends Mock implements Project {}

class _MockProgress extends Mock implements Progress {}

void Function() _overridePrint(void Function(List<String>) fn) {
  return () {
    final printLogs = <String>[];
    final spec = ZoneSpecification(
      print: (_, __, ___, String msg) {
        printLogs.add(msg);
      },
    );

    return Zone.current
        .fork(specification: spec)
        .run<void>(() => fn(printLogs));
  };
}

void Function() withRunner(
  FutureOr<void> Function(
    RapidCommandRunner commandRunner,
    Logger logger,
    Project project,
    List<String> printLogs,
  )
      runnerFn,
) {
  return _overridePrint((printLogs) async {
    final logger = _MockLogger();
    final melosFile = _MockMelosFile();
    when(() => melosFile.name).thenReturn('test_app');
    when(() => melosFile.exists()).thenReturn(true);
    final project = _MockProject();
    when(() => project.melosFile).thenReturn(melosFile);
    final progress = _MockProgress();
    final progressLogs = <String>[];
    final commandRunner = RapidCommandRunner(
      logger: logger,
      project: project,
    );

    when(() => progress.complete(any())).thenAnswer((_) {
      final message = _.positionalArguments.elementAt(0) as String?;
      if (message != null) progressLogs.add(message);
    });
    when(() => logger.progress(any())).thenReturn(progress);

    await runnerFn(commandRunner, logger, project, printLogs);
  });
}
