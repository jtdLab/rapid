import '../../../utils.dart';
import '../../base.dart';
import 'remove/bloc.dart';
import 'remove/cubit.dart';

/// {@template platform_feature_remove_command}
/// `rapid <platform> <feature> remove` remove a component from a feature of
/// the platform part of a Rapid project.
/// {@endtemplate}
class PlatformFeatureRemoveCommand extends RapidPlatformFeatureBranchCommand {
  /// {@macro platform_feature_remove_command}
  PlatformFeatureRemoveCommand(
    super.project, {
    required super.platform,
    required super.featureName,
  }) {
    addSubcommand(
      PlatformFeatureRemoveBlocCommand(
        project,
        platform: platform,
        featureName: featureName,
      ),
    );
    addSubcommand(
      PlatformFeatureRemoveCubitCommand(
        project,
        platform: platform,
        featureName: featureName,
      ),
    );
  }

  @override
  String get name => 'remove';

  @override
  String get invocation =>
      'rapid ${platform.name} $featureName remove <component>';

  @override
  String get description =>
      'Remove a component from $featureName of the ${platform.prettyName} part '
      'of a Rapid project.';
}
