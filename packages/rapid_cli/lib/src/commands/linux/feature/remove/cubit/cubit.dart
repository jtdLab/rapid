import 'package:rapid_cli/src/commands/core/platform/feature/remove/cubit/cubit.dart';
import 'package:rapid_cli/src/core/platform.dart';

/// {@template linux_feature_remove_cubit_command}
/// `rapid linux feature remove cubit` command removes a cubit from a feature of the Linux part of an existing Rapid project.
/// {@endtemplate}
class LinuxFeatureRemoveCubitCommand extends PlatformFeatureRemoveCubitCommand {
  /// {@macro linux_feature_remove_cubit_command}
  LinuxFeatureRemoveCubitCommand({
    super.logger,
    super.project,
    super.flutterPubGet,
    super.flutterPubRunBuildRunnerBuildDeleteConflictingOutputs,
  }) : super(
          platform: Platform.linux,
        );
}
