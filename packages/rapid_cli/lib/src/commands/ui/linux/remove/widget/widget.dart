import 'package:rapid_cli/src/commands/ui/core/platform/remove/widget/widget.dart';
import 'package:rapid_cli/src/core/platform.dart';

/// {@template ui_linux_remove_widget_command}
/// `rapid ui linux remove widget` command removes a widget from the Linux UI part of an existing Rapid project.
/// {@endtemplate}
class UiLinuxRemoveWidgetCommand extends UiPlatformRemoveWidgetCommand {
  /// {@macro ui_linux_remove_widget_command}
  UiLinuxRemoveWidgetCommand({
    super.logger,
    required super.project,
  }) : super(
          platform: Platform.linux,
        );
}
