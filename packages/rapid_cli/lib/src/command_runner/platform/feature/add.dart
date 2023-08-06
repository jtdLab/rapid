import '../../../project/platform.dart';
import '../../../utils.dart';
import '../../base.dart';
import 'add/bloc.dart';
import 'add/cubit.dart';

/// {@template platform_feature_add_command}
/// `rapid <platform> <feature> add` add a component to a feature of the platform part of a Rapid project.
/// {@endtemplate}
class PlatformFeatureAddCommand extends RapidBranchCommand {
  /// {@macro platform_feature_add_command}
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
      'Add a component to $featureName of the ${platform.prettyName} part of a Rapid project.';
}
