import 'package:rapid_cli/src/commands/ui/core/platform/add/widget/widget.dart';
import 'package:rapid_cli/src/core/platform.dart';

/// {@template ui_windows_add_widget_command}
/// `rapid ui windows add widget` command adds a widget to the Windows UI part of an existing Rapid project.
/// {@endtemplate}
class UiWindowsAddWidgetCommand extends UiPlatformAddWidgetCommand {
  /// {@macro ui_windows_add_widget_command}
  UiWindowsAddWidgetCommand({
    super.logger,
    required super.project,
    super.dartFormatFix,
  }) : super(
          platform: Platform.windows,
        );
}
