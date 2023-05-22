import 'package:mason/mason.dart';
import 'package:rapid_cli/src/commands/core/platform/feature/feature.dart';
import 'package:rapid_cli/src/commands/mobile/feature/add/add.dart';
import 'package:rapid_cli/src/commands/mobile/feature/remove/remove.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/project/project.dart';

/// {@template mobile_feature_command}
/// `rapid mobile feature` command work with features of the Mobile part of an existing Rapid project.
/// {@endtemplate}
class MobileFeatureCommand extends PlatformFeatureCommand {
  /// {@macro mobile_feature_command}
  MobileFeatureCommand({
    Logger? logger,
    Project? project,
    required super.featurePackage,
  }) : super(
          platform: Platform.mobile,
          addCommand: MobileFeatureAddCommand(
            logger: logger,
            project: project,
            featurePackage: featurePackage,
          ),
          removeCommand: MobileFeatureRemoveCommand(
            logger: logger,
            project: project,
            featurePackage: featurePackage,
          ),
        );
}
