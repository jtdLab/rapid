import 'package:rapid_cli/src/commands/ui/core/platform/remove/widget/widget.dart';
import 'package:rapid_cli/src/core/platform.dart';

/// {@template ui_mobile_remove_widget_command}
/// `rapid ui mobile remove widget` command removes a widget from the Mobile UI part of an existing Rapid project.
/// {@endtemplate}
class UiMobileRemoveWidgetCommand extends UiPlatformRemoveWidgetCommand {
  /// {@macro ui_mobile_remove_widget_command}
  UiMobileRemoveWidgetCommand({
    super.logger,
    super.project,
  }) : super(
          platform: Platform.mobile,
        );
}
