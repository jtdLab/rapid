import 'package:rapid_cli/src/commands/core/platform/feature/remove/bloc/bloc.dart';
import 'package:rapid_cli/src/core/platform.dart';

/// {@template linux_feature_remove_bloc_command}
/// `rapid linux feature remove bloc` command removes a bloc from a feature of the Linux part of an existing Rapid project.
/// {@endtemplate}
class LinuxFeatureRemoveBlocCommand extends PlatformFeatureRemoveBlocCommand {
  /// {@macro linux_feature_remove_bloc_command}
  LinuxFeatureRemoveBlocCommand({
    super.logger,
    super.project,
    super.flutterPubGet,
    super.flutterPubRunBuildRunnerBuildDeleteConflictingOutputs,
  }) : super(
          platform: Platform.linux,
        );
}
