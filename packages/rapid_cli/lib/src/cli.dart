import 'package:rapid_cli/src/project/platform.dart';

import 'exception.dart';
import 'io.dart';
import 'project/project.dart';
import 'utils.dart';

export 'package:pubspec/pubspec.dart';

// TODO Atm all commands use run under the maybe start offers more insights

Future<void> melosBootstrap({
  required List<DartPackage> scope,
  required RapidProject project,
}) async {
  // TODO forward updates about bootstrapped packages / failures based on the process streams stdout.
  final result = await runCommand(
    melosBootstrapCommand(scope.map((e) => e.packageName).toList()),
    workingDirectory: project.path,
  );

  if (result.exitCode != 0) {
    throw MelosBootstrapException._(
      'Failed to bootstrap.',
      stdout: result.stdout,
      stderr: result.stderr,
    );
  }
}

Future<FlutterPubGetResult> flutterPubGet({
  bool dryRun = false,
  required DartPackage package,
}) async {
  final result = await runCommand(
    flutterPubGetCommand(dryRun: dryRun),
    workingDirectory: package.path,
  );

  if (result.exitCode != 0) {
    throw FlutterPubGetException._(
      package,
      'Failed to install.',
      stdout: result.stdout,
      stderr: result.stderr,
    );
  }

  final wouldChangeDependencies =
      !(result.stdout as String).contains('No dependencies would change.');
  return FlutterPubGetResult(
    wouldChangeDependencies: wouldChangeDependencies,
  );
}

Future<void> flutterGenl10n({required DartPackage package}) async {
  final result = await runCommand(
    flutterGenl10nCommand(),
    workingDirectory: package.path,
  );

  if (result.exitCode != 0) {
    throw FlutterGenl10nException._(
      package,
      'Failed to generate localizations.',
      stdout: result.stdout,
      stderr: result.stderr,
    );
  }
}

Future<void> dartFormatFix({required DartPackage package}) async {
  final result = await runCommand(
    dartFormatFixCommand(),
    workingDirectory: package.path,
  );

  if (result.exitCode != 0) {
    throw DartFormatFixException._(
      package,
      'Failed format.',
      stdout: result.stdout,
      stderr: result.stderr,
    );
  }
}

Future<void> flutterPubRunBuildRunnerBuildDeleteConflictingOutputs({
  required DartPackage package,
}) async {
  final result = await runCommand(
    flutterPubRunBuildRunnerBuildDeleteConflictingOutputsCommand(),
    workingDirectory: package.path,
  );

  if (result.exitCode != 0) {
    throw FlutterPubRunBuildRunnerBuildException._(
      package,
      'Failed to run code generation.',
      stdout: result.stdout,
      stderr: result.stderr,
    );
  }
}

Future<void> flutterPubAdd({
  required List<String> dependenciesToAdd,
  required DartPackage package,
}) async {
  final result = await runCommand(
    flutterPubAddCommand(dependenciesToAdd),
    workingDirectory: package.path,
  );

  if (result.exitCode != 0) {
    throw FlutterPubAddException._(
      package,
      stdout: result.stdout,
      stderr: result.stderr,
    );
  }
}

Future<void> flutterPubRemove({
  required List<String> packagesToRemove,
  required DartPackage package,
}) async {
  final result = await runCommand(
    flutterPubRemoveCommand(packagesToRemove),
    workingDirectory: package.path,
  );

  if (result.exitCode != 0) {
    throw FlutterPubRemoveException._(
      package,
      'Failed to remove dependencies.',
      stdout: result.stdout,
      stderr: result.stderr,
    );
  }
}

Future<void> flutterConfigEnable({
  required Platform platform,
  required RapidProject project,
}) async {
  await runCommand(
    flutterConfigEnableCommand(platform),
    workingDirectory: project.path,
  );
}

List<String> melosBootstrapCommand(List<String> scope) => [
      'melos',
      'bootstrap',
      '--scope',
      scope.join(','),
    ];

List<String> flutterPubAddCommand(List<String> dependenciesToAdd) =>
    ['flutter', 'pub', 'add', ...dependenciesToAdd];

