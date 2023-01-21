import 'package:rapid_cli/src/commands/ui/core/platform/remove/widget/widget.dart';
import 'package:rapid_cli/src2/core/platform.dart';

/// {@template ui_android_remove_widget_command}
/// `rapid ui android remove widget` command removes a widget from the Android UI part of an existing Rapid project.
/// {@endtemplate}
class UiAndroidRemoveWidgetCommand extends UiPlatformRemoveWidgetCommand {
  /// {@macro ui_android_remove_widget_command}
  UiAndroidRemoveWidgetCommand({
    super.logger,
    required super.project,
  }) : super(
          platform: Platform.android,
        );
}
