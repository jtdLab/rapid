import 'package:rapid_cli/src/commands/ui/core/platform/remove/widget/widget.dart';
import 'package:rapid_cli/src2/core/platform.dart';

/// {@template ui_windows_remove_widget_command}
/// `rapid ui windows remove widget` command removes a widget from the Windows UI part of an existing Rapid project.
/// {@endtemplate}
class UiWindowsRemoveWidgetCommand extends UiPlatformRemoveWidgetCommand {
  /// {@macro ui_windows_remove_widget_command}
  UiWindowsRemoveWidgetCommand({
    super.logger,
    required super.project,
  }) : super(
          platform: Platform.windows,
        );
}