List<String> flutterPubRemoveCommand(List<String> dependenciesToRemove) =>
    ['flutter', 'pub', 'remove', ...dependenciesToRemove];

List<String> flutterPubRunBuildRunnerBuildDeleteConflictingOutputsCommand() => [
      'flutter',
      'pub',
      'run',
      'build_runner',
      'build',
      '--delete-conflicting-outputs',
    ];

List<String> dartFormatFixCommand() => ['dart', 'format', '.', '--fix'];

List<String> flutterPubGetCommand({bool dryRun = false}) => [
      'flutter',
      'pub',
      'get',
      if (dryRun) '--dry-run',
    ];

List<String> flutterGenl10nCommand() => ['flutter', 'gen-l10n'];

List<String> flutterConfigEnableCommand(Platform platform) => [
      'flutter',
      'config',
      if (platform == Platform.android) '--enable-android',
      if (platform == Platform.ios) '--enable-ios',
      if (platform == Platform.linux) '--enable-linux-desktop',
      if (platform == Platform.macos) '--enable-macos-desktop',
      if (platform == Platform.web) '--enable-web',
      if (platform == Platform.windows) '--enable-windows-desktop',
    ];

// TODO share and update toString() ?

class MelosBootstrapException implements RapidException {
  MelosBootstrapException._(
    this.message, {
    this.stdout,
    this.stderr,
  });

  final String message;
  final String? stdout;
  final String? stderr;

  @override
  String toString() {
    return 'MelosBootstrapException: $message.\n' '$stderr';
  }
}

class FlutterPubGetResult {
  final bool wouldChangeDependencies;

  FlutterPubGetResult({required this.wouldChangeDependencies});
}

class FlutterPubGetException implements RapidException {
  FlutterPubGetException._(
    this.package,
    this.message, {
    this.stdout,
    this.stderr,
  });

  final DartPackage package;
  final String message;
  final String? stdout;
  final String? stderr;

  @override
  String toString() {
    return 'FlutterPubGetException: $message: ${package.packageName} at ${package.path}.';
  }
}

class FlutterGenl10nException implements RapidException {
  FlutterGenl10nException._(
    this.package,
    this.message, {
    this.stdout,
    this.stderr,
  });

  final DartPackage package;
  final String message;
  final String? stdout;
  final String? stderr;

  @override
  String toString() {
    return 'FlutterGenl10nException: $message: ${package.packageName} at ${package.path}.';
  }
}

class DartFormatFixException implements RapidException {
  DartFormatFixException._(
    this.package,
    this.message, {
    this.stdout,
    this.stderr,
  });

  final DartPackage package;
  final String message;
  final String? stdout;
  final String? stderr;

  @override
  String toString() {
    return 'DartFormatFixException: $message: ${package.packageName} at ${package.path}.';
  }
}

class FlutterPubRunBuildRunnerBuildException implements RapidException {
  FlutterPubRunBuildRunnerBuildException._(
    this.package,
    this.message, {
    this.stdout,
    this.stderr,
  });

  final DartPackage package;
  final String message;
  final String? stdout;
  final String? stderr;

  @override
  String toString() {
    return 'FlutterPubRunBuildRunnerBuildException: $message: ${package.packageName} at ${package.path}.';
  }
}

class FlutterPubAddException implements RapidException {
  FlutterPubAddException._(
    this.package, {
    this.stdout,
    this.stderr,
  });

  final DartPackage package;

  final String? stdout;
  final String? stderr;

  @override
  String toString() {
    return [
      'FlutterPubAddException: Failed to add dependencies to ${package.packageName} at ${package.path}.',
      if (stderr != null) stderr,
    ].join('\n');
  }
}

class FlutterPubRemoveException implements RapidException {
  FlutterPubRemoveException._(
    this.package,
    this.message, {
    this.stdout,
    this.stderr,
  });

  final DartPackage package;
  final String message;
  final String? stdout;
  final String? stderr;

  @override
  String toString() {
    return 'FlutterPubRemoveException: $message: ${package.packageName} at ${package.path}.';
  }
}
