import 'dart:convert';
import 'dart:math';

import 'package:mocktail/mocktail.dart';
import 'package:rapid_cli/src/command_runner.dart';
import 'package:rapid_cli/src/commands/runner.dart';
import 'package:rapid_cli/src/logging.dart';
import 'package:rapid_cli/src/process.dart';
import 'package:rapid_cli/src/project/platform.dart';
import 'package:rapid_cli/src/project/project.dart';
import 'package:rapid_cli/src/tool.dart';

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
  final enumValues = Platform.values;
  int randomIndex = Random().nextInt(enumValues.length);
  return enumValues[randomIndex];
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
  dynamic _runProcess(
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

  dynamic runFlutterPubGet({
    required String workingDirectory,
    bool dryRun = false,
  }) =>
      _runProcess(
        ['flutter', 'pub', 'get', if (dryRun) '--dry-run'],
        workingDirectory: workingDirectory,
      );

  dynamic runFlutterGenl10n({
    required String workingDirectory,
  }) =>
      _runProcess(
        ['flutter', 'gen-l10n'],
        workingDirectory: workingDirectory,
      );

  dynamic runDartFormatFix({
    required String workingDirectory,
  }) =>
      _runProcess(
        ['dart', 'format', '.', '--fix'],
        workingDirectory: workingDirectory,
      );

  dynamic runFlutterConfigEnablePlatform(Platform platform) => _runProcess(
        [
          'flutter',
          'config',
          if (platform == Platform.android) '--enable-android',
          if (platform == Platform.ios) '--enable-ios',
          if (platform == Platform.linux) '--enable-linux-desktop',
          if (platform == Platform.macos) '--enable-macos-desktop',
          if (platform == Platform.web) '--enable-web',
          if (platform == Platform.windows) '--enable-windows-desktop',
        ],
        workingDirectory: any(named: 'workingDirectory'),
      );

  dynamic runFlutterPubAdd(
    List<String> dependenciesToAdd, {
    required String workingDirectory,
  }) =>
      _runProcess(
        ['flutter', 'pub', 'add', ...dependenciesToAdd],
        workingDirectory: workingDirectory,
      );

  dynamic runFlutterPubRemove(
    List<String> dependenciesToRemove, {
    required String workingDirectory,
  }) =>
      _runProcess(
        ['flutter', 'pub', 'remove', ...dependenciesToRemove],
        workingDirectory: workingDirectory,
      );

  dynamic runMelosBootstrap(
    List<String> scope, {
    required String workingDirectory,
  }) =>
      _runProcess(
        ['melos', 'bootstrap', '--scope', scope.join(',')],
        workingDirectory: workingDirectory,
      );

  dynamic runFlutterPubRunBuildRunnerBuildDeleteConflictingOutputs({
    required String workingDirectory,
  }) =>
      _runProcess(
        [
          'flutter',
          'pub',
          'run',
          'build_runner',
          'build',
          '--delete-conflicting-outputs',
        ],
        workingDirectory: workingDirectory,
      );
}
