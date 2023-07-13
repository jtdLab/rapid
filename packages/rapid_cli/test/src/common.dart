import 'dart:async';
import 'dart:io' hide Platform;
import 'dart:math';

import 'package:path/path.dart' as p;
import 'package:rapid_cli/src/project/platform.dart';

extension PlatformX on Platform {
  String get prettyName {
    switch (this) {
      case Platform.android:
        return 'Android';
      case Platform.ios:
        return 'iOS';
      case Platform.web:
        return 'Web';
      case Platform.linux:
        return 'Linux';
      case Platform.macos:
        return 'macOS';
      case Platform.windows:
        return 'Windows';
      case Platform.mobile:
        return 'Mobile';
    }
  }

  List<String> get aliases {
    switch (this) {
      case Platform.android:
        return ['a'];
      case Platform.ios:
        return ['i'];
      case Platform.web:
        return [];
      case Platform.linux:
        return ['l', 'lin'];
      case Platform.macos:
        return ['mac'];
      case Platform.windows:
        return ['win'];
      case Platform.mobile:
        return [];
    }
  }
}

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
  // TODO this leads to core tests failing randomly
  return () async {
    final cwd = Directory.current;
    final dir = await getTempDir();

    Directory.current = dir;
    try {
      await fn();
    } catch (_) {
      rethrow;
    } finally {
      Directory.current = cwd;
      dir.deleteSync(recursive: true);
    }
  };
}

void Function() overridePrint(void Function(List<String>) fn) {
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

/* 
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
  ) fn,
) {
  return _overridePrint((printLogs) async {
    registerFallbackValue(Platform.android); // TODO
    final logger = MockLogger();
    final melosFile = MockMelosFile();
    when(() => melosFile.exists()).thenReturn(true);
    when(() => melosFile.readName()).thenReturn('test_app');
    final project = MockProject();
    when(() => project.existsAll()).thenReturn(true);
    when(() => project.platformIsActivated(any())).thenReturn(true);
    when(() => project.melosFile).thenReturn(melosFile);

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
 */
