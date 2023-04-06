import 'package:mason/mason.dart';
import 'package:rapid_cli/src/commands/ui/android/add/widget/widget.dart';
import 'package:rapid_cli/src/commands/ui/core/platform/add/add.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/project/project.dart';

/// {@template ui_android_add_command}
/// `rapid ui android add` command adds components to the Android UI part of an existing Rapid project.
/// {@endtemplate}
class UiAndroidAddCommand extends UiPlatformAddCommand {
  /// {@macro ui_android_add_command}
  UiAndroidAddCommand({
    Logger? logger,
    Project? project,
  }) : super(
          platform: Platform.android,
          widgetCommand:
              UiAndroidAddWidgetCommand(logger: logger, project: project),
        );
}
