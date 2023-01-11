import 'package:mason/mason.dart';
import 'package:rapid_cli/src/commands/ui/core/platform/remove/remove.dart';
import 'package:rapid_cli/src/commands/ui/ios/remove/widget/widget.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/project/project.dart';

/// {@template ui_ios_remove_command}
/// `rapid ui ios remove` command removes components from the iOS UI part of an existing Rapid project.
/// {@endtemplate}
class UiIosRemoveCommand extends UiPlatformRemoveCommand {
  /// {@macro ui_ios_remove_command}
  UiIosRemoveCommand({
    Logger? logger,
    required Project project,
  }) : super(
          platform: Platform.ios,
          widgetCommand:
              UiIosRemoveWidgetCommand(logger: logger, project: project),
        );
}
