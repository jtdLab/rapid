import 'package:rapid_cli/src/commands/ui/core/platform/add/widget/widget.dart';
import 'package:rapid_cli/src/core/platform.dart';

/// {@template ui_web_add_widget_command}
/// `rapid ui web add widget` command adds a widget to the Web UI part of an existing Rapid project.
/// {@endtemplate}
class UiWebAddWidgetCommand extends UiPlatformAddWidgetCommand {
  /// {@macro ui_web_add_widget_command}
  UiWebAddWidgetCommand({
    super.logger,
    required super.project,
  }) : super(
          platform: Platform.web,
        );
}
