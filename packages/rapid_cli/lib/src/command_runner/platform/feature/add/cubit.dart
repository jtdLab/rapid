import 'package:rapid_cli/src/command_runner/util/platform_x.dart';
import 'package:rapid_cli/src/project/platform.dart';

import '../../../base.dart';
import '../../../util/class_name_rest.dart';
import '../../../util/output_dir_option.dart';

class PlatformFeatureAddCubitCommand extends RapidLeafCommand
    with ClassNameGetter, OutputDirGetter {
  PlatformFeatureAddCubitCommand(
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
  String get name => 'cubit';

  @override
  String get invocation =>
      'rapid ${platform.name} $featureName add cubit <name> [arguments]';

  @override
  String get description =>
      'Adds a cubit to $featureName of the ${platform.prettyName} part of an existing Rapid project.';

  @override
  Future<void> run() {
    final name = super.className;
    final featureName = this.featureName;
    final outputDir = super.outputDir;

    return rapid.platformFeatureAddCubit(
      platform,
      name: name,
      featureName: featureName,
      outputDir: outputDir,
    );
  }
}
