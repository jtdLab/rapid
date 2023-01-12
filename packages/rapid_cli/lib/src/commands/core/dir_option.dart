import 'package:args/args.dart';

import 'overridable_arg_results.dart';

/// The default directory.
const _defaultDir = '.';

/// Adds directory option.
extension DirOption on ArgParser {
  /// Adds `--dir` option.
  void addDirOption({required String help}) {
    addOption(
      'dir',
      help: help,
      defaultsTo: _defaultDir,
    );
  }
}

/// Adds `dir` getter.
mixin DirGetter on OverridableArgResults {
  /// Gets the directory specified by the user.
  ///
  /// Returns [_defaultDir] when no directory was specified.
  String get dir => argResults['dir'] ?? _defaultDir;
}
