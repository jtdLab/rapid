import 'package:rapid_cli/src/command_runner/util/platform_x.dart';
import 'package:rapid_cli/src/core/platform.dart';

import '../../../base.dart';
import '../../../util/class_name_rest.dart';
import '../../../util/dir_option.dart';

class PlatformFeatureRemoveBlocCommand extends RapidLeafCommand
    with ClassNameGetter, DirGetter {
  PlatformFeatureRemoveBlocCommand(
    this.platform,
    this.featureName,
    super.project,
  ) {
    argParser
      ..addSeparator('')
      ..addDirOption(
        help: 'The directory relative to <feature_package>/lib/src .',
      );
  }

  final Platform platform;
  final String featureName;

  @override
  String get name => 'bloc';

  @override
  String get invocation =>
      'rapid ${platform.name} $featureName remove bloc <name> [arguments]';

  @override
  String get description =>
      'Removes a bloc from $featureName of the ${platform.prettyName} part of an existing Rapid project.';

  @override
  Future<void> run() {
    final name = super.className;
    final featureName = this.featureName;
    final dir = super.dir;

    return rapid.platformFeatureRemoveBloc(
      platform,
      name: name,
      featureName: featureName,
      dir: dir,
    );
  }
}
