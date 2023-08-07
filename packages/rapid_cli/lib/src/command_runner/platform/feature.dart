import '../../utils.dart';
import '../base.dart';
import 'feature/add.dart';
import 'feature/remove.dart';

/// {@template platform_feature_command}
/// `rapid <platform> <feature>` work with a feature of the platform part of a Rapid project.
/// {@endtemplate}
class PlatformFeatureCommand extends RapidPlatformBranchCommand {
  /// {@macro platform_feature_command}
  PlatformFeatureCommand(
    this.featureName,
    super.project, {
    required super.platform,
  }) {
    addSubcommand(
      PlatformFeatureAddCommand(
        featureName,
        project,
        platform: platform,
      ),
    );
    addSubcommand(
      PlatformFeatureRemoveCommand(
        featureName,
        project,
        platform: platform,
      ),
    );
  }

  final String featureName;

  @override
  String get name => featureName;

  @override
  String get invocation => 'rapid ${platform.name} $featureName <subcommand>';

  @override
  String get description =>
      'Work with $featureName of the ${platform.prettyName} part of a Rapid project.';
}
