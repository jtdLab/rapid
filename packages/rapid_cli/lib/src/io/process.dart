part of 'io.dart';

@visibleForTesting
const currentProcessManagerZoneKey = #currentProcessManager;

// TODO: better desc

/// The system's process manager. Should be used in place of `dart:io`'s process.
///
/// Can be stubbed during tests by setting a the [currentProcessManagerZoneKey] zone
/// value a [ProcessManager] instance.
ProcessManager get currentProcessManager =>
    Zone.current[currentProcessManagerZoneKey] as ProcessManager? ??
    const LocalProcessManager();
