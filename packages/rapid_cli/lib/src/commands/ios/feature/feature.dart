import 'package:mason/mason.dart';
import 'package:rapid_cli/src/commands/ios/feature/add/add.dart';
import 'package:rapid_cli/src/commands/core/platform/feature/feature.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/project/project.dart';

/// {@template android_feature_command}
/// `rapid ios feature` command work with features of the iOS part of an existing Rapid project.
/// {@endtemplate}
class AndroidFeatureCommand extends PlatformFeatureCommand {
  /// {@macro android_feature_command}
  AndroidFeatureCommand({
    Logger? logger,
    required Project project,
  }) : super(
          platform: Platform.ios,
          addCommand:
              AndroidFeatureAddCommand(logger: logger, project: project),
        );
}
