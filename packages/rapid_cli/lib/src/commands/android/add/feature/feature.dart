import 'package:rapid_cli/src/commands/core/platform/add/feature/feature.dart';
import 'package:rapid_cli/src/core/platform.dart';

/// {@template android_add_feature_command}
/// `rapid android add feature` command adds a feature to the Android part of an existing Rapid project.
/// {@endtemplate}
class AndroidAddFeatureCommand extends PlatformAddFeatureCommand {
  /// {@macro android_add_feature_command}
  AndroidAddFeatureCommand({
    super.logger,
    required super.project,
    super.melosBootstrap,
    super.melosClean,
    super.flutterPubGet,
    super.flutterPubRunBuildRunnerBuildDeleteConflictingOutputs,
    super.flutterFormatFix,
    super.generator,
  }) : super(
          platform: Platform.android,
        );
}
