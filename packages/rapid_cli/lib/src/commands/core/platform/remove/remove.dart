import 'package:args/command_runner.dart';
import 'package:rapid_cli/src/commands/android/remove/remove.dart';
import 'package:rapid_cli/src/commands/core/platform/remove/feature/feature.dart';
import 'package:rapid_cli/src/commands/core/platform/remove/language/language.dart';
import 'package:rapid_cli/src/commands/core/platform/remove/navigator/navigator.dart';
import 'package:rapid_cli/src/commands/core/platform_x.dart';
import 'package:rapid_cli/src/commands/ios/remove/remove.dart';
import 'package:rapid_cli/src/commands/linux/remove/remove.dart';
import 'package:rapid_cli/src/commands/macos/remove/remove.dart';
import 'package:rapid_cli/src/commands/web/remove/remove.dart';
import 'package:rapid_cli/src/commands/windows/remove/remove.dart';
import 'package:rapid_cli/src/core/platform.dart';

/// {@template platform_remove_command}
/// Base class for:
///
///  * [AndroidRemoveCommand]
///
///  * [IosRemoveCommand]
///
///  * [LinuxRemoveCommand]
///
///  * [MacosRemoveCommand]
///
///  * [WebRemoveCommand]
///
///  * [WindowsRemoveCommand]
/// {@endtemplate}
abstract class PlatformRemoveCommand extends Command<int> {
  /// {@macro platform_remove_command}
  PlatformRemoveCommand({
    required Platform platform,
    required PlatformRemoveFeatureCommand featureCommand,
    required PlatformRemoveLanguageCommand languageCommand,
    required PlatformRemoveNavigatorCommand navigatorCommand,
  }) : _platform = platform {
    addSubcommand(featureCommand);
    addSubcommand(languageCommand);
    addSubcommand(navigatorCommand);
  }

  final Platform _platform;

  @override
  String get name => 'remove';

  @override
  String get invocation => 'rapid ${_platform.name} remove <subcommand>';

  @override
  String get description =>
      'Removes features or languages from the ${_platform.prettyName} part of an existing Rapid project.';
}
