import 'package:mason/mason.dart';
import 'package:rapid_cli/src/commands/ui/core/platform/add/add.dart';
import 'package:rapid_cli/src/commands/ui/windows/add/widget/widget.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/project/project.dart';

/// {@template ui_windows_add_command}
/// `rapid ui windows add` command adds components to the Windows UI part of an existing Rapid project.
/// {@endtemplate}
class UiWindowsAddCommand extends UiPlatformAddCommand {
  /// {@macro ui_windows_add_command}
  UiWindowsAddCommand({
    Logger? logger,
    Project? project,
  }) : super(
          platform: Platform.windows,
          widgetCommand:
              UiWindowsAddWidgetCommand(logger: logger, project: project),
        );
}
