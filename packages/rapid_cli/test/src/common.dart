import 'dart:async';
import 'dart:io' hide Platform;
import 'dart:math';

import 'package:mason/mason.dart';
import 'package:mocktail/mocktail.dart';
import 'package:path/path.dart' as p;
import 'package:platform/platform.dart' hide Platform;
import 'package:rapid_cli/src/command_runner.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/project/project.dart';
import 'package:rapid_cli/src/utils.dart';

import 'mock_env.dart';
import 'mocks.dart';

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

// TODO rm logger
void Function() withRunner(
  FutureOr<void> Function(
    RapidCommandRunner commandRunner,
    RapidProject project,
    Logger logger,
    List<String> printLogs,
  ) fn, {
  void Function(RapidProject project)? setupProject,
}) {
  return withMockPlatform(
    overridePrint((printLogs) async {
      final project = MockRapidProject();

      final config = MockRapidProjectConfig();
      when(() => config.isEmpty).thenReturn(false);
      final domainDirectory = MockDomainDirectory();
      when(() => domainDirectory.domainPackages()).thenReturn([]);
      final infrastructureDirectory = MockInfrastructureDirectory();
      when(() => infrastructureDirectory.infrastructurePackages())
          .thenReturn([]);
      final featuresDirectory = MockFeaturesDirectory();
      when(() => featuresDirectory.featurePackages()).thenReturn([]);
      final platformDirectory = MockPlatformDirectory();
      when(() => platformDirectory.featuresDirectory)
          .thenReturn(featuresDirectory);

      when(() => project.domainDirectory).thenReturn(domainDirectory);
      when(() => project.infrastructureDirectory)
          .thenReturn(infrastructureDirectory);
      when(() => project.platformDirectory(platform: any(named: 'platform')))
          .thenReturn(platformDirectory);

      if (setupProject != null) {
        setupProject(project);
      }

      final logger = MockLogger();
      final progress = MockProgress();
      final progressLogs = <String>[];
      final commandRunner = RapidCommandRunner(
        project: project,
        logger: logger,
      );

      when(() => progress.complete(any())).thenAnswer((_) {
        final message = _.positionalArguments.elementAt(0) as String?;
        if (message != null) progressLogs.add(message);
      });
      when(() => logger.progress(any())).thenReturn(progress);

      await fn(commandRunner, project, logger, printLogs);
    }),
    platform: FakePlatform.fromPlatform(const LocalPlatform())
      ..environment[envKeyRapidTerminalWidth] = '80',
  );
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
