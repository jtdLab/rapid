import 'package:args/args.dart';
import 'package:args/command_runner.dart';
import 'package:meta/meta.dart';

/// Adds overridable [ArgResults].
///
/// These can be used for testing parameters specified by the user.
mixin OverridableArgResults on Command<int> {
  /// [ArgResults] which can be overridden for testing.
  @visibleForTesting
  ArgResults? argResultOverrides;

  /// Gets the argResults that contain parameters specified by the user.
  @override
  ArgResults get argResults => argResultOverrides ?? super.argResults!;
}
