import 'package:rapid_cli/src/commands/core/platform/add/feature/feature.dart';
import 'package:rapid_cli/src/core/platform.dart';

/// {@template mobile_add_feature_command}
/// `rapid mobile add feature` command adds a feature to the Mobile part of an existing Rapid project.
/// {@endtemplate}
class MobileAddFeatureCommand extends PlatformAddFeatureCommand {
  /// {@macro mobile_add_feature_command}
  MobileAddFeatureCommand({
    super.logger,
    super.project,
    super.melosBootstrap,
    super.flutterPubGet,
    super.flutterPubRunBuildRunnerBuildDeleteConflictingOutputs,
    super.flutterGenl10n,
    super.dartFormatFix,
  }) : super(
          platform: Platform.mobile,
        );
}
