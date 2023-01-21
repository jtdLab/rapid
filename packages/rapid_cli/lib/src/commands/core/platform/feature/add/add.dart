import 'package:args/command_runner.dart';
import 'package:rapid_cli/src/commands/android/feature/add/add.dart';
import 'package:rapid_cli/src/commands/core/platform/feature/add/bloc/bloc.dart';
import 'package:rapid_cli/src/commands/core/platform/feature/add/cubit/cubit.dart';
import 'package:rapid_cli/src/commands/ios/feature/add/add.dart';
import 'package:rapid_cli/src/commands/linux/feature/add/add.dart';
import 'package:rapid_cli/src/commands/macos/feature/add/add.dart';
import 'package:rapid_cli/src/commands/web/feature/add/add.dart';
import 'package:rapid_cli/src/commands/windows/feature/add/add.dart';
import 'package:rapid_cli/src/core/platform.dart';

/// {@template platform_feature_add_command}
/// Base class for:
///
///  * [AndroidFeatureAddCommand]
///
///  * [IosFeatureAddCommand]
///
///  * [LinuxFeatureAddCommand]
///
///  * [MacosFeatureAddCommand]
///
///  * [WebFeatureAddCommand]
///
///  * [WindowsFeatureAddCommand]
/// {@endtemplate}
abstract class PlatformFeatureAddCommand extends Command<int> {
  /// {@macro platform_feature_add_command}
  PlatformFeatureAddCommand({
    required Platform platform,
    required PlatformFeatureAddBlocCommand blocCommand,
    required PlatformFeatureAddCubitCommand cubitCommand,
  }) : _platform = platform {
    addSubcommand(blocCommand);
    addSubcommand(cubitCommand);
  }

  final Platform _platform;

  @override
  String get name => 'add';

  @override
  String get invocation =>
      'rapid ${_platform.name} feature add <subcommand>'; // TODO component

  @override
  String get description =>
      'Add components to features of the ${_platform.prettyName} part of an existing Rapid project.';
}
