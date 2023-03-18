import 'package:flutter/foundation.dart';

class TargetPlatformError implements Exception {
  final String msg;

  TargetPlatformError() : msg = 'TargetPlatform must be Android';
}

/// Runs [callback] when on Android.
Future<void> runOnAndroid(Future<void> Function() callback) async {
  if (defaultTargetPlatform == TargetPlatform.android) {
    return callback();
  }

  throw TargetPlatformError();
}
