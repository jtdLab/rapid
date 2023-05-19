import 'package:mason/mason.dart';
import 'package:rapid_cli/src/commands/core/platform/feature/feature.dart';
import 'package:rapid_cli/src/commands/linux/feature/add/add.dart';
import 'package:rapid_cli/src/commands/linux/feature/remove/remove.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/project/project.dart';

/// {@template linux_feature_command}
/// `rapid linux feature` command work with features of the Linux part of an existing Rapid project.
/// {@endtemplate}
class LinuxFeatureCommand extends PlatformFeatureCommand {
  /// {@macro linux_feature_command}
  LinuxFeatureCommand({
    Logger? logger,
    Project? project,
    required super.featurePackage,
  }) : super(
          platform: Platform.linux,
          addCommand: LinuxFeatureAddCommand(
            logger: logger,
            project: project,
            featurePackage: featurePackage,
          ),
          removeCommand: LinuxFeatureRemoveCommand(
            logger: logger,
            project: project,
            featurePackage: featurePackage,
          ),
        );
}
