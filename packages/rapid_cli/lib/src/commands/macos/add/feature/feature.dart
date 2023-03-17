import 'package:rapid_cli/src/commands/core/platform/add/feature/feature.dart';
import 'package:rapid_cli/src/core/platform.dart';

/// {@template macos_add_feature_command}
/// `rapid macos add feature` command adds a feature to the macOS part of an existing Rapid project.
/// {@endtemplate}
class MacosAddFeatureCommand extends PlatformAddFeatureCommand {
  /// {@macro macos_add_feature_command}
  MacosAddFeatureCommand({
    super.logger,
    required super.project,
    super.melosBootstrap,
    super.flutterPubGet,
    super.flutterPubRunBuildRunnerBuildDeleteConflictingOutputs,
    super.flutterGenl10n,
    super.dartFormatFix,
  }) : super(
          platform: Platform.macos,
        );
}
