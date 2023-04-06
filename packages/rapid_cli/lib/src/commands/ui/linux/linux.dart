import 'package:mason/mason.dart';
import 'package:rapid_cli/src/commands/ui/core/platform/platform.dart';
import 'package:rapid_cli/src/commands/ui/linux/add/add.dart';
import 'package:rapid_cli/src/commands/ui/linux/remove/remove.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/project/project.dart';

/// {@template ui_linux_command}
/// `rapid ui linux` command work with the Linux UI part of an existing Rapid project.
/// {@endtemplate}
class UiLinuxCommand extends UiPlatformCommand {
  /// {@macro ui_linux_command}
  UiLinuxCommand({
    Logger? logger,
    Project? project,
  }) : super(
          platform: Platform.linux,
          addCommand: UiLinuxAddCommand(logger: logger, project: project),
          removeCommand: UiLinuxRemoveCommand(logger: logger, project: project),
        );
}
