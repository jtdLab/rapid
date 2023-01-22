import 'package:mason/mason.dart';
import 'package:rapid_cli/src/cli/cli.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/project/project.dart';

class EnvironmentException implements Exception {
  final int exitCode;
  final String? message;

  EnvironmentException(
    this.exitCode, [
    this.message,
  ]);
}

/// Runs [callback] when every future in [when] completes without error.
Future<int> runWhen(
  Iterable<Future<void>> when,
  Logger logger,
  Future<int> Function() callback,
) async {
  try {
    await Future.wait(when);
  } on EnvironmentException catch (e) {
    logger.err(e.message);
    return e.exitCode;
  }

  return callback();
}

/// Completes when flutter is installed.
Future<void> flutterIsInstalled(
  FlutterInstalledCommand flutterInstalled, {
  required Logger logger,
}) async {
  final isFlutterInstalled = await flutterInstalled(logger: logger);

  if (!isFlutterInstalled) {
    throw EnvironmentException(
      ExitCode.unavailable.code,
      'Flutter not installed.',
    );
  }
}

/// Completes when melos is installed.
Future<void> melosIsInstalled(
  MelosInstalledCommand melosInstalled, {
  required Logger logger,
}) async {
  final isFlutterInstalled = await melosInstalled(logger: logger);

  if (!isFlutterInstalled) {
    throw EnvironmentException(
      ExitCode.unavailable.code,
      'Melos not installed.',
    );
  }
}

/// Completes when [project] exists.
Future<void> isProjectRoot(Project project) async {
  final isRoot = project.exists();

  if (!isRoot) {
    throw EnvironmentException(
      ExitCode.noInput.code,
      '''
 Could not find a melos.yaml.
 This command should be run from the root of your Rapid project.''',
    );
  }
}

/// Completes when [platform] is activated in [project].
Future<void> platformIsActivated(Platform platform, Project project) async {
  final platformIsActivated = project.platformIsActivated(platform);

  if (!platformIsActivated) {
    throw EnvironmentException(
      ExitCode.config.code,
      '${platform.prettyName} is already deactivated.',
    );
  }
}