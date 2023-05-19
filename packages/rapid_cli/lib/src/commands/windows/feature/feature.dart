import 'package:mason/mason.dart';
import 'package:rapid_cli/src/commands/core/platform/feature/feature.dart';
import 'package:rapid_cli/src/commands/windows/feature/add/add.dart';
import 'package:rapid_cli/src/commands/windows/feature/remove/remove.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/project/project.dart';

/// {@template windows_feature_command}
/// `rapid windows feature` command work with features of the Windows part of an existing Rapid project.
/// {@endtemplate}
class WindowsFeatureCommand extends PlatformFeatureCommand {
  /// {@macro windows_feature_command}
  WindowsFeatureCommand({
    Logger? logger,
    Project? project,
    required super.featurePackage,
  }) : super(
          platform: Platform.windows,
          addCommand: WindowsFeatureAddCommand(
            logger: logger,
            project: project,
            featurePackage: featurePackage,
          ),
          removeCommand: WindowsFeatureRemoveCommand(
            logger: logger,
            project: project,
            featurePackage: featurePackage,
          ),
        );
}
