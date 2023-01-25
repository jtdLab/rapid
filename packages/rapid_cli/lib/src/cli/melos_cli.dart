part of 'cli.dart';

/// Signature for the [Melos.installed] method.
typedef MelosInstalledCommand = Future<bool> Function({required Logger logger});

/// Signature for the [Melos.bootstrap] method.
typedef MelosBootstrapCommand = Future<void> Function({
  String cwd,
  List<String>? scope,
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
  /// If [scope] is provided runs (`melos bootstrap --scope item1,item2,...`) instead.
  static Future<void> bootstrap({
    String cwd = '.',
    List<String>? scope,
    required Logger logger,
  }) async {
    if (scope == null) {
      final progress = logger.progress(
        'Running "melos bootstrap" in $cwd ',
      );

      try {
        await _Cmd.run(
          'melos',
          ['bootstrap'],
          workingDirectory: cwd,
          logger: logger,
        );
      } catch (_) {
        progress.fail();
        rethrow;
      }

      progress.complete();
    } else {
      final scopeString = scope.join(',');

      final progress = logger.progress(
        'Running "melos bootstrap --scope $scopeString" in $cwd ',
      );

      try {
        await _Cmd.run(
          'melos',
          ['bootstrap', '--scope', scopeString],
          workingDirectory: cwd,
          logger: logger,
        );
      } catch (_) {
        progress.fail();
        rethrow;
      }

      progress.complete();
    }
  }

  /// Clean the melos project (`melos clean`).
  static Future<void> clean({
    String cwd = '.',
    required Logger logger,
  }) async {
    final progress = logger.progress(
      'Running "melos clean" in $cwd ',
    );

    try {
      await _Cmd.run(
        'melos',
        ['clean'],
        workingDirectory: cwd,
        logger: logger,
      );
    } catch (_) {
      progress.fail();
      rethrow;
    }

    progress.complete();
  }
}
