part of 'cli.dart';

/// Signature for the [Flutter.pubGet] method.
typedef FlutterPubGetCommand = Future<void> Function({required String cwd});

/// Signature for the [Flutter.installed] method.
typedef FlutterInstalledCommand = Future<bool> Function();

/// Signature for Flutter config enable platform methods.
///
/// [Flutter.configEnableAndroid]
///
/// [Flutter.configEnableIos]
///
/// [Flutter.configEnableLinux]
///
/// [Flutter.configEnableMacos]
///
/// [Flutter.configEnableWeb]
///
/// [Flutter.configEnableWindows]
typedef FlutterConfigEnablePlatformCommand = Future<void> Function();

/// Signature for the [Flutter.pubRunBuildRunnerBuildDeleteConflictingOutputs] method.
typedef FlutterPubRunBuildRunnerBuildDeleteConflictingOutputsCommand
    = Future<void> Function({required String cwd});

/// Flutter CLI
class Flutter {
  /// Determine whether flutter is installed.
  static Future<bool> installed() async {
    try {
      await _Cmd.run('flutter', ['--version']);
      return true;
    } catch (_) {
      return false;
    }
  }

  /// Get dependencies (`flutter pub get`).
  static Future<void> pubGet({
    String cwd = '.',
  }) async {
    try {
      await _Cmd.run(
        'flutter',
        ['pub', 'get'],
        workingDirectory: cwd,
      );
    } catch (_) {}
  }

  /// Enable Flutter for Android (`flutter config --enable-android`)
  static Future<void> configEnableAndroid() async {
    try {
      await _Cmd.run('flutter', ['config', '--enable-android']);
    } catch (_) {}
  }

  /// Enable Flutter for iOS (`flutter config --enable-ios`)
  static Future<void> configEnableIos() async {
    try {
      await _Cmd.run('flutter', ['config', '--enable-ios']);
    } catch (_) {}
  }

  /// Enable Flutter for Linux (`flutter config --enable-linux-desktop`)
  static Future<void> configEnableLinux() async {
    try {
      await _Cmd.run('flutter', ['config', '--enable-linux-desktop']);
    } catch (_) {}
  }

  /// Enable Flutter for macOS (`flutter config --enable-macos-desktop`)
  static Future<void> configEnableMacos() async {
    try {
      await _Cmd.run('flutter', ['config', '--enable-macos-desktop']);
    } catch (_) {}
  }

  /// Enable Flutter for Web (`flutter config --enable-web`)
  static Future<void> configEnableWeb() async {
    try {
      await _Cmd.run('flutter', ['config', '--enable-web']);
    } catch (_) {}
  }

  /// Enable Flutter for Windows (`flutter config --enable-windows-desktop`)
  static Future<void> configEnableWindows() async {
    try {
      await _Cmd.run('flutter', ['config', '--enable-windows-desktop']);
    } catch (_) {}
  }

  /// Run code generation (`flutter pub run build_runner build --delete-conflicting-outputs`).
  static Future<void> pubRunBuildRunnerBuildDeleteConflictingOutputs({
    String cwd = '.',
  }) async {
    await _Cmd.run(
      'flutter',
      ['pub', 'run', 'build_runner', 'build', '--delete-conflicting-outputs'],
      workingDirectory: cwd,
    );
  }
}
