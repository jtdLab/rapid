import 'package:mason/mason.dart';
import 'package:rapid_cli/src/commands/ui/core/platform/platform.dart';
import 'package:rapid_cli/src/commands/ui/web/add/add.dart';
import 'package:rapid_cli/src/commands/ui/web/remove/remove.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/project/project.dart';

/// {@template ui_web_command}
/// `rapid ui web` command work with the Web UI part of an existing Rapid project.
/// {@endtemplate}
class UiWebCommand extends UiPlatformCommand {
  /// {@macro ui_web_command}
  UiWebCommand({
    Logger? logger,
    required Project project,
  }) : super(
          platform: Platform.web,
          addCommand: UiWebAddCommand(logger: logger, project: project),
          removeCommand: UiWebRemoveCommand(logger: logger, project: project),
        );
}
