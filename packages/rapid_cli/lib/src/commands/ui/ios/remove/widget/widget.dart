import 'package:rapid_cli/src/commands/ui/core/platform/remove/widget/widget.dart';
import 'package:rapid_cli/src/core/platform.dart';

/// {@template ui_ios_remove_widget_command}
/// `rapid ui ios remove widget` command removes a widget from the iOS UI part of an existing Rapid project.
/// {@endtemplate}
class UiIosRemoveWidgetCommand extends UiPlatformRemoveWidgetCommand {
  /// {@macro ui_ios_remove_widget_command}
  UiIosRemoveWidgetCommand({
    super.logger,
    required super.project,
    super.generator,
  }) : super(
          platform: Platform.ios,
        );
}
