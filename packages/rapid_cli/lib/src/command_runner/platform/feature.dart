import 'package:rapid_cli/src/command_runner/util/platform_x.dart';
import 'package:rapid_cli/src/core/platform.dart';

import '../base.dart';
import 'feature/add.dart';
import 'feature/remove.dart';

class PlatformFeatureCommand extends RapidBranchCommand {
  PlatformFeatureCommand(this.platform, this.featureName, super.project) {
    addSubcommand(
      PlatformFeatureAddCommand(
        platform,
        featureName,
        project,
      ),
    );
    addSubcommand(
      PlatformFeatureRemoveCommand(
        platform,
        featureName,
        project,
      ),
    );
  }

  final Platform platform;
  final String featureName;

  @override
  String get name => featureName;

  @override
  String get invocation => 'rapid ${platform.name} $featureName <subcommand>';

  @override
  String get description =>
      'Work with $featureName of the ${platform.prettyName} part of an existing Rapid project.';
}
