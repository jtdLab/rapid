import 'package:mason/mason.dart';
import 'package:rapid_cli/src/commands/ui/core/platform/remove/remove.dart';
import 'package:rapid_cli/src/commands/ui/windows/remove/widget/widget.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/project/project.dart';

/// {@template ui_windows_remove_command}
/// `rapid ui windows remove` command removes components from the Windows UI part of an existing Rapid project.
/// {@endtemplate}
class UiWindowsRemoveCommand extends UiPlatformRemoveCommand {
  /// {@macro ui_windows_remove_command}
  UiWindowsRemoveCommand({
    Logger? logger,
    required Project project,
  }) : super(
          platform: Platform.windows,
          widgetCommand:
              UiWindowsRemoveWidgetCommand(logger: logger, project: project),
        );
}
