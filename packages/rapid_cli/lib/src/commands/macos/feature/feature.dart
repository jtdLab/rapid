import 'package:mason/mason.dart';
import 'package:rapid_cli/src/commands/macos/feature/add/add.dart';
import 'package:rapid_cli/src/commands/core/platform/feature/feature.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/project/project.dart';

/// {@template macos_feature_command}
/// `rapid macos feature` command work with features of the macOS part of an existing Rapid project.
/// {@endtemplate}
class MacosFeatureCommand extends PlatformFeatureCommand {
  /// {@macro macos_feature_command}
  MacosFeatureCommand({
    Logger? logger,
    required Project project,
  }) : super(
          platform: Platform.macos,
          addCommand: MacosFeatureAddCommand(logger: logger, project: project),
        );
}
