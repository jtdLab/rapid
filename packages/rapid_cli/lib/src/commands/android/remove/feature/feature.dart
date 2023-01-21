import 'package:rapid_cli/src/commands/core/platform/remove/feature/feature.dart';
import 'package:rapid_cli/src2/core/platform.dart';

/// {@template android_remove_feature_command}
/// `rapid android remove feature` command removes a feature from the Android part of an existing Rapid project.
/// {@endtemplate}
class AndroidRemoveFeatureCommand extends PlatformRemoveFeatureCommand {
  /// {@macro android_remove_feature_command}
  AndroidRemoveFeatureCommand(
      {super.logger,
      required super.project,
      super.melosBootstrap,
      super.melosClean,
      super.flutterPubGet,
      super.flutterPubRunBuildRunnerBuildDeleteConflictingOutputs})
      : super(
          platform: Platform.android,
        );
}
