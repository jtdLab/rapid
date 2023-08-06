import '../../project/platform.dart';
import '../base.dart';
import '../util/platform_x.dart';
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
