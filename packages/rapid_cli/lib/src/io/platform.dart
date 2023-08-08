part of 'io.dart';

@visibleForTesting
// ignore: public_member_api_docs
const currentPlatformZoneKey = #currentPlatform;

/// The system's platform. Should be used in place of `io`'s [Platform].
///
/// Can be stubbed during tests by setting a the [currentPlatformZoneKey] zone
/// value a [Platform] instance.
Platform get currentPlatform =>
    Zone.current[currentPlatformZoneKey] as Platform? ?? const LocalPlatform();
