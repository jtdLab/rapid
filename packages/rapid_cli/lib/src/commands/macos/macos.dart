import 'package:mason/mason.dart';
import 'package:rapid_cli/src/commands/core/platform/platform.dart';
import 'package:rapid_cli/src/commands/macos/add/add.dart';
import 'package:rapid_cli/src/commands/macos/feature/feature.dart';
import 'package:rapid_cli/src/commands/macos/remove/remove.dart';
import 'package:rapid_cli/src/commands/macos/set/set.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/project/project.dart';

/// {@template macos_command}
/// `rapid macos` command work with the macOS part of an existing Rapid project.
/// {@endtemplate}
class MacosCommand extends PlatformCommand {
  /// {@macro macos_command}
  MacosCommand({
    Logger? logger,
    Project? project,
  }) : super(
          platform: Platform.macos,
          addCommand: MacosAddCommand(logger: logger, project: project),
          featureCommands: (featurePackages) => featurePackages.map(
            (e) => MacosFeatureCommand(
              logger: logger,
              project: project,
              featurePackage: e,
            ),
          ),
          removeCommand: MacosRemoveCommand(logger: logger, project: project),
          setCommand: MacosSetCommand(logger: logger, project: project),
        );
}
