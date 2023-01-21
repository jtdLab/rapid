import 'package:rapid_cli/src/commands/ui/core/platform/add/widget/widget.dart';
import 'package:rapid_cli/src2/core/platform.dart';

/// {@template ui_linux_add_widget_command}
/// `rapid ui linux add widget` command adds a widget to the Linux UI part of an existing Rapid project.
/// {@endtemplate}
class UiLinuxAddWidgetCommand extends UiPlatformAddWidgetCommand {
  /// {@macro ui_linux_add_widget_command}
  UiLinuxAddWidgetCommand({
    super.logger,
    required super.project,
  }) : super(
          platform: Platform.linux,
        );
}
