import 'package:flutter/foundation.dart';

class TargetPlatformError implements Exception {
  final String msg;

  TargetPlatformError() : msg = 'TargetPlatform must be Web';
}

/// Override this in tests when simulating web as the current platform.
@visibleForTesting
bool? isWebOverrides;

/// Runs [callback] when on Web.
Future<void> runOnWeb(Future<void> Function() callback) async {
  if (isWebOverrides ?? kIsWeb) {
    return callback();
  }

  throw TargetPlatformError();
}
