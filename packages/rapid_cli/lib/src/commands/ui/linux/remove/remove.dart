import 'package:mason/mason.dart';
import 'package:rapid_cli/src/commands/ui/core/platform/remove/remove.dart';
import 'package:rapid_cli/src/commands/ui/linux/remove/widget/widget.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/project/project.dart';

/// {@template ui_linux_remove_command}
/// `rapid ui linux remove` command removes components from the Linux UI part of an existing Rapid project.
/// {@endtemplate}
class UiLinuxRemoveCommand extends UiPlatformRemoveCommand {
  /// {@macro ui_linux_remove_command}
  UiLinuxRemoveCommand({
    Logger? logger,
    required Project project,
  }) : super(
          platform: Platform.linux,
          widgetCommand:
              UiLinuxRemoveWidgetCommand(logger: logger, project: project),
        );
}
