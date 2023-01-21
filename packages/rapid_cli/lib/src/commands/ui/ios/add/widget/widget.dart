import 'package:rapid_cli/src/commands/ui/core/platform/add/widget/widget.dart';
import 'package:rapid_cli/src/core/platform.dart';

/// {@template ui_ios_add_widget_command}
/// `rapid ui ios add widget` command adds a widget to the iOS UI part of an existing Rapid project.
/// {@endtemplate}
class UiIosAddWidgetCommand extends UiPlatformAddWidgetCommand {
  /// {@macro ui_ios_add_widget_command}
  UiIosAddWidgetCommand({
    super.logger,
    required super.project,
  }) : super(
          platform: Platform.ios,
        );
}
