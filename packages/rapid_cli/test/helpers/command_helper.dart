import 'dart:async';

import 'package:mason/mason.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rapid_cli/src/command_runner.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/project/melos_file.dart';
import 'package:rapid_cli/src/project/project.dart';

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

/// Runs [fn] in a test environment.
///
/// This is used to implement negative testing of commands
/// that do not depend on a project to be available.
///
/// E.g help, paramter validation and usage exceptions.
void Function() withRunner(
  FutureOr<void> Function(
    RapidCommandRunner commandRunner,
    Logger logger,
    List<String> printLogs,
  )
      fn,
) {
  return _overridePrint((printLogs) async {
    final logger = _MockLogger();

    final progress = _MockProgress();
    final progressLogs = <String>[];
    final commandRunner = RapidCommandRunner(
      logger: logger,
    );

    when(() => progress.complete(any())).thenAnswer((_) {
      final message = _.positionalArguments.elementAt(0) as String?;
      if (message != null) progressLogs.add(message);
    });
    when(() => logger.progress(any())).thenReturn(progress);

    await fn(commandRunner, logger, printLogs);
  });
}

// TODO refactor

/// Runs [fn] in a test environment with a project.
///
/// This is used to implement negative/positive testing of commands
/// that depend on a project to be available.
void Function() withRunnerOnProject(
  FutureOr<void> Function(
    RapidCommandRunner commandRunner,
    Logger logger,
    MelosFile melosFile,
    Project project,
    List<String> printLogs,
  )
      fn,
) {
  return _overridePrint((printLogs) async {
    registerFallbackValue(Platform.android);
    final logger = _MockLogger();
    final melosFile = _MockMelosFile();
    when(() => melosFile.exists()).thenReturn(true);
    when(() => melosFile.name()).thenReturn('test_app');
    final project = _MockProject();
    when(() => project.exists()).thenReturn(true);
    when(() => project.platformIsActivated(any())).thenReturn(true);
    // TODO
    //when(() => project.melosFile).thenReturn(melosFile);
    //when(() => project.isActivated(any())).thenReturn(true);
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

    await fn(commandRunner, logger, melosFile, project, printLogs);
  });
}
