import 'dart:io' as io;

import 'package:flutter/foundation.dart';

/// Runs the callback provided depending on platform the application runs on.
Future<void> runOnPlatform({
  Future<void> Function()? android,
  Future<void> Function()? ios,
  Future<void> Function()? web,
  Future<void> Function()? linux,
  Future<void> Function()? macos,
  Future<void> Function()? windows,
}) async {
  if (kIsWeb) {
    await web?.call();
    return;
  } else {
    if (io.Platform.isAndroid) {
      await android?.call();
      return;
    }
    if (io.Platform.isIOS) {
      await ios?.call();
      return;
    }
    if (io.Platform.isMacOS) {
      await macos?.call();
      return;
    }
    if (io.Platform.isLinux) {
      await linux?.call();
      return;
    }
    if (io.Platform.isWindows) {
      await windows?.call();
      return;
    }
  }
}
