import 'package:rapid_cli/src/commands/core/platform/remove/feature/feature.dart';
import 'package:rapid_cli/src/core/platform.dart';

/// {@template linux_remove_feature_command}
/// `rapid linux remove feature` command removes a feature from the Linux part of an existing Rapid project.
/// {@endtemplate}
class LinuxRemoveFeatureCommand extends PlatformRemoveFeatureCommand {
  /// {@macro linux_remove_feature_command}
  LinuxRemoveFeatureCommand({
    super.logger,
    super.project,
    super.melosBootstrap,
    super.flutterPubGet,
    super.flutterPubRunBuildRunnerBuildDeleteConflictingOutputs,
  }) : super(
          platform: Platform.linux,
        );
}
