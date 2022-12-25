part of 'cli.dart';

/// Signature for the [Melos.bootstrap] method.
typedef MelosBootstrapCommand = Future<void> Function({required String cwd});

/// Signature for the [Melos.clean] method.
typedef MelosCleanCommand = Future<void> Function({required String cwd});

/// Melos CLI
class Melos {
  /// Bootstrap the melos project (`melos bootstrap`)
  static Future<void> bootstrap({String cwd = '.'}) async {
    await _Cmd.run(
      'melos',
      ['bootstrap'],
      workingDirectory: cwd,
    );
  }

  /// Clean the melos project (`melos clean`)
  static Future<void> clean({String cwd = '.'}) async {
    await _Cmd.run(
      'melos',
      ['clean'],
      workingDirectory: cwd,
    );
  }
}
