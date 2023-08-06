import 'package:args/args.dart';
import 'package:meta/meta.dart';

import '../base.dart';

/// Adds description option.
extension DescriptionOption on ArgParser {
  /// Adds `--desc` option.
  void addDescriptionOption({required String help, String? defaultsTo}) {
    addOption(
      'desc',
      help: help,
      defaultsTo: defaultsTo,
    );
  }
}

/// Adds `desc` getter.
mixin DescriptionGetter on RapidLeafCommand {
  /// Returns the description specified by the user.
  @protected
  String? get desc => argResults['desc'] as String?;
}
