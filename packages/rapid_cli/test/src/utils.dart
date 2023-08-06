import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:mocktail/mocktail.dart';
import 'package:rapid_cli/src/command_runner.dart';
import 'package:rapid_cli/src/commands/runner.dart';
import 'package:rapid_cli/src/io/io.dart' hide Platform;
import 'package:rapid_cli/src/logging.dart';
import 'package:rapid_cli/src/project/platform.dart';
import 'package:rapid_cli/src/project/project.dart';
import 'package:rapid_cli/src/tool.dart';
import 'package:rapid_cli/src/utils.dart';

import 'mocks.dart';

RapidCommandRunner getCommandRunner({
  RapidProject? project,
}) {
  return RapidCommandRunner(
    project: project ?? MockRapidProject(),
  );
}

Rapid getRapid({
  RapidProject? project,
  RapidTool? tool,
  RapidLogger? logger,
}) {
  return Rapid(
    project: project ?? MockRapidProject(),
    tool: tool ?? MockRapidTool(),
    logger: logger ?? MockRapidLogger(),
  );
}

Platform randomPlatform() {
  const enumValues = Platform.values;
  final randomIndex = Random().nextInt(enumValues.length);
  return enumValues[randomIndex];
}

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

void Function() overridePrint(void Function(List<String>) fn) {
  return () {
    final printLogs = <String>[];
    final spec = ZoneSpecification(
      print: (_, __, ___, String msg) {
        printLogs.add(msg);
      },
    );

    final platform = FakePlatform(
      // Simulate terminal with width 1024 so line wrapping
      // has not to be considered when unit testing
      environment: {envKeyRapidTerminalWidth: '1024'},
    );

    return Zone.current.fork(
      specification: spec,
      zoneValues: {
        currentPlatformZoneKey: platform,
      },
    ).run<void>(() => fn(printLogs));
  };
}

typedef LoggerSetup = ({
  Progress progress,
  GroupableProgress groupableProgress,
  ProgressGroup progressGroup,
  RapidLogger logger
});

typedef LoggerWithoutGroupSetup = ({Progress progress, RapidLogger logger});

LoggerSetup setupLogger() {
  final progress = MockProgress();
  final groupableProgress = MockGroupableProgress();
  final progressGroup = MockProgressGroup(progress: groupableProgress);
  final logger =
      MockRapidLogger(progress: progress, progressGroup: progressGroup);

  return (
    progress: progress,
    groupableProgress: groupableProgress,
    progressGroup: progressGroup,
    logger: logger,
  );
}

LoggerWithoutGroupSetup setupLoggerWithoutGroup() {
  final progress = MockProgress();

  final logger = MockRapidLogger(progress: progress);

  return (
    progress: progress,
    logger: logger,
  );
}

RapidProject setupProjectWithPlatformFeaturePackage(String name) {
  return MockRapidProject(
    appModule: MockAppModule(
      platformDirectory: ({required Platform platform}) =>
          MockPlatformDirectory(
        featuresDirectory: MockPlatformFeaturesDirectory(
          featurePackages: [
            FakePlatformFeaturePackage(name: name),
          ],
        ),
      ),
    ),
  );
}

RapidProject setupProjectWithDomainPackage(String name) {
  return MockRapidProject(
    appModule: MockAppModule(
      domainDirectory: MockDomainDirectory(
        domainPackages: [
          FakeDomainPackage(name: name),
        ],
      ),
    ),
  );
}

RapidProject setupProjectWithInfrastructurePackage(String name) {
  return MockRapidProject(
    appModule: MockAppModule(
      infrastructureDirectory: MockInfrastructureDirectory(
        infrastructurePackages: [
          FakeInfrastructurePackage(name: name),
        ],
      ),
    ),
  );
}

extension ProcessManagerX on ProcessManager {
  Future<ProcessResult> _runProcess(
    List<String> command, {
    required String workingDirectory,
  }) =>
      run(
        command,
        workingDirectory: workingDirectory,
        runInShell: true,
        stderrEncoding: utf8,
        stdoutEncoding: utf8,
      );

  Future<ProcessResult> runDartPubGet({
    required String workingDirectory,
    bool dryRun = false,
  }) =>
      _runProcess(
        ['dart', 'pub', 'get', if (dryRun) '--dry-run'],
        workingDirectory: workingDirectory,
      );

  Future<ProcessResult> runFlutterGenl10n({
    required String workingDirectory,
  }) =>
      _runProcess(
        ['flutter', 'gen-l10n'],
        workingDirectory: workingDirectory,
      );

  Future<ProcessResult> runDartFormatFix({
    required String workingDirectory,
  }) =>
      _runProcess(
        ['dart', 'format', '.', '--fix'],
        workingDirectory: workingDirectory,
      );

  Future<ProcessResult> runFlutterConfigEnablePlatform(
    NativePlatform platform,
  ) =>
      _runProcess(
        [
          'flutter',
          'config',
          switch (platform) {
            NativePlatform.android => '--enable-android',
            NativePlatform.ios => '--enable-ios',
            NativePlatform.linux => '--enable-linux-desktop',
            NativePlatform.macos => '--enable-macos-desktop',
            NativePlatform.web => '--enable-web',
            NativePlatform.windows => '--enable-windows-desktop',
          }
        ],
        workingDirectory: any(named: 'workingDirectory'),
      );

  Future<ProcessResult> runDartPubAdd(
    List<String> dependenciesToAdd, {
    required String workingDirectory,
  }) =>
      _runProcess(
        ['dart', 'pub', 'add', ...dependenciesToAdd],
        workingDirectory: workingDirectory,
      );

  Future<ProcessResult> runDartPubRemove(
    List<String> dependenciesToRemove, {
    required String workingDirectory,
  }) =>
      _runProcess(
        ['dart', 'pub', 'remove', ...dependenciesToRemove],
        workingDirectory: workingDirectory,
      );

  Future<ProcessResult> runMelosBootstrap(
    List<String> scope, {
    required String workingDirectory,
  }) =>
      _runProcess(
        ['melos', 'bootstrap', '--scope', scope.join(',')],
        workingDirectory: workingDirectory,
      );

  Future<ProcessResult> runDartRunBuildRunnerBuildDeleteConflictingOutputs({
    required String workingDirectory,
  }) =>
      _runProcess(
        [
          'dart',
          'run',
          'build_runner',
          'build',
          '--delete-conflicting-outputs',
        ],
        workingDirectory: workingDirectory,
      );
}
