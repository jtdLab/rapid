import 'package:mason/mason.dart';
import 'package:rapid_cli/src/commands/ios/feature/add/add.dart';
import 'package:rapid_cli/src/commands/core/platform/feature/feature.dart';
import 'package:rapid_cli/src2/core/platform.dart';
import 'package:rapid_cli/src2/project/project.dart';

/// {@template ios_feature_command}
/// `rapid ios feature` command work with features of the iOS part of an existing Rapid project.
/// {@endtemplate}
class IosFeatureCommand extends PlatformFeatureCommand {
  /// {@macro ios_feature_command}
  IosFeatureCommand({
    Logger? logger,
    required Project project,
  }) : super(
          platform: Platform.ios,
          addCommand: IosFeatureAddCommand(logger: logger, project: project),
        );
}
