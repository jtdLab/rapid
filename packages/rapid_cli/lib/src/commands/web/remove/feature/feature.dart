import 'package:rapid_cli/src/commands/core/platform/remove/feature/feature.dart';
import 'package:rapid_cli/src/core/platform.dart';

/// {@template web_remove_feature_command}
/// `rapid web remove feature` command removes a feature from the Web part of an existing Rapid project.
/// {@endtemplate}
class WebRemoveFeatureCommand extends PlatformRemoveFeatureCommand {
  /// {@macro web_remove_feature_command}
  WebRemoveFeatureCommand({
    super.logger,
    super.project,
    super.melosBootstrap,
    super.flutterPubGet,
    super.flutterPubRunBuildRunnerBuildDeleteConflictingOutputs,
  }) : super(
          platform: Platform.web,
        );
}
