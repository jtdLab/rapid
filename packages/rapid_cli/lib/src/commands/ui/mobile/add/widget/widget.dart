import 'package:rapid_cli/src/commands/ui/core/platform/add/widget/widget.dart';
import 'package:rapid_cli/src/core/platform.dart';

/// {@template ui_mobile_add_widget_command}
/// `rapid ui mobile add widget` command adds a widget to the Mobile UI part of an existing Rapid project.
/// {@endtemplate}
class UiMobileAddWidgetCommand extends UiPlatformAddWidgetCommand {
  /// {@macro ui_mobile_add_widget_command}
  UiMobileAddWidgetCommand({
    super.logger,
    super.project,
    super.dartFormatFix,
  }) : super(
          platform: Platform.mobile,
        );
}
