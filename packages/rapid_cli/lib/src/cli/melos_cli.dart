part of 'cli.dart';

/// Signature for the [Melos.bootstrap] method.
typedef MelosBootstrapCommand = Future<void> Function({required String cwd});

/// Signature for the [Melos.clean] method.
typedef MelosCleanCommand = Future<void> Function({required String cwd});

/// Melos CLI
class Melos {
  /// Bootstrap the melos project (`melos bootstrap`)
  static Future<void> bootstrap({required String cwd}) async {
    try {
      await Process.run(
        'melos',
        ['bootstrap'],
        workingDirectory: cwd,
      );
    } catch (_) {}
  }

  /// Clean the melos project (`melos clean`)
  static Future<void> clean({required String cwd}) async {
    try {
      await _Cmd.run(
        'melos',
        ['clean'],
        workingDirectory: cwd,
      );
    } catch (_) {}
  }
}
