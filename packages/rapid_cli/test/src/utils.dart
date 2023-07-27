import 'dart:convert';

import 'package:mocktail/mocktail.dart';
import 'package:rapid_cli/src/command_runner.dart';
import 'package:rapid_cli/src/commands/runner.dart';
import 'package:rapid_cli/src/process.dart';
import 'package:rapid_cli/src/project/platform.dart';

import 'mocks.dart';

RapidCommandRunner getCommandRunner({
  MockRapidProject? project,
}) {
  return RapidCommandRunner(
    project: project ?? MockRapidProject(),
  );
}

Rapid getRapid({
  MockRapidProject? project,
  MockRapidTool? tool,
  MockRapidLogger? logger,
}) {
  return Rapid(
    project: project ?? MockRapidProject(),
    tool: tool ?? MockRapidTool(),
    logger: logger ?? MockRapidLogger(),
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
  }) =>
      _runProcess(
        ['flutter', 'pub', 'get'],
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
}
