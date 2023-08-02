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
    [
      'melos',
      'bootstrap',
      '--scope',
      scope.map((e) => e.packageName).toList().join(','),
    ],
    workingDirectory: project.path,
  );

  if (result.exitCode != 0) {
    throw CliException._(
      'Failed to bootstrap.',
      directory: project.rootPackage, // TODO good?
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
    ['flutter', 'pub', 'get', if (dryRun) '--dry-run'],
    workingDirectory: package.path,
  );

  if (result.exitCode != 0) {
    throw CliException._(
      'Failed to install.',
      directory: package,
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

class FlutterPubGetResult {
  final bool wouldChangeDependencies;

  FlutterPubGetResult({required this.wouldChangeDependencies});
}

Future<void> flutterGenl10n({required DartPackage package}) async {
  final result = await runCommand(
    ['flutter', 'gen-l10n'],
    workingDirectory: package.path,
  );

  if (result.exitCode != 0) {
    throw CliException._(
      'Failed to generate localizations.',
      directory: package,
      stdout: result.stdout,
      stderr: result.stderr,
    );
  }
}

Future<void> dartFormatFix({required RapidProject project}) async {
  final result = await runCommand(
    ['dart', 'format', '.', '--fix'],
    workingDirectory: project.path,
  );

  if (result.exitCode != 0) {
    throw CliException._(
      'Failed to format.',
      directory: project.rootPackage, // TODO good?
      stdout: result.stdout,
      stderr: result.stderr,
    );
  }
}

Future<void> flutterPubRunBuildRunnerBuildDeleteConflictingOutputs({
  required DartPackage package,
}) async {
  final result = await runCommand(
    [
      'flutter',
      'pub',
      'run',
      'build_runner',
      'build',
      '--delete-conflicting-outputs',
    ],
    workingDirectory: package.path,
  );

  if (result.exitCode != 0) {
    throw CliException._(
      'Failed to run code generation.',
      directory: package,
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
    ['flutter', 'pub', 'add', ...dependenciesToAdd],
    workingDirectory: package.path,
  );

  if (result.exitCode != 0) {
    throw CliException._(
      'Failed to add dependencies',
      directory: package,
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
    ['flutter', 'pub', 'remove', ...packagesToRemove],
    workingDirectory: package.path,
  );

  if (result.exitCode != 0) {
    throw CliException._(
      'Failed to remove dependencies.',
      directory: package,
      stdout: result.stdout,
      stderr: result.stderr,
    );
  }
}

Future<void> flutterConfigEnable({
  required Platform platform,
  required RapidProject project,
}) async {
  assert(platform != Platform.mobile);
  await runCommand(
    [
      'flutter',
      'config',
      switch (platform) {
        Platform.android => '--enable-android',
        Platform.ios => '--enable-ios',
        Platform.linux => '--enable-linux-desktop',
        Platform.macos => '--enable-macos-desktop',
        Platform.web => '--enable-web',
        _ => '--enable-windows-desktop',
      }
    ],
    workingDirectory: project.path,
  );
}

class CliException extends RapidException {
  CliException._(
    super.message, {
    required this.directory,
    this.stdout,
    this.stderr,
  });

  final Directory directory;
  final String? stdout;
  final String? stderr;

  @override
  String toString() {
    return multiLine([
      '$message - at ${directory.path}.',
      if (stderr != null) ...[
        '',
        stderr!,
      ]
    ]);
  }
}
