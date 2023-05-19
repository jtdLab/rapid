import 'package:rapid_cli/src/commands/core/platform/feature/remove/cubit/cubit.dart';
import 'package:rapid_cli/src/core/platform.dart';

/// {@template macos_feature_remove_cubit_command}
/// `rapid macos feature remove cubit` command removes a cubit from a feature of the macOS part of an existing Rapid project.
/// {@endtemplate}
class MacosFeatureRemoveCubitCommand extends PlatformFeatureRemoveCubitCommand {
  /// {@macro macos_feature_remove_cubit_command}
  MacosFeatureRemoveCubitCommand({
    super.logger,
    super.project,
    required super.featurePackage,
    super.flutterPubGet,
    super.flutterPubRunBuildRunnerBuildDeleteConflictingOutputs,
  }) : super(
          platform: Platform.macos,
        );
}
