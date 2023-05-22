import 'package:mason/mason.dart';
import 'package:rapid_cli/src/commands/ui/core/platform/add/add.dart';
import 'package:rapid_cli/src/commands/ui/mobile/add/widget/widget.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/project/project.dart';

/// {@template ui_mobile_add_command}
/// `rapid ui mobile add` command adds components to the Mobile UI part of an existing Rapid project.
/// {@endtemplate}
class UiMobileAddCommand extends UiPlatformAddCommand {
  /// {@macro ui_mobile_add_command}
  UiMobileAddCommand({
    Logger? logger,
    Project? project,
  }) : super(
          platform: Platform.mobile,
          widgetCommand:
              UiMobileAddWidgetCommand(logger: logger, project: project),
        );
}
