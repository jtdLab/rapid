import 'package:args/args.dart';
import 'package:meta/meta.dart';

import '../base.dart';

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
mixin PackageGetter on RapidLeafCommand {
  /// Returns the package specified by the user.
  @protected
  String? get package => argResults['package'] as String?;
}
