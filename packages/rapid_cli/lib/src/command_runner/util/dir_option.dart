import 'package:args/args.dart';
import 'package:meta/meta.dart';

import '../base.dart';

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
      abbr: 'd',
    );
  }
}

/// Adds `dir` getter.
mixin DirGetter on RapidLeafCommand {
  /// Gets the directory specified by the user.
  ///
  /// Returns [_defaultDir] when no directory was specified.
  @protected
  String get dir => argResults['dir'] ?? _defaultDir;
}
