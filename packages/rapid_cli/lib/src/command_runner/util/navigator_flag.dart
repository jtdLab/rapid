import 'package:args/args.dart';
import 'package:meta/meta.dart';

import '../base.dart';

/// The default navigator.
const _defaultNavigator = false;

/// Adds navigator flag.
extension NavigatorFlag on ArgParser {
  /// Adds `--navigator` flag.
  void addNavigatorFlag() {
    addFlag(
      'navigator',
      help: 'Whether to generate a navigator for the new feature.',
      negatable: false,
    );
  }
}

/// Adds `navigator` getter.
mixin NavigatorGetter on RapidLeafCommand {
  /// Gets navigator specified by the user.
  ///
  /// Returns [_defaultNavigator] when no navigator specified.
  @protected
  bool get navigator => argResults['navigator'] ?? _defaultNavigator;
}
