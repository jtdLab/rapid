import 'package:rapid_cli/src/commands/core/platform/feature/remove/cubit/cubit.dart';
import 'package:rapid_cli/src/core/platform.dart';

/// {@template android_feature_remove_cubit_command}
/// `rapid android feature remove cubit` command removes a cubit from a feature of the Android part of an existing Rapid project.
/// {@endtemplate}
class AndroidFeatureRemoveCubitCommand
    extends PlatformFeatureRemoveCubitCommand {
  /// {@macro android_feature_remove_cubit_command}
  AndroidFeatureRemoveCubitCommand({
    super.logger,
    super.project,
    super.flutterPubGet,
    super.flutterPubRunBuildRunnerBuildDeleteConflictingOutputs,
  }) : super(
          platform: Platform.android,
        );
}
