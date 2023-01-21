import 'package:rapid_cli/src/commands/ui/core/platform/add/widget/widget.dart';
import 'package:rapid_cli/src/core/platform.dart';

/// {@template ui_macos_add_widget_command}
/// `rapid ui macos add widget` command adds a widget to the macOS UI part of an existing Rapid project.
/// {@endtemplate}
class UiMacosAddWidgetCommand extends UiPlatformAddWidgetCommand {
  /// {@macro ui_macos_add_widget_command}
  UiMacosAddWidgetCommand({
    super.logger,
    required super.project,
  }) : super(
          platform: Platform.macos,
        );
}
