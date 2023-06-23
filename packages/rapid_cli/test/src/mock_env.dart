import 'dart:async';

import 'package:platform/platform.dart';
import 'package:rapid_cli/src/platform.dart';

/// Overrides the current platform in [testBody] with [platform].
FutureOr<void> Function() withMockPlatform(
  FutureOr<void> Function() testBody, {
  required Platform platform,
}) {
  return () async {
    return runZoned(
      testBody,
      zoneValues: {
        currentPlatformZoneKey: platform,
      },
    );
  };
}
