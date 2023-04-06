import 'package:mason/mason.dart';
import 'package:rapid_cli/src/commands/ui/core/platform/remove/remove.dart';
import 'package:rapid_cli/src/commands/ui/web/remove/widget/widget.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/project/project.dart';

/// {@template ui_web_remove_command}
/// `rapid ui web remove` command removes components from the Web UI part of an existing Rapid project.
/// {@endtemplate}
class UiWebRemoveCommand extends UiPlatformRemoveCommand {
  /// {@macro ui_web_remove_command}
  UiWebRemoveCommand({
    Logger? logger,
    Project? project,
  }) : super(
          platform: Platform.web,
          widgetCommand:
              UiWebRemoveWidgetCommand(logger: logger, project: project),
        );
}
