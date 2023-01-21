import 'package:mason/mason.dart';
import 'package:rapid_cli/src/commands/ui/core/platform/add/add.dart';
import 'package:rapid_cli/src/commands/ui/web/add/widget/widget.dart';
import 'package:rapid_cli/src2/core/platform.dart';
import 'package:rapid_cli/src2/project/project.dart';

/// {@template ui_web_add_command}
/// `rapid ui web add` command adds components to the Web UI part of an existing Rapid project.
/// {@endtemplate}
class UiWebAddCommand extends UiPlatformAddCommand {
  /// {@macro ui_web_add_command}
  UiWebAddCommand({
    Logger? logger,
    required Project project,
  }) : super(
          platform: Platform.web,
          widgetCommand:
              UiWebAddWidgetCommand(logger: logger, project: project),
        );
}
