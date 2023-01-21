import 'package:mason/mason.dart';
import 'package:rapid_cli/src/commands/ui/core/platform/add/add.dart';
import 'package:rapid_cli/src/commands/ui/linux/add/widget/widget.dart';
import 'package:rapid_cli/src2/core/platform.dart';
import 'package:rapid_cli/src2/project/project.dart';

/// {@template ui_linux_add_command}
/// `rapid ui linux add` command adds components to the Linux UI part of an existing Rapid project.
/// {@endtemplate}
class UiLinuxAddCommand extends UiPlatformAddCommand {
  /// {@macro ui_linux_add_command}
  UiLinuxAddCommand({
    Logger? logger,
    required Project project,
  }) : super(
          platform: Platform.linux,
          widgetCommand:
              UiLinuxAddWidgetCommand(logger: logger, project: project),
        );
}
