part of 'cli.dart';

/// Signature for the [Flutter.installed] method.
typedef FlutterInstalledCommand = Future<bool> Function({
  required Logger logger,
});

/// Signature for the [Flutter.pubGet] method.
typedef FlutterPubGetCommand = Future<void> Function({
  required String cwd,
  required Logger logger,
});

/// Signature for the [Flutter.pubAdd] method.
typedef FlutterPubAddCommand = Future<void> Function({
  required String cwd,
  required List<String> packages,
  required Logger logger,
});

/// Signature for the [Flutter.pubRemove] method.
typedef FlutterPubRemoveCommand = Future<void> Function({
  required String cwd,
  required List<String> packages,
  required Logger logger,
});

/// Signature for flutter config enable platform methods.
///
///  * [Flutter.configEnableAndroid]
///
///  * [Flutter.configEnableIos]
///
///  * [Flutter.configEnableLinux]
///
///  * [Flutter.configEnableMacos]
///
///  * [Flutter.configEnableWeb]
///
///  * [Flutter.configEnableWindows]
typedef FlutterConfigEnablePlatformCommand = Future<void> Function({
  required Logger logger,
});

/// Signature for the [Flutter.pubRunBuildRunnerBuildDeleteConflictingOutputs] method.
typedef FlutterPubRunBuildRunnerBuildDeleteConflictingOutputsCommand
    = Future<void> Function({
  required String cwd,
  required Logger logger,
});

/// Signature for the [Flutter.genl10n] method.
typedef FlutterGenl10nCommand = Future<void> Function({
  required String cwd,
  required Logger logger,
});

/// Flutter CLI
abstract class Flutter {
  /// Determine whether flutter is installed.
  static Future<bool> installed({
    required Logger logger,
  }) async {
    try {
      await _Cmd.run('flutter', ['--version'], logger: logger);
      return true;
    } catch (_) {
      return false;
    }
  }

  /// Get dependencies (`flutter pub get`).
  static Future<void> pubGet({
    String cwd = '.',
    required Logger logger,
  }) async {
    final progress = logger.progress(
      'Running "flutter pub get" in $cwd ',
    );

    try {
      await _Cmd.run(
        'flutter',
        ['pub', 'get'],
        workingDirectory: cwd,
        logger: logger,
      );
    } catch (_) {
      progress.fail();
      rethrow;
    }

    progress.complete();
  }

  /// Get dependencies (`flutter pub get`).
  static Future<void> pubAdd({
    String cwd = '.',
    required List<String> packages,
    required Logger logger,
  }) async {
    final progress = logger.progress(
      'Running "flutter pub add ${packages.join(' ')}" in $cwd ',
    );

    try {
      await _Cmd.run(
        'flutter',
        [
          'pub',
          'add',
          ...packages,
        ],
        workingDirectory: cwd,
        logger: logger,
      );
    } catch (_) {
      progress.fail();
      rethrow;
    }

    progress.complete();
  }

  /// Get dependencies (`flutter pub get`).
  static Future<void> pubRemove({
    String cwd = '.',
    required List<String> packages,
    required Logger logger,
  }) async {
    final progress = logger.progress(
      'Running "flutter pub remove ${packages.join(' ')}" in $cwd ',
    );

    try {
      await _Cmd.run(
        'flutter',
        ['pub', 'remove', ...packages],
        workingDirectory: cwd,
        logger: logger,
      );
    } catch (_) {
      progress.fail();
      rethrow;
    }

    progress.complete();
  }

  /// Enable Flutter for Android (`flutter config --enable-android`).
  static Future<void> configEnableAndroid({
    required Logger logger,
  }) async {
    final progress = logger.progress(
      'Running "flutter config --enable-android"',
    );

    try {
      await _Cmd.run(
        'flutter',
        ['config', '--enable-android'],
        logger: logger,
      );
    } catch (_) {
      progress.fail();
      rethrow;
    }

    progress.complete();
  }

  /// Enable Flutter for iOS (`flutter config --enable-ios`).
  static Future<void> configEnableIos({
    required Logger logger,
  }) async {
    final progress = logger.progress(
      'Running "flutter config --enable-ios"',
    );

    try {
      await _Cmd.run(
        'flutter',
        ['config', '--enable-ios'],
        logger: logger,
      );
    } catch (_) {
      progress.fail();
      rethrow;
    }

    progress.complete();
  }

  /// Enable Flutter for Linux (`flutter config --enable-linux-desktop`).
  static Future<void> configEnableLinux({
    required Logger logger,
  }) async {
    final progress = logger.progress(
      'Running "flutter config --enable-linux-desktop"',
    );

    try {
      await _Cmd.run(
        'flutter',
        ['config', '--enable-linux-desktop'],
        logger: logger,
      );
    } catch (_) {
      progress.fail();
      rethrow;
    }

    progress.complete();
  }

  /// Enable Flutter for macOS (`flutter config --enable-macos-desktop`).
  static Future<void> configEnableMacos({
    required Logger logger,
  }) async {
    final progress = logger.progress(
      'Running "flutter config --enable-macos-desktop"',
    );

    try {
      await _Cmd.run(
        'flutter',
        ['config', '--enable-macos-desktop'],
        logger: logger,
      );
    } catch (_) {
      progress.fail();
      rethrow;
    }

    progress.complete();
  }

  /// Enable Flutter for Web (`flutter config --enable-web`).
  static Future<void> configEnableWeb({
    required Logger logger,
  }) async {
    final progress = logger.progress(
      'Running "flutter config --enable-web"',
    );

    try {
      await _Cmd.run(
        'flutter',
        ['config', '--enable-web'],
        logger: logger,
      );
    } catch (_) {
      progress.fail();
      rethrow;
    }

    progress.complete();
  }

  /// Enable Flutter for Windows (`flutter config --enable-windows-desktop`).
  static Future<void> configEnableWindows({
    required Logger logger,
  }) async {
    final progress = logger.progress(
      'Running "flutter config --enable-windows-desktop"',
    );

    try {
      await _Cmd.run(
        'flutter',
        ['config', '--enable-windows-desktop'],
        logger: logger,
      );
    } catch (_) {
      progress.fail();
      rethrow;
    }

    progress.complete();
  }

  /// Run code generation (`flutter pub run build_runner build --delete-conflicting-outputs`).
  static Future<void> pubRunBuildRunnerBuildDeleteConflictingOutputs({
    String cwd = '.',
    required Logger logger,
  }) async {
    final progress = logger.progress(
      'Running "flutter pub run build_runner build --delete-conflicting-outputs" in $cwd ',
    );

    try {
      await _Cmd.run(
        'flutter',
        ['pub', 'run', 'build_runner', 'build', '--delete-conflicting-outputs'],
        workingDirectory: cwd,
        logger: logger,
      );
    } catch (_) {
      progress.fail();
      rethrow;
    }

    progress.complete();
  }

  /// Run localization generation (`flutter gen-l10n`).
  static Future<void> genl10n({
    String cwd = '.',
    required Logger logger,
  }) async {
    final progress = logger.progress(
      'Running "flutter gen-l10n" in $cwd ',
    );

    try {
      await _Cmd.run(
        'flutter',
        ['gen-l10n'],
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
