import 'package:flutter/foundation.dart';

class TargetPlatformError implements Exception {
  final String msg;

  TargetPlatformError() : msg = 'TargetPlatform must be Linux';
}

/// Runs [callback] when on Linux.
Future<void> runOnLinux(Future<void> Function() callback) async {
  if (defaultTargetPlatform == TargetPlatform.linux) {
    return callback();
  }

  throw TargetPlatformError();
}
