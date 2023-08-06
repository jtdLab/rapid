import '../../../project/platform.dart';
import '../../../utils.dart';
import '../../base.dart';
import 'remove/bloc.dart';
import 'remove/cubit.dart';

/// {@template platform_feature_remove_command}
/// `rapid <platform> <feature> remove` remove a component from a feature of the platform part of a Rapid project.
/// {@endtemplate}
class PlatformFeatureRemoveCommand extends RapidBranchCommand {
  /// {@macro platform_feature_remove_command}
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
      'Remove a component from $featureName of the ${platform.prettyName} part of a Rapid project.';
}
