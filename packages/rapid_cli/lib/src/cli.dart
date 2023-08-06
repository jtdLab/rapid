import 'exception.dart';
import 'io/io.dart' hide Platform;
import 'project/project.dart';
import 'utils.dart';

Future<void> dartFormatFix({required RapidProject project}) async {
  final result = await runCommand(
    ['dart', 'format', '.', '--fix'],
    workingDirectory: project.path,
  );

  if (result.exitCode != 0) {
    throw CliException._(
      'Failed to format',
      workingDirectory: project.path,
      stdout: result.stdout as String?,
      stderr: result.stderr as String?,
    );
  }
}

Future<void> dartPubAdd({
  required List<String> dependenciesToAdd,
  required DartPackage package,
}) async {
  final result = await runCommand(
    ['dart', 'pub', 'add', ...dependenciesToAdd],
    workingDirectory: package.path,
  );

  if (result.exitCode != 0) {
    throw CliException._(
      'Failed to add dependencies',
      workingDirectory: package.path,
      stdout: result.stdout as String?,
      stderr: result.stderr as String?,
    );
  }
}

Future<DartPubGetResult> dartPubGet({
  required DartPackage package,
  bool dryRun = false,
}) async {
  final result = await runCommand(
    ['dart', 'pub', 'get', if (dryRun) '--dry-run'],
    workingDirectory: package.path,
  );

  if (result.exitCode != 0) {
    throw CliException._(
      'Failed to install',
      workingDirectory: package.path,
      stdout: result.stdout as String?,
      stderr: result.stderr as String?,
    );
  }

  final wouldChangeDependencies =
      !(result.stdout as String).contains('No dependencies would change.');
  return DartPubGetResult(
    wouldChangeDependencies: wouldChangeDependencies,
  );
}

class DartPubGetResult {
  DartPubGetResult({required this.wouldChangeDependencies});

  final bool wouldChangeDependencies;
}

Future<void> dartPubRemove({
  required List<String> packagesToRemove,
  required DartPackage package,
}) async {
  final result = await runCommand(
    ['dart', 'pub', 'remove', ...packagesToRemove],
    workingDirectory: package.path,
  );

  if (result.exitCode != 0) {
    throw CliException._(
      'Failed to remove dependencies',
      workingDirectory: package.path,
      stdout: result.stdout as String?,
      stderr: result.stderr as String?,
    );
  }
}

Future<void> dartRunBuildRunnerBuildDeleteConflictingOutputs({
  required DartPackage package,
}) async {
  final result = await runCommand(
    [
      'dart',
      'run',
      'build_runner',
      'build',
      '--delete-conflicting-outputs',
    ],
    workingDirectory: package.path,
  );

  if (result.exitCode != 0) {
    throw CliException._(
      'Failed to run code generation',
      workingDirectory: package.path,
      stdout: result.stdout as String?,
      stderr: result.stderr as String?,
    );
  }
}

Future<void> flutterConfigEnable({
  required NativePlatform platform,
  required RapidProject project,
}) async {
  await runCommand(
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
    workingDirectory: project.path,
  );
}

Future<void> flutterGenl10n({required DartPackage package}) async {
  final result = await runCommand(
    ['flutter', 'gen-l10n'],
    workingDirectory: package.path,
  );

  if (result.exitCode != 0) {
    throw CliException._(
      'Failed to generate localizations',
      workingDirectory: package.path,
      stdout: result.stdout as String?,
      stderr: result.stderr as String?,
    );
  }
}

Future<void> melosBootstrap({
  required List<DartPackage> scope,
  required RapidProject project,
}) async {
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
      'Failed to bootstrap',
      workingDirectory: project.path,
      stdout: result.stdout as String?,
      stderr: result.stderr as String?,
    );
  }
}

class CliException extends RapidException {
  CliException._(
    super.message, {
    required this.workingDirectory,
    this.stdout,
    this.stderr,
  });

  final String workingDirectory;
  final String? stdout;
  final String? stderr;

  @override
  String toString() {
    return multiLine([
      '$message at $workingDirectory.',
      if (stderr != null) ...[
        '',
        stderr!,
      ]
    ]);
  }
}
