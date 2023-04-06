import 'package:mason/mason.dart';
import 'package:rapid_cli/src/commands/ui/core/platform/remove/remove.dart';
import 'package:rapid_cli/src/commands/ui/macos/remove/widget/widget.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/project/project.dart';

/// {@template ui_macos_remove_command}
/// `rapid ui macos remove` command removes components from the macOS UI part of an existing Rapid project.
/// {@endtemplate}
class UiMacosRemoveCommand extends UiPlatformRemoveCommand {
  /// {@macro ui_macos_remove_command}
  UiMacosRemoveCommand({
    Logger? logger,
    Project? project,
  }) : super(
          platform: Platform.macos,
          widgetCommand:
              UiMacosRemoveWidgetCommand(logger: logger, project: project),
        );
}
