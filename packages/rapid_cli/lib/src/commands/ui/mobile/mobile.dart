import 'package:mason/mason.dart';
import 'package:rapid_cli/src/commands/ui/core/platform/platform.dart';
import 'package:rapid_cli/src/commands/ui/mobile/add/add.dart';
import 'package:rapid_cli/src/commands/ui/mobile/remove/remove.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/project/project.dart';

/// {@template ui_mobile_command}
/// `rapid ui mobile` command work with the Mobile UI part of an existing Rapid project.
/// {@endtemplate}
class UiMobileCommand extends UiPlatformCommand {
  /// {@macro ui_mobile_command}
  UiMobileCommand({
    Logger? logger,
    Project? project,
  }) : super(
          platform: Platform.mobile,
          addCommand: UiMobileAddCommand(logger: logger, project: project),
          removeCommand:
              UiMobileRemoveCommand(logger: logger, project: project),
        );
}
