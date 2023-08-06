import '../../../project/platform.dart';
import '../../base.dart';
import '../../util/platform_x.dart';
import 'add/bloc.dart';
import 'add/cubit.dart';

class PlatformFeatureAddCommand extends RapidBranchCommand {
  PlatformFeatureAddCommand(
    this.platform,
    this.featureName,
    super.project,
  ) {
    addSubcommand(
      PlatformFeatureAddBlocCommand(platform, featureName, project),
    );
    addSubcommand(
      PlatformFeatureAddCubitCommand(platform, featureName, project),
    );
  }

  final Platform platform;

  final String featureName;

  @override
  String get name => 'add';

  @override
  String get invocation =>
      'rapid ${platform.name} $featureName add <component>';

  @override
  String get description =>
      'Add components to $featureName of the ${platform.prettyName} part of an existing Rapid project.';
}
