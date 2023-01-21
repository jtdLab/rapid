import 'package:mason/mason.dart';
import 'package:rapid_cli/src/commands/android/feature/add/add.dart';
import 'package:rapid_cli/src/commands/core/platform/feature/feature.dart';
import 'package:rapid_cli/src2/core/platform.dart';
import 'package:rapid_cli/src2/project/project.dart';

/// {@template android_feature_command}
/// `rapid android feature` command work with features of the Android part of an existing Rapid project.
/// {@endtemplate}
class AndroidFeatureCommand extends PlatformFeatureCommand {
  /// {@macro android_feature_command}
  AndroidFeatureCommand({
    Logger? logger,
    required Project project,
  }) : super(
          platform: Platform.android,
          addCommand:
              AndroidFeatureAddCommand(logger: logger, project: project),
        );
}
