import 'package:rapid_cli/src/commands/core/platform/feature/remove/bloc/bloc.dart';
import 'package:rapid_cli/src/core/platform.dart';

/// {@template android_feature_remove_bloc_command}
/// `rapid android feature remove bloc` command removes a bloc from a feature of the Android part of an existing Rapid project.
/// {@endtemplate}
class AndroidFeatureRemoveBlocCommand extends PlatformFeatureRemoveBlocCommand {
  /// {@macro android_feature_remove_bloc_command}
  AndroidFeatureRemoveBlocCommand({
    super.logger,
    super.project,
    required super.featurePackage,
    super.flutterPubGet,
    super.flutterPubRunBuildRunnerBuildDeleteConflictingOutputs,
  }) : super(
          platform: Platform.android,
        );
}
