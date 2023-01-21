import 'package:args/command_runner.dart';
import 'package:rapid_cli/src/commands/ui/android/remove/remove.dart';
import 'package:rapid_cli/src/commands/ui/core/platform/remove/widget/widget.dart';
import 'package:rapid_cli/src/commands/ui/ios/remove/remove.dart';
import 'package:rapid_cli/src/commands/ui/linux/remove/remove.dart';
import 'package:rapid_cli/src/commands/ui/macos/remove/remove.dart';
import 'package:rapid_cli/src/commands/ui/web/remove/remove.dart';
import 'package:rapid_cli/src/commands/ui/windows/remove/remove.dart';
import 'package:rapid_cli/src2/core/platform.dart';

/// {@template ui_platform_remove_command}
/// Base class for:
///
///  * [UiAndroidRemoveCommand]
///
///  * [UiIosRemoveCommand]
///
///  * [UiLinuxRemoveCommand]
///
///  * [UiMacosRemoveCommand]
///
///  * [UiWebRemoveCommand]
///
///  * [UiWindowsRemoveCommand]
/// {@endtemplate}
abstract class UiPlatformRemoveCommand extends Command<int> {
  /// {@macro ui_platform_remove_command}
  UiPlatformRemoveCommand({
    required Platform platform,
    required UiPlatformRemoveWidgetCommand widgetCommand,
  }) : _platform = platform {
    addSubcommand(widgetCommand);
  }

  final Platform _platform;

  @override
  String get name => 'remove';

  @override
  String get invocation => 'rapid ui ${_platform.name} remove <subcommand>';

  @override
  String get description =>
      'Remove components from the ${_platform.prettyName} UI part of an existing Rapid project.';
}
