import 'package:flutter/foundation.dart';

class TargetPlatformError implements Exception {
  final String msg;

  TargetPlatformError() : msg = 'TargetPlatform must be macOS';
}

/// Runs [callback] when on macOS.
Future<void> runOnMacos(Future<void> Function() callback) async {
  if (defaultTargetPlatform == TargetPlatform.macOS) {
    return callback();
  }

  throw TargetPlatformError();
}
