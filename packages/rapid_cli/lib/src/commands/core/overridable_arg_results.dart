import 'package:args/args.dart';
import 'package:args/command_runner.dart';
import 'package:meta/meta.dart';

/// Adds overridable [ArgResults].
///
/// These can be used for testing parameters specified by the user.
///
/// This mixin is commonly used in rapid commands that take user parameters.
mixin OverridableArgResults on Command<int> {
  /// [ArgResults] which can be overridden for testing.
  @visibleForTesting
  ArgResults? argResultOverrides;

  /// The argResults that contain parameters specified by the user.
  @protected
  @override
  ArgResults get argResults => argResultOverrides ?? super.argResults!;
}
