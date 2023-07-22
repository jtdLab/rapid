import 'package:rapid_cli/src/command_runner/util/platform_x.dart';
import 'package:rapid_cli/src/project/platform.dart';

import '../../base.dart';
import 'remove/bloc.dart';
import 'remove/cubit.dart';

class PlatformFeatureRemoveCommand extends RapidBranchCommand {
  PlatformFeatureRemoveCommand(
    this.platform,
    this.featureName,
    super.project,
  ) {
    addSubcommand(
      PlatformFeatureRemoveBlocCommand(platform, featureName, project),
    );
    addSubcommand(
      PlatformFeatureRemoveCubitCommand(platform, featureName, project),
    );
  }

  final Platform platform;
  final String featureName;

  @override
  String get name => 'remove';

  @override
  String get invocation =>
      'rapid ${platform.name} $featureName remove <component>';

  @override
  String get description =>
      'Remove components from $featureName of the ${platform.prettyName} part of an existing Rapid project.';
}
