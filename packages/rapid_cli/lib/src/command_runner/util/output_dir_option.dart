import 'package:args/args.dart';
import 'package:meta/meta.dart';

import '../base.dart';

/// The default output directory.
final _defaultOutputDir = '.';

/// Adds output directory option.
extension OutputDirOption on ArgParser {
  /// Adds `--output-dir`, `--o` option.
  void addOutputDirOption({required String help}) {
    addOption(
      'output-dir',
      help: help,
      defaultsTo: _defaultOutputDir,
      abbr: 'o',
    );
  }
}

/// Adds `outputDir` getter.
mixin OutputDirGetter on RapidLeafCommand {
  /// Gets the output directory specified by the user.
  ///
  /// Returns [_defaultOutputDir] when no output directory was specified.
  @protected
  String get outputDir => argResults['output-dir'] ?? _defaultOutputDir;
}
