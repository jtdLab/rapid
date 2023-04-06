import 'package:mason/mason.dart';
import 'package:rapid_cli/src/commands/ui/core/platform/add/add.dart';
import 'package:rapid_cli/src/commands/ui/macos/add/widget/widget.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/project/project.dart';

/// {@template ui_macos_add_command}
/// `rapid ui macos add` command adds components to the macOS UI part of an existing Rapid project.
/// {@endtemplate}
class UiMacosAddCommand extends UiPlatformAddCommand {
  /// {@macro ui_macos_add_command}
  UiMacosAddCommand({
    Logger? logger,
    Project? project,
  }) : super(
          platform: Platform.macos,
          widgetCommand:
              UiMacosAddWidgetCommand(logger: logger, project: project),
        );
}
