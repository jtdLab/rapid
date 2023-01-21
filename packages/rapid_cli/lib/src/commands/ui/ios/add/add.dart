import 'package:mason/mason.dart';
import 'package:rapid_cli/src/commands/ui/core/platform/add/add.dart';
import 'package:rapid_cli/src/commands/ui/ios/add/widget/widget.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/project/project.dart';

/// {@template ui_ios_add_command}
/// `rapid ui ios add` command adds components to the iOS UI part of an existing Rapid project.
/// {@endtemplate}
class UiIosAddCommand extends UiPlatformAddCommand {
  /// {@macro ui_ios_add_command}
  UiIosAddCommand({
    Logger? logger,
    required Project project,
  }) : super(
          platform: Platform.ios,
          widgetCommand:
              UiIosAddWidgetCommand(logger: logger, project: project),
        );
}
