import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:mason/mason.dart';
import 'package:mocktail/mocktail.dart';
import 'package:path/path.dart' as p;
import 'package:rapid_cli/src/command_runner.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/project/project.dart';

import 'mocks.dart';

String tempPath = p.join(Directory.current.path, '.dart_tool', 'test', 'tmp');

final random = Random();
Future<Directory> getTempDir() async {
  var name = random.nextInt(pow(2, 32) as int);
  var dir = Directory(p.join(tempPath, '${name}_tmp'));
  if (await dir.exists()) {
    await dir.delete(recursive: true);
  }
  await dir.create(recursive: true);
  return dir;
}

dynamic Function() withTempDir(FutureOr<void> Function() fn) {
  return () async {
    final cwd = Directory.current;
    final dir = await getTempDir();

    Directory.current = dir;
    await fn();
    Directory.current = cwd;
  };
}

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
    final logger = MockLogger();

    final progress = MockProgress();
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
    final logger = MockLogger();
    final melosFile = MockMelosFile();
    when(() => melosFile.exists()).thenReturn(true);
    when(() => melosFile.readName()).thenReturn('test_app');
    final project = MockProject();
    when(() => project.existsAll()).thenReturn(true);
    when(() => project.platformIsActivated(any())).thenReturn(true);
    // TODO
    //when(() => project.melosFile).thenReturn(melosFile);
    //when(() => project.isActivated(any())).thenReturn(true);
    final progress = MockProgress();
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
