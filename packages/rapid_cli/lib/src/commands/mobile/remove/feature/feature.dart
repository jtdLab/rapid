import 'package:rapid_cli/src/commands/core/platform/remove/feature/feature.dart';
import 'package:rapid_cli/src/core/platform.dart';

/// {@template mobile_remove_feature_command}
/// `rapid mobile remove feature` command removes a feature from the Mobile part of an existing Rapid project.
/// {@endtemplate}
class MobileRemoveFeatureCommand extends PlatformRemoveFeatureCommand {
  /// {@macro mobile_remove_feature_command}
  MobileRemoveFeatureCommand({
    super.logger,
    super.project,
    super.melosBootstrap,
    super.flutterPubGet,
    super.flutterPubRunBuildRunnerBuildDeleteConflictingOutputs,
  }) : super(
          platform: Platform.mobile,
        );
}
