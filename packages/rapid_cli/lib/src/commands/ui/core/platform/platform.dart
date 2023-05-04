import 'package:args/command_runner.dart';
import 'package:rapid_cli/src/commands/core/platform_x.dart';
import 'package:rapid_cli/src/commands/ui/android/android.dart';
import 'package:rapid_cli/src/commands/ui/core/platform/add/add.dart';
import 'package:rapid_cli/src/commands/ui/core/platform/remove/remove.dart';
import 'package:rapid_cli/src/commands/ui/ios/ios.dart';
import 'package:rapid_cli/src/commands/ui/linux/linux.dart';
import 'package:rapid_cli/src/commands/ui/macos/macos.dart';
import 'package:rapid_cli/src/commands/ui/web/web.dart';
import 'package:rapid_cli/src/commands/ui/windows/windows.dart';
import 'package:rapid_cli/src/core/platform.dart';

/// {@template ui_platform_command}
/// Base class for:
///
///  * [UiAndroidCommand]
///
///  * [UiIosCommand]
///
///  * [UiLinuxCommand]
///
///  * [UiMacosCommand]
///
///  * [UiWebCommand]
///
///  * [UiWindowsCommand]
/// {@endtemplate}
abstract class UiPlatformCommand extends Command<int> {
  /// {@macro ui_platform_command}
  UiPlatformCommand({
    required Platform platform,
    required UiPlatformAddCommand addCommand,
    required UiPlatformRemoveCommand removeCommand,
  }) : _platform = platform {
    addSubcommand(addCommand);
    addSubcommand(removeCommand);
  }

  final Platform _platform;

  @override
  String get name => _platform.name;

  @override
  List<String> get aliases => _platform.aliases;

  @override
  String get invocation => 'rapid ui ${_platform.name} <subcommand>';

  @override
  String get description =>
      'Work with the ${_platform.prettyName} UI part of an existing Rapid project.';
}
