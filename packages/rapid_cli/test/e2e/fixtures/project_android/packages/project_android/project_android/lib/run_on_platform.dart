import 'package:flutter/foundation.dart';

/// Override this in tests when simulating web as the current platform.
@visibleForTesting
bool? isWebOverrides;

/// Runs the callback provided depending on platform the application runs on.
Future<void> runOnPlatform({
  Future<void> Function()? android,
  Future<void> Function()? ios,
  Future<void> Function()? web,
  Future<void> Function()? linux,
  Future<void> Function()? macos,
  Future<void> Function()? windows,
}) async {
  if (isWebOverrides ?? kIsWeb) {
    return web?.call();
  } else {
    if (defaultTargetPlatform == TargetPlatform.android) {
      return android?.call();
    }
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      return ios?.call();
    }
    if (defaultTargetPlatform == TargetPlatform.macOS) {
      return macos?.call();
    }
    if (defaultTargetPlatform == TargetPlatform.linux) {
      return linux?.call();
    }
    if (defaultTargetPlatform == TargetPlatform.windows) {
      return windows?.call();
    }
  }
}
