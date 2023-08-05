import 'package:flutter/foundation.dart';

class TargetPlatformError implements Exception {
  final String msg;

  TargetPlatformError() : msg = 'TargetPlatform must be iOS';
}

/// Runs [callback] when on iOS.
Future<void> runOnIos(Future<void> Function() callback) async {
  if (defaultTargetPlatform == TargetPlatform.iOS) {
    return callback();
  }

  throw TargetPlatformError();
}
