// TODO rm?

/* import 'dart:io';

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
  Future<void> Function() callback,
) async {
  try {
    await Future.wait(when);
  } on EnvironmentException catch (e) {
    logger
      ..info('')
      ..err(e.message);

    return e.exitCode;
  }

  return callback();
}

/// Completes when flutter is installed.
Future<int> flutterIsInstalled(
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
Future<int> melosIsInstalled(
  MelosInstalledCommand melosInstalled, {
  required Logger logger,
}) async {
  final isMelosInstalled = await melosInstalled(logger: logger);

  if (!isMelosInstalled) {
    throw EnvironmentException(
      ExitCode.unavailable.code,
      'Melos not installed.',
    );
  }
}

/* /// Completes when all entities of [project] exist.
Future<int> projectExistsAll(RapidProject project) async {
  final existsAll = project.existsAll();

  if (!existsAll) {
    throw EnvironmentException(
      ExitCode.noInput.code,
      'This command should be run from the root of an existing Rapid project.',
    );
  }
} */

/// Completes when [platform] is activated in [project].
Future<int> platformIsActivated(
  Platform platform,
  RapidProject project,
  String errorMessage,
) async {
  final platformIsActivated = project.platformIsActivated(platform);

  if (!platformIsActivated) {
    throw EnvironmentException(
      ExitCode.config.code,
      errorMessage,
    );
  }
}

/// Completes when pubspec.yaml exists in cwd.
Future<int> pubspecExists() async {
  final pubspecExists = File('pubspec.yaml').existsSync();

  if (!pubspecExists) {
    throw EnvironmentException(
      ExitCode.noInput.code,
      'This command should be run from the root of a dart package.',
    );
  }
}
 */
