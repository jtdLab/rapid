import 'package:mason/mason.dart';
import 'package:rapid_cli/src/commands/android/feature/add/add.dart';
import 'package:rapid_cli/src/commands/core/platform/feature/feature.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/project/project.dart';

/// {@template android_feature_command}
/// `rapid android feature` command work with features of the Android part of an existing Rapid project.
/// {@endtemplate}
class FeatureCommand extends PlatformFeatureCommand {
  /// {@macro android_feature_command}
  FeatureCommand({
    Logger? logger,
    required Project project,
  }) : super(
          platform: Platform.android,
          addCommand: AddCommand(logger: logger, project: project),
        );
}
