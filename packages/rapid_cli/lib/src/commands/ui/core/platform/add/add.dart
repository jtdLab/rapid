import 'package:args/command_runner.dart';
import 'package:rapid_cli/src/commands/ui/android/add/add.dart';
import 'package:rapid_cli/src/commands/ui/core/platform/add/widget/widget.dart';
import 'package:rapid_cli/src/commands/ui/ios/add/add.dart';
import 'package:rapid_cli/src/commands/ui/linux/add/add.dart';
import 'package:rapid_cli/src/commands/ui/macos/add/add.dart';
import 'package:rapid_cli/src/commands/ui/web/add/add.dart';
import 'package:rapid_cli/src/commands/ui/windows/add/add.dart';
import 'package:rapid_cli/src2/core/platform.dart';

/// {@template ui_platform_add_command}
/// Base class for:
///
///  * [UiAndroidAddCommand]
///
///  * [UiIosAddCommand]
///
///  * [UiLinuxAddCommand]
///
///  * [UiMacosAddCommand]
///
///  * [UiWebAddCommand]
///
///  * [UiWindowsAddCommand]
/// {@endtemplate}
abstract class UiPlatformAddCommand extends Command<int> {
  /// {@macro ui_platform_add_command}
  UiPlatformAddCommand({
    required Platform platform,
    required UiPlatformAddWidgetCommand widgetCommand,
  }) : _platform = platform {
    addSubcommand(widgetCommand);
  }

  final Platform _platform;

  @override
  String get name => 'add';

  @override
  String get invocation => 'rapid ui ${_platform.name} add <subcommand>';

  @override
  String get description =>
      'Add components to the ${_platform.prettyName} UI part of an existing Rapid project.';
}
