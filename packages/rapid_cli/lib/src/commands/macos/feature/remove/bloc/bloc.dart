import 'package:rapid_cli/src/commands/core/platform/feature/remove/bloc/bloc.dart';
import 'package:rapid_cli/src/core/platform.dart';

/// {@template macos_feature_remove_bloc_command}
/// `rapid macos feature remove bloc` command removes a bloc from a feature of the macOS part of an existing Rapid project.
/// {@endtemplate}
class MacosFeatureRemoveBlocCommand extends PlatformFeatureRemoveBlocCommand {
  /// {@macro macos_feature_remove_bloc_command}
  MacosFeatureRemoveBlocCommand({
    super.logger,
    super.project,
    super.flutterPubGet,
    super.flutterPubRunBuildRunnerBuildDeleteConflictingOutputs,
  }) : super(
          platform: Platform.macos,
        );
}
