import 'dart:async';

import 'package:platform/platform.dart';
import 'package:rapid_cli/src/platform.dart';
import 'package:rapid_cli/src/process.dart';

import 'mock_fs.dart';
import 'mocks.dart';

/// Overrides the current process manager in [testBody] with [manager].
@Deprecated('use withMockEnv instead')
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

/// Runs [testBody] in mock environment suited for unit tests.
///
/// Swaps the underlying file system with an in memory filesystem.
///
/// Overrides the process mangager with a mock that can be used for verification.
///
/// Clients might provide a [platform] to simulate different target platorms.
FutureOr<void> Function() withMockEnv(
  FutureOr<void> Function(ProcessManager processManager) testBody, {
  Platform? platform,
}) {
  return withMockFs(() async {
    final processManager = MockProcessManager();

    return runZoned(
      () => testBody(processManager),
      zoneValues: {
        currentProcessManagerZoneKey: processManager,
        if (platform != null) currentPlatformZoneKey: platform,
      },
    );
  });
}
