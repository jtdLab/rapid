import '../../../utils.dart';
import '../../base.dart';
import 'add/bloc.dart';
import 'add/cubit.dart';

/// {@template platform_feature_add_command}
/// `rapid <platform> <feature> add` add a component to a feature of the
/// platform part of a Rapid project.
/// {@endtemplate}
class PlatformFeatureAddCommand extends RapidPlatformFeatureBranchCommand {
  /// {@macro platform_feature_add_command}
  PlatformFeatureAddCommand(
    super.project, {
    required super.platform,
    required super.featureName,
  }) {
    addSubcommand(
      PlatformFeatureAddBlocCommand(
        project,
        platform: platform,
        featureName: featureName,
      ),
    );
    addSubcommand(
      PlatformFeatureAddCubitCommand(
        project,
        platform: platform,
        featureName: featureName,
      ),
    );
  }

  @override
  String get name => 'add';

  @override
  String get invocation =>
      'rapid ${platform.name} $featureName add <component>';

  @override
  String get description =>
      'Add a component to $featureName of the ${platform.prettyName} part of a '
      'Rapid project.';
}
