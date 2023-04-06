import 'package:mason/mason.dart';
import 'package:rapid_cli/src/commands/ui/core/platform/platform.dart';
import 'package:rapid_cli/src/commands/ui/ios/add/add.dart';
import 'package:rapid_cli/src/commands/ui/ios/remove/remove.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/project/project.dart';

/// {@template ui_ios_command}
/// `rapid ui ios` command work with the iOS UI part of an existing Rapid project.
/// {@endtemplate}
class UiIosCommand extends UiPlatformCommand {
  /// {@macro ui_ios_command}
  UiIosCommand({
    Logger? logger,
    Project? project,
  }) : super(
          platform: Platform.ios,
          addCommand: UiIosAddCommand(logger: logger, project: project),
          removeCommand: UiIosRemoveCommand(logger: logger, project: project),
        );
}
