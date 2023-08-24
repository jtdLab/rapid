import 'package:meta/meta.dart';

import 'exception.dart';
import 'io/io.dart' hide Platform;
import 'native_platform.dart';
import 'project/project.dart';
import 'utils.dart';

// TODO(jtdLab): Add seperate function for `flutter pub get --dry-run`.

/// Formats all dart code of [project].
///
/// Executes `dart format . fix` in the specified [project].
///
/// Throws a [CliException] if the operation fails.
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

/// Adds [dependenciesToAdd] to the [package].
///
/// Executes `dart pub add` in the specified package.
///
/// Throws a [CliException] if the operation fails.
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

/// Get the [package]'s dependencies.
///
/// Executes `dart pub get` in the specified package.
///
/// If [dryRun] is `true` `dart pub get --dry-run` will be executed reporting
/// wheter dependencies would change but not actually getting dependencies.
///
/// Throws a [CliException] if the operation fails.
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

/// The result of running `dart pub get --dry-run`.
@immutable
class DartPubGetResult {
  /// Creates a new [DartPubGetResult].
  const DartPubGetResult({required this.wouldChangeDependencies});

  /// Wheter running `dart pub get --dry-run` would trigger changes in
  /// dependencies.
  final bool wouldChangeDependencies;
}

/// Removes dependencies [packagesToRemove] from [package].
///
/// Executes `dart pub remove`.
///
/// Throws a [CliException] if the operation fails.
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

/// Runs code generation using [build_runner](https://pub.dev/packages/build_runner) in the
/// specified [package].
///
/// Executes `dart run build_runner build --delete-conflicting-outputs`.
///
/// Throws a [CliException] if the operation fails.
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

/// Enables the Flutter platform configuration for the specified [platform] in
/// the given [project].
///
/// Executes `flutter config` with the appropriate platform-specific flag.
///
/// Throws a [CliException] if the operation fails.
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
      },
    ],
    workingDirectory: project.path,
  );
}

/// Generates localizations for the specified Flutter [package].
///
/// Executes `flutter gen-l10n`.
///
/// Throws a [CliException] if the operation fails.
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

/// Bootstraps the packages of the given [project] specified in [scope]
/// using [melos](https://pub.dev/packages/melos).
///
/// The [scope] must not be empty.
///
/// Executes `melos bootstrap --scope <package_a>[,<package_b>,...]`.
///
/// Throws a [CliException] if the operation fails.
Future<void> melosBootstrap({
  required List<DartPackage> scope,
  required RapidProject project,
}) async {
  assert(scope.isNotEmpty, '"scope" must not be empty.');
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

/// An exception thrown when a CLI command encounters an error during execution.
class CliException extends RapidException {
  CliException._(
    super.message, {
    required this.workingDirectory,
    this.stdout,
    this.stderr,
  });

  /// The working directory where the command was executed.
  final String workingDirectory;

  /// The standard output generated by the command (if any).
  final String? stdout;

  /// The standard error output generated by the command (if any).
  final String? stderr;

  @override
  String toString() {
    return multiLine([
      '$message at $workingDirectory.',
      if (stderr != null) ...[
        '',
        stderr!,
      ],
    ]);
  }
}
