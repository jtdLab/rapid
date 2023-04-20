import 'package:mason/mason.dart';
import 'package:rapid_cli/src/commands/ui/core/platform/platform.dart';
import 'package:rapid_cli/src/commands/ui/macos/add/add.dart';
import 'package:rapid_cli/src/commands/ui/macos/remove/remove.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/project/project.dart';

/// {@template ui_macos_command}
/// `rapid ui macos` command work with the macOS UI part of an existing Rapid project.
/// {@endtemplate}
class UiMacosCommand extends UiPlatformCommand {
  /// {@macro ui_macos_command}
  UiMacosCommand({
    Logger? logger,
    Project? project,
  }) : super(
          platform: Platform.macos,
          addCommand: UiMacosAddCommand(logger: logger, project: project),
          removeCommand: UiMacosRemoveCommand(logger: logger, project: project),
        );
}
