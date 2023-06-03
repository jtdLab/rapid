import 'package:rapid_cli/src/command_runner/util/platform_x.dart';
import 'package:rapid_cli/src/core/platform.dart';

import '../../../base.dart';
import '../../../util/class_name_rest.dart';
import '../../../util/dir_option.dart';

class PlatformFeatureRemoveCubitCommand extends RapidLeafCommand
    with ClassNameGetter, DirGetter {
  PlatformFeatureRemoveCubitCommand(
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
  String get name => 'cubit';

  @override
  String get invocation =>
      'rapid ${platform.name} $featureName remove cubit <name> [arguments]';

  @override
  String get description =>
      'Removes a cubit from $featureName of the ${platform.prettyName} part of an existing Rapid project.';

  @override
  Future<void> run() {
    final name = super.className;
    final featureName = this.featureName;
    final dir = super.dir;

    return rapid.platformFeatureRemoveCubit(
      platform,
      name: name,
      featureName: featureName,
      dir: dir,
    );
  }
}
