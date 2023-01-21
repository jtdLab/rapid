import 'package:mason/mason.dart';
import 'package:rapid_cli/src/commands/ui/android/remove/widget/widget.dart';
import 'package:rapid_cli/src/commands/ui/core/platform/remove/remove.dart';
import 'package:rapid_cli/src2/core/platform.dart';
import 'package:rapid_cli/src2/project/project.dart';

/// {@template ui_android_remove_command}
/// `rapid ui android remove` command removes components from the Android UI part of an existing Rapid project.
/// {@endtemplate}
class UiAndroidRemoveCommand extends UiPlatformRemoveCommand {
  /// {@macro ui_android_remove_command}
  UiAndroidRemoveCommand({
    Logger? logger,
    required Project project,
  }) : super(
          platform: Platform.android,
          widgetCommand:
              UiAndroidRemoveWidgetCommand(logger: logger, project: project),
        );
}
