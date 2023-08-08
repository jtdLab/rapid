import '../../utils.dart';
import '../base.dart';
import 'feature/add.dart';
import 'feature/remove.dart';

/// {@template platform_feature_command}
/// `rapid <platform> <feature>` work with a feature of the platform part of a
/// Rapid project.
/// {@endtemplate}
class PlatformFeatureCommand extends RapidPlatformFeatureBranchCommand {
  /// {@macro platform_feature_command}
  PlatformFeatureCommand(
    super.project, {
    required super.platform,
    required super.featureName,
  }) {
    addSubcommand(
      PlatformFeatureAddCommand(
        project,
        platform: platform,
        featureName: featureName,
      ),
    );
    addSubcommand(
      PlatformFeatureRemoveCommand(
        project,
        platform: platform,
        featureName: featureName,
      ),
    );
  }

  @override
  String get name => featureName;

  @override
  String get invocation => 'rapid ${platform.name} $featureName <subcommand>';

  @override
  String get description =>
      'Work with $featureName of the ${platform.prettyName} part of a Rapid '
      'project.';
}
