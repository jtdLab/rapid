import 'dart:async';

import 'package:platform/platform.dart';
import 'package:process/process.dart';
import 'package:rapid_cli/src/platform.dart';
import 'package:rapid_cli/src/process.dart';

import 'mocks.dart';

// TODO needed?

/// Overrides the current platform in [testBody] with [platform].
FutureOr<void> withMockPlatform(
  FutureOr<void> Function() testBody, {
  required Platform platform,
}) {
  return runZoned(
    testBody,
    zoneValues: {
      currentPlatformZoneKey: platform,
    },
  );
}

/// Overrides the current process manager in [testBody] with [manager].
FutureOr<void> withMockProcessManager(
  FutureOr<void> Function() testBody, {
  ProcessManager? manager,
}) {
  manager ??= MockProcessManager();

  return runZoned(
    testBody,
    zoneValues: {
      currentProcessManagerZoneKey: manager,
    },
  );
}
