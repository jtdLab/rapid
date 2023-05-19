import 'package:mason/mason.dart';
import 'package:rapid_cli/src/commands/android/feature/add/add.dart';
import 'package:rapid_cli/src/commands/android/feature/remove/remove.dart';
import 'package:rapid_cli/src/commands/core/platform/feature/feature.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/project/platform_directory/platform_features_directory/platform_feature_package/platform_feature_package.dart';
import 'package:rapid_cli/src/project/project.dart';

/// {@template android_feature_command}
/// `rapid android feature` command work with features of the Android part of an existing Rapid project.
/// {@endtemplate}
class AndroidFeatureCommand extends PlatformFeatureCommand {
  /// {@macro android_feature_command}
  AndroidFeatureCommand({
    Logger? logger,
    Project? project,
    required PlatformFeaturePackage featurePackage,
  }) : super(
          platform: Platform.android,
          featurePackage: featurePackage,
          addCommand: AndroidFeatureAddCommand(
            logger: logger,
            project: project,
            featurePackage: featurePackage,
          ),
          removeCommand: AndroidFeatureRemoveCommand(
            logger: logger,
            project: project,
            featurePackage: featurePackage,
          ),
        );
}
