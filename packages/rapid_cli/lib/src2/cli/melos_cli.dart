part of 'cli.dart';

// TODO here process failures get caught and lead do failing process completion in flutter cli its not
// decide whats the better approach and add logging to flutter then

/// Signature for the [Melos.installed] method.
typedef MelosInstalledCommand = Future<bool> Function({required Logger logger});

/// Signature for the [Melos.bootstrap] method.
typedef MelosBootstrapCommand = Future<void> Function({
  String cwd,
  String? scope,
  required Logger logger,
});

/// Signature for the [Melos.clean] method.
typedef MelosCleanCommand = Future<void> Function({
  String cwd,
  required Logger logger,
});

/// Melos CLI
abstract class Melos {
  /// Determine whether melos is installed.
  static Future<bool> installed({
    required Logger logger,
  }) async {
    try {
      await _Cmd.run('melos', ['--version'], logger: logger);
      return true;
    } catch (_) {
      return false;
    }
  }

  /// Bootstrap the melos project (`melos bootstrap`).
  ///
  /// If scope is provided runs (`melos bootstrap --scope <scope>`) instead.
  static Future<void> bootstrap({
    String cwd = '.',
    String? scope,
    required Logger logger,
  }) async {
    if (scope == null) {
      final bootstrapProgress = logger.progress(
        'Running "melos bootstrapp" in $cwd',
      );

      try {
        await _Cmd.run(
          'melos',
          ['bootstrap'],
          workingDirectory: cwd,
          logger: logger,
        );
      } catch (_) {
        bootstrapProgress.fail();
        return;
      }

      bootstrapProgress.complete();
    } else {
      final bootstrapProgress = logger.progress(
        'Running "melos bootstrapp --scope $scope" in $cwd',
      );

      try {
        await _Cmd.run(
          'melos',
          ['bootstrap', '--scope', scope],
          workingDirectory: cwd,
          logger: logger,
        );
      } catch (_) {
        bootstrapProgress.fail();
        return;
      }

      bootstrapProgress.complete();
    }
  }

  /// Clean the melos project (`melos clean`).
  static Future<void> clean({
    String cwd = '.',
    required Logger logger,
  }) async {
    final cleanProgress = logger.progress(
      'Running "melos clean" in $cwd',
    );

    try {
      await _Cmd.run(
        'melos',
        ['clean'],
        workingDirectory: cwd,
        logger: logger,
      );
    } catch (_) {
      cleanProgress.fail();
      return;
    }

    cleanProgress.complete();
  }
}
