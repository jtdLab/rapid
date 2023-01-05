import 'package:args/command_runner.dart';
import 'package:rapid_cli/src/commands/android/add/add.dart';
import 'package:rapid_cli/src/commands/core/platform/add/feature/feature.dart';
import 'package:rapid_cli/src/commands/core/platform/add/language/language.dart';
import 'package:rapid_cli/src/commands/ios/add/add.dart';
import 'package:rapid_cli/src/commands/linux/add/add.dart';
import 'package:rapid_cli/src/commands/macos/add/add.dart';
import 'package:rapid_cli/src/commands/web/add/add.dart';
import 'package:rapid_cli/src/commands/windows/add/add.dart';
import 'package:rapid_cli/src/core/platform.dart';

/// {@template platform_add_command}
/// Base class for:
///
///  * [AndroidAddCommand]
///
///  * [IosAddCommand]
///
///  * [LinuxAddCommand]
///
///  * [MacosAddCommand]
///
///  * [WebAddCommand]
///
///  * [WindowsAddCommand]
/// {@endtemplate}
abstract class PlatformAddCommand extends Command<int> {
  /// {@macro platform_add_command}
  PlatformAddCommand({
    required Platform platform,
    required PlatformAddFeatureCommand featureCommand,
    required PlatformAddLanguageCommand languageCommand,
  }) : _platform = platform {
    addSubcommand(featureCommand);
    addSubcommand(languageCommand);
  }

  final Platform _platform;

  @override
  String get name => 'add';

  @override
  String get invocation => 'rapid ${_platform.name} add <subcommand>';

  @override
  String get description =>
      'Add features or languages to the ${_platform.prettyName} part of an existing Rapid project.';
}
