import 'package:mason/mason.dart';
import 'package:rapid_cli/src/commands/ui/core/platform/remove/remove.dart';
import 'package:rapid_cli/src/commands/ui/mobile/remove/widget/widget.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/project/project.dart';

/// {@template ui_mobile_remove_command}
/// `rapid ui mobile remove` command removes components from the Mobile UI part of an existing Rapid project.
/// {@endtemplate}
class UiMobileRemoveCommand extends UiPlatformRemoveCommand {
  /// {@macro ui_mobile_remove_command}
  UiMobileRemoveCommand({
    Logger? logger,
    Project? project,
  }) : super(
          platform: Platform.mobile,
          widgetCommand:
              UiMobileRemoveWidgetCommand(logger: logger, project: project),
        );
}
