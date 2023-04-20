import 'package:mason/mason.dart';
import 'package:rapid_cli/src/commands/ui/core/platform/platform.dart';
import 'package:rapid_cli/src/commands/ui/windows/add/add.dart';
import 'package:rapid_cli/src/commands/ui/windows/remove/remove.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/project/project.dart';

/// {@template ui_windows_command}
/// `rapid ui windows` command work with the Windows UI part of an existing Rapid project.
/// {@endtemplate}
class UiWindowsCommand extends UiPlatformCommand {
  /// {@macro ui_windows_command}
  UiWindowsCommand({
    Logger? logger,
    Project? project,
  }) : super(
          platform: Platform.windows,
          addCommand: UiWindowsAddCommand(logger: logger, project: project),
          removeCommand:
              UiWindowsRemoveCommand(logger: logger, project: project),
        );
}
