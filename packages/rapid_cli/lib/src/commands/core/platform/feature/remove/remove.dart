import 'package:args/command_runner.dart';
import 'package:rapid_cli/src/commands/android/feature/remove/remove.dart';
import 'package:rapid_cli/src/commands/core/platform/feature/remove/bloc/bloc.dart';
import 'package:rapid_cli/src/commands/core/platform/feature/remove/cubit/cubit.dart';
import 'package:rapid_cli/src/commands/core/platform_x.dart';
import 'package:rapid_cli/src/commands/ios/feature/remove/remove.dart';
import 'package:rapid_cli/src/commands/linux/feature/remove/remove.dart';
import 'package:rapid_cli/src/commands/macos/feature/remove/remove.dart';
import 'package:rapid_cli/src/commands/web/feature/remove/remove.dart';
import 'package:rapid_cli/src/commands/windows/feature/remove/remove.dart';
import 'package:rapid_cli/src/core/platform.dart';

/// {@template platform_feature_remove_command}
/// Base class for:
///
///  * [AndroidFeatureRemoveCommand]
///
///  * [IosFeatureRemoveCommand]
///
///  * [LinuxFeatureRemoveCommand]
///
///  * [MacosFeatureRemoveCommand]
///
///  * [WebFeatureRemoveCommand]
///
///  * [WindowsFeatureRemoveCommand]
/// {@endtemplate}
abstract class PlatformFeatureRemoveCommand extends Command<int> {
  /// {@macro platform_feature_remove_command}
  PlatformFeatureRemoveCommand({
    required Platform platform,
    required PlatformFeatureRemoveBlocCommand blocCommand,
    required PlatformFeatureRemoveCubitCommand cubitCommand,
  }) : _platform = platform {
    addSubcommand(blocCommand);
    addSubcommand(cubitCommand);
  }

  final Platform _platform;

  @override
  String get name => 'remove';

  @override
  String get invocation => 'rapid ${_platform.name} feature remove <component>';

  @override
  String get description =>
      'Remove components from features of the ${_platform.prettyName} part of an existing Rapid project.';
}
