import 'package:args/command_runner.dart';
import 'package:rapid_cli/src/commands/android/feature/feature.dart';
import 'package:rapid_cli/src/commands/core/platform/feature/add/add.dart';
import 'package:rapid_cli/src/commands/core/platform/feature/remove/remove.dart';
import 'package:rapid_cli/src/commands/core/platform_x.dart';
import 'package:rapid_cli/src/commands/ios/feature/feature.dart';
import 'package:rapid_cli/src/commands/linux/feature/feature.dart';
import 'package:rapid_cli/src/commands/macos/feature/feature.dart';
import 'package:rapid_cli/src/commands/web/feature/feature.dart';
import 'package:rapid_cli/src/commands/windows/feature/feature.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/project/platform_directory/platform_features_directory/platform_feature_package/platform_feature_package.dart';

/// {@template platform_feature_command}
/// Base class for:
///
///  * [AndroidFeatureCommand]
///
///  * [IosFeatureCommand]
///
///  * [LinuxFeatureCommand]
///
///  * [MacosFeatureCommand]
///
///  * [WebFeatureCommand]
///
///  * [WindowsFeatureCommand]
/// {@endtemplate}
abstract class PlatformFeatureCommand extends Command<int> {
  /// {@macro platform_feature_command}
  PlatformFeatureCommand({
    required Platform platform,
    required PlatformFeaturePackage featurePackage,
    required PlatformFeatureAddCommand addCommand,
    required PlatformFeatureRemoveCommand removeCommand,
  })  : _platform = platform,
        _featurePackage = featurePackage {
    addSubcommand(addCommand);
    addSubcommand(removeCommand);
  }

  final Platform _platform;

  final PlatformFeaturePackage _featurePackage;

  @override
  String get name => _featurePackage.name;

  @override
  String get invocation =>
      'rapid ${_platform.name} ${_featurePackage.name} <subcommand>';

  @override
  String get description =>
      'Work with ${_featurePackage.name} of the ${_platform.prettyName} part of an existing Rapid project.';
}
