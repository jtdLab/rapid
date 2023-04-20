import 'package:rapid_cli/src/commands/core/platform/add/feature/feature.dart';
import 'package:rapid_cli/src/core/platform.dart';

/// {@template windows_add_feature_command}
/// `rapid windows add feature` command adds a feature to the Windows part of an existing Rapid project.
/// {@endtemplate}
class WindowsAddFeatureCommand extends PlatformAddFeatureCommand {
  /// {@macro windows_add_feature_command}
  WindowsAddFeatureCommand({
    super.logger,
    super.project,
    super.melosBootstrap,
    super.flutterPubGet,
    super.flutterPubRunBuildRunnerBuildDeleteConflictingOutputs,
    super.flutterGenl10n,
    super.dartFormatFix,
  }) : super(
          platform: Platform.windows,
        );
}
