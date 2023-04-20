import 'package:rapid_cli/src/commands/core/platform/add/feature/feature.dart';
import 'package:rapid_cli/src/core/platform.dart';

/// {@template ios_add_feature_command}
/// `rapid ios add feature` command adds a feature to the iOS part of an existing Rapid project.
/// {@endtemplate}
class IosAddFeatureCommand extends PlatformAddFeatureCommand {
  /// {@macro ios_add_feature_command}
  IosAddFeatureCommand({
    super.logger,
    super.project,
    super.melosBootstrap,
    super.flutterPubGet,
    super.flutterPubRunBuildRunnerBuildDeleteConflictingOutputs,
    super.flutterGenl10n,
    super.dartFormatFix,
  }) : super(
          platform: Platform.ios,
        );
}
