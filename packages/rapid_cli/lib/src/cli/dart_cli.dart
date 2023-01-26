part of 'cli.dart';

/// Signature for the [Dart.formatFix] method.
typedef DartFormatFixCommand = Future<void> Function({
  String cwd,
  required Logger logger,
});

/// Dart CLI
abstract class Dart {
  /// Run code formatting (`dart format . --fix`).
  static Future<void> formatFix({
    String cwd = '.',
    required Logger logger,
  }) async {
    final progress = logger.progress(
      'Running "dart format . --fix" in $cwd ',
    );

    try {
      await _Cmd.run(
        'dart',
        ['format', '.', '--fix'],
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
