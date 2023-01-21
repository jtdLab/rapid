import 'package:mason/mason.dart';
import 'package:rapid_cli/src/commands/ui/android/add/add.dart';
import 'package:rapid_cli/src/commands/ui/android/remove/remove.dart';
import 'package:rapid_cli/src/commands/ui/core/platform/platform.dart';
import 'package:rapid_cli/src2/core/platform.dart';
import 'package:rapid_cli/src2/project/project.dart';

/// {@template ui_android_command}
/// `rapid ui android` command work with the Android UI part of an existing Rapid project.
/// {@endtemplate}
class UiAndroidCommand extends UiPlatformCommand {
  /// {@macro ui_android_command}
  UiAndroidCommand({
    Logger? logger,
    required Project project,
  }) : super(
          platform: Platform.android,
          addCommand: UiAndroidAddCommand(logger: logger, project: project),
          removeCommand:
              UiAndroidRemoveCommand(logger: logger, project: project),
        );
}
