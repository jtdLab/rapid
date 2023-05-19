import 'package:args/command_runner.dart';
import 'package:rapid_cli/src/commands/android/feature/add/add.dart';
import 'package:rapid_cli/src/commands/core/platform/feature/add/bloc/bloc.dart';
import 'package:rapid_cli/src/commands/core/platform/feature/add/cubit/cubit.dart';
import 'package:rapid_cli/src/commands/core/platform_x.dart';
import 'package:rapid_cli/src/commands/ios/feature/add/add.dart';
import 'package:rapid_cli/src/commands/linux/feature/add/add.dart';
import 'package:rapid_cli/src/commands/macos/feature/add/add.dart';
import 'package:rapid_cli/src/commands/web/feature/add/add.dart';
import 'package:rapid_cli/src/commands/windows/feature/add/add.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/project/platform_directory/platform_features_directory/platform_feature_package/platform_feature_package.dart';

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
    required PlatformFeaturePackage featurePackage,
    required PlatformFeatureAddBlocCommand blocCommand,
    required PlatformFeatureAddCubitCommand cubitCommand,
  })  : _platform = platform,
        _featurePackage = featurePackage {
    addSubcommand(blocCommand);
    addSubcommand(cubitCommand);
  }

  final Platform _platform;

  final PlatformFeaturePackage _featurePackage;

  @override
  String get name => 'add';

  @override
  String get invocation =>
      'rapid ${_platform.name} ${_featurePackage.name} add <component>';

  @override
  String get description =>
      'Add components to ${_featurePackage.name} of the ${_platform.prettyName} part of an existing Rapid project.';
}
