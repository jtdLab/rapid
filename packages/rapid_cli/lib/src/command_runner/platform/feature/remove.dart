import '../../../utils.dart';
import '../../base.dart';
import 'remove/bloc.dart';
import 'remove/cubit.dart';

/// {@template platform_feature_remove_command}
/// `rapid <platform> <feature> remove` remove a component from a feature of the platform part of a Rapid project.
/// {@endtemplate}
class PlatformFeatureRemoveCommand extends RapidPlatformBranchCommand {
  /// {@macro platform_feature_remove_command}
  PlatformFeatureRemoveCommand(
    this.featureName,
    super.project, {
    required super.platform,
  }) {
    addSubcommand(
      PlatformFeatureRemoveBlocCommand(
        featureName,
        project,
        platform: platform,
      ),
    );
    addSubcommand(
      PlatformFeatureRemoveCubitCommand(
        featureName,
        project,
        platform: platform,
      ),
    );
  }

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
