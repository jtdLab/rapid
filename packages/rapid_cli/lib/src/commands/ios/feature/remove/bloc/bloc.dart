import 'package:rapid_cli/src/commands/core/platform/feature/remove/bloc/bloc.dart';
import 'package:rapid_cli/src/core/platform.dart';

/// {@template ios_feature_remove_bloc_command}
/// `rapid ios feature remove bloc` command removes a bloc from a feature of the iOS part of an existing Rapid project.
/// {@endtemplate}
class IosFeatureRemoveBlocCommand extends PlatformFeatureRemoveBlocCommand {
  /// {@macro ios_feature_remove_bloc_command}
  IosFeatureRemoveBlocCommand({
    super.logger,
    super.project,
    super.flutterPubGet,
    super.flutterPubRunBuildRunnerBuildDeleteConflictingOutputs,
  }) : super(
          platform: Platform.ios,
        );
}
