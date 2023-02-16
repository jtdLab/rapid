import 'package:args/command_runner.dart';
import 'package:rapid_cli/src/commands/android/set/set.dart';
import 'package:rapid_cli/src/commands/core/platform/set/default_language/default_language.dart';
import 'package:rapid_cli/src/commands/core/platform_x.dart';
import 'package:rapid_cli/src/commands/ios/set/set.dart';
import 'package:rapid_cli/src/commands/linux/set/set.dart';
import 'package:rapid_cli/src/commands/macos/set/set.dart';
import 'package:rapid_cli/src/commands/web/set/set.dart';
import 'package:rapid_cli/src/commands/windows/set/set.dart';
import 'package:rapid_cli/src/core/platform.dart';

/// {@template platform_set_command}
/// Base class for:
///
///  * [AndroidSetCommand]
///
///  * [IosSetCommand]
///
///  * [LinuxSetCommand]
///
///  * [MacosSetCommand]
///
///  * [WebSetCommand]
///
///  * [WindowsSetCommand]
/// {@endtemplate}
abstract class PlatformSetCommand extends Command<int> {
  /// {@macro platform_set_command}
  PlatformSetCommand({
    required Platform platform,
    required PlatformSetDefaultLanguageCommand defaultLanguageCommand,
  }) : _platform = platform {
    addSubcommand(defaultLanguageCommand);
  }

  final Platform _platform;

  @override
  String get name => 'set';

  @override
  String get invocation => 'rapid ${_platform.name} set <subcommand>';

  @override
  String get description =>
      'Set properties of features from the ${_platform.prettyName} part of an existing Rapid project.';
}
