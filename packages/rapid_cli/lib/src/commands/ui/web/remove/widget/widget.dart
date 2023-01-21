import 'package:rapid_cli/src/commands/ui/core/platform/remove/widget/widget.dart';
import 'package:rapid_cli/src2/core/platform.dart';

/// {@template ui_web_remove_widget_command}
/// `rapid ui web remove widget` command removes a widget from the Web UI part of an existing Rapid project.
/// {@endtemplate}
class UiWebRemoveWidgetCommand extends UiPlatformRemoveWidgetCommand {
  /// {@macro ui_web_remove_widget_command}
  UiWebRemoveWidgetCommand({
    super.logger,
    required super.project,
  }) : super(
          platform: Platform.web,
        );
}
