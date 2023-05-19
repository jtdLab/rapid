import 'package:mason/mason.dart';
import 'package:rapid_cli/src/commands/core/platform/platform.dart';
import 'package:rapid_cli/src/commands/ios/add/add.dart';
import 'package:rapid_cli/src/commands/ios/feature/feature.dart';
import 'package:rapid_cli/src/commands/ios/remove/remove.dart';
import 'package:rapid_cli/src/commands/ios/set/set.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/project/project.dart';

/// {@template ios_command}
/// `rapid ios` command work with the iOS part of an existing Rapid project.
/// {@endtemplate}
class IosCommand extends PlatformCommand {
  /// {@macro ios_command}
  IosCommand({
    Logger? logger,
    Project? project,
  }) : super(
          platform: Platform.ios,
          addCommand: IosAddCommand(logger: logger, project: project),
          featureCommands: (featurePackages) => featurePackages.map(
            (e) => IosFeatureCommand(
              logger: logger,
              project: project,
              featurePackage: e,
            ),
          ),
          removeCommand: IosRemoveCommand(logger: logger, project: project),
          setCommand: IosSetCommand(logger: logger, project: project),
        );
}
