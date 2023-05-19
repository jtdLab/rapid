import 'package:args/command_runner.dart';
import 'package:rapid_cli/src/commands/android/android.dart';
import 'package:rapid_cli/src/commands/core/platform/add/add.dart';
import 'package:rapid_cli/src/commands/core/platform/feature/feature.dart';
import 'package:rapid_cli/src/commands/core/platform/remove/remove.dart';
import 'package:rapid_cli/src/commands/core/platform/set/set.dart';
import 'package:rapid_cli/src/commands/core/platform_x.dart';
import 'package:rapid_cli/src/commands/ios/ios.dart';
import 'package:rapid_cli/src/commands/linux/linux.dart';
import 'package:rapid_cli/src/commands/macos/macos.dart';
import 'package:rapid_cli/src/commands/web/web.dart';
import 'package:rapid_cli/src/commands/windows/windows.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/project/platform_directory/platform_features_directory/platform_feature_package/platform_feature_package.dart';
import 'package:rapid_cli/src/project/project.dart';

/// {@template platform_command}
/// Base class for:
///
///  * [AndroidCommand]
///
///  * [IosCommand]
///
///  * [LinuxCommand]
///
///  * [MacosCommand]
///
///  * [WebCommand]
///
///  * [WindowsCommand]
/// {@endtemplate}
abstract class PlatformCommand extends Command<int> {
  /// {@macro platform_command}
  PlatformCommand({
    required Platform platform,
    Project? project,
    required PlatformAddCommand addCommand,
    required Iterable<PlatformFeatureCommand> Function(
      List<PlatformFeaturePackage>,
    ) featureCommands,
    required PlatformRemoveCommand removeCommand,
    required PlatformSetCommand setCommand,
  })  : _platform = platform,
        _project = project ?? Project() {
    addSubcommand(addCommand);
    try {
      // TODO: cleaner
      final featurePackages = (_project)
          .platformDirectory(platform: platform)
          .featuresDirectory
          .featurePackages();
      for (final featureCommand in featureCommands(featurePackages)) {
        addSubcommand(featureCommand);
      }
    } catch (_) {}
    addSubcommand(removeCommand);
    addSubcommand(setCommand);
  }

  final Platform _platform;

  final Project _project;

  @override
  String get name => _platform.name;

  @override
  List<String> get aliases => _platform.aliases;

  @override
  String get invocation => 'rapid ${_platform.name} <subcommand>';

  @override
  String get description =>
      'Work with the ${_platform.prettyName} part of an existing Rapid project.';
}
