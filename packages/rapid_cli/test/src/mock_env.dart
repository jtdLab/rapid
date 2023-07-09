import 'dart:async';

import 'package:platform/platform.dart';
import 'package:process/process.dart';
import 'package:rapid_cli/src/platform.dart';
import 'package:rapid_cli/src/process.dart';

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

/// Overrides the current process manager in [testBody] with [manager].
FutureOr<void> Function() withMockProcess(
  FutureOr<void> Function() testBody, {
  required ProcessManager manager,
}) {
  return () async {
    return runZoned(
      testBody,
      zoneValues: {
        currentProcessManagerZoneKey: manager,
      },
    );
  };
}
