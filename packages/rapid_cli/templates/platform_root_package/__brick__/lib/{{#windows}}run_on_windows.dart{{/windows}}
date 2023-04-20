import 'package:flutter/foundation.dart';

class TargetPlatformError implements Exception {
  final String msg;

  TargetPlatformError() : msg = 'TargetPlatform must be Windows';
}

/// Runs [callback] when on Windows.
Future<void> runOnWindows(Future<void> Function() callback) async {
  if (defaultTargetPlatform == TargetPlatform.windows) {
    return callback();
  }

  throw TargetPlatformError();
}
