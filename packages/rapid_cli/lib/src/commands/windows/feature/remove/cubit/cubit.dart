import 'package:rapid_cli/src/commands/core/platform/feature/remove/cubit/cubit.dart';
import 'package:rapid_cli/src/core/platform.dart';

/// {@template windows_feature_remove_cubit_command}
/// `rapid windows feature remove cubit` command removes a cubit from a feature of the Windows part of an existing Rapid project.
/// {@endtemplate}
class WindowsFeatureRemoveCubitCommand
    extends PlatformFeatureRemoveCubitCommand {
  /// {@macro windows_feature_remove_cubit_command}
  WindowsFeatureRemoveCubitCommand({
    super.logger,
    super.project,
    super.flutterPubGet,
    super.flutterPubRunBuildRunnerBuildDeleteConflictingOutputs,
  }) : super(
          platform: Platform.windows,
        );
}
