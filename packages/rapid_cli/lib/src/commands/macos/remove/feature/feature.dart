import 'package:rapid_cli/src/commands/core/platform/remove/feature/feature.dart';
import 'package:rapid_cli/src/core/platform.dart';

/// {@template macos_remove_feature_command}
/// `rapid macos remove feature` command removes a feature from the macOS part of an existing Rapid project.
/// {@endtemplate}
class MacosRemoveFeatureCommand extends PlatformRemoveFeatureCommand {
  /// {@macro macos_remove_feature_command}
  MacosRemoveFeatureCommand({
    super.logger,
    required super.project,
    super.melosBootstrap,
    super.flutterPubGet,
    super.flutterPubRunBuildRunnerBuildDeleteConflictingOutputs,
  }) : super(
          platform: Platform.macos,
        );
}
