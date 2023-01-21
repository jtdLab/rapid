import 'package:rapid_cli/src/commands/ui/core/platform/remove/widget/widget.dart';
import 'package:rapid_cli/src2/core/platform.dart';

/// {@template ui_macos_remove_widget_command}
/// `rapid ui macos remove widget` command removes a widget from the macOS UI part of an existing Rapid project.
/// {@endtemplate}
class UiMacosRemoveWidgetCommand extends UiPlatformRemoveWidgetCommand {
  /// {@macro ui_macos_remove_widget_command}
  UiMacosRemoveWidgetCommand({
    super.logger,
    required super.project,
  }) : super(
          platform: Platform.macos,
        );
}
