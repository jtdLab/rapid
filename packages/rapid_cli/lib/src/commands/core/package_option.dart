import 'package:args/args.dart';
import 'package:meta/meta.dart';

import 'overridable_arg_results.dart';

/// Adds package option.
extension PackageOption on ArgParser {
  /// Adds `--package` option.
  void addPackageOption({required String help}) {
    addOption(
      'package',
      help: help,
      abbr: 'p',
    );
  }
}

/// Adds `package` getter.
mixin PackageGetter on OverridableArgResults {
  /// Gets the package specified by the user.
  ///
  /// Returns [_defaultPackage] when no package was specified.
  @protected
  String? get package => argResults['package'];
}
