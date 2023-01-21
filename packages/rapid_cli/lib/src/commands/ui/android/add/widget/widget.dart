import 'package:rapid_cli/src/commands/ui/core/platform/add/widget/widget.dart';
import 'package:rapid_cli/src/core/platform.dart';

/// {@template ui_android_add_widget_command}
/// `rapid ui android add widget` command adds a widget to the Android UI part of an existing Rapid project.
/// {@endtemplate}
class UiAndroidAddWidgetCommand extends UiPlatformAddWidgetCommand {
  /// {@macro ui_android_add_widget_command}
  UiAndroidAddWidgetCommand({
    super.logger,
    required super.project,
  }) : super(
          platform: Platform.android,
        );
}
