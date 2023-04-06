import 'package:mason/mason.dart';
import 'package:rapid_cli/src/commands/core/platform/feature/feature.dart';
import 'package:rapid_cli/src/commands/ios/feature/add/add.dart';
import 'package:rapid_cli/src/commands/ios/feature/remove/remove.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/project/project.dart';

/// {@template ios_feature_command}
/// `rapid ios feature` command work with features of the iOS part of an existing Rapid project.
/// {@endtemplate}
class IosFeatureCommand extends PlatformFeatureCommand {
  /// {@macro ios_feature_command}
  IosFeatureCommand({
    Logger? logger,
    Project? project,
  }) : super(
          platform: Platform.ios,
          addCommand: IosFeatureAddCommand(logger: logger, project: project),
          removeCommand:
              IosFeatureRemoveCommand(logger: logger, project: project),
        );
}
