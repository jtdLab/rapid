import 'package:rapid_cli/src/command_runner/util/platform_x.dart';
import 'package:rapid_cli/src/core/platform.dart';

import '../../../base.dart';
import '../../../util/class_name_rest.dart';
import '../../../util/output_dir_option.dart';

class PlatformFeatureAddBlocCommand extends RapidLeafCommand
    with ClassNameGetter, OutputDirGetter {
  PlatformFeatureAddBlocCommand(
    this.platform,
    this.featureName,
    super.project,
  ) {
    argParser
      ..addSeparator('')
      ..addOutputDirOption(
        help: 'The output directory relative to <feature_package>/lib/src .',
      );
  }

  final Platform platform;
  final String featureName;

  @override
  String get name => 'bloc';

  @override
  String get invocation =>
      'rapid ${platform.name} $featureName add bloc <name> [arguments]';

  @override
  String get description =>
      'Adds a bloc to $featureName of the ${platform.prettyName} part of an existing Rapid project.';

  @override
  Future<void> run() {
    final name = super.className;
    final featureName = this.featureName;
    final outputDir = super.outputDir;

    return rapid.platformFeatureAddBloc(
      platform,
      name: name,
      featureName: featureName,
      outputDir: outputDir,
    );
  }
}
