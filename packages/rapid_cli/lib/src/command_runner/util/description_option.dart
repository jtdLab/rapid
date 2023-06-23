import 'package:args/args.dart';
import 'package:meta/meta.dart';

import '../base.dart';

/// The default description.
const _defaultDescription = 'A Rapid app.';

/// Adds description option.
extension DescriptionOption on ArgParser {
  /// Adds `--desc` option.
  void addDescriptionOption({required String help}) {
    addOption(
      'desc',
      help: help,
      defaultsTo: _defaultDescription,
    );
  }
}

/// Adds `desc` getter.
mixin DescriptionGetter on RapidLeafCommand {
  /// Gets description specified by the user.
  ///
  /// Returns [_defaultDescription] when no description specified.
  @protected
  String get desc => argResults['desc'] ?? _defaultDescription;
}
