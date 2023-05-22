import 'package:mason/mason.dart';
import 'package:rapid_cli/src/commands/core/platform/platform.dart';
import 'package:rapid_cli/src/commands/mobile/add/add.dart';
import 'package:rapid_cli/src/commands/mobile/feature/feature.dart';
import 'package:rapid_cli/src/commands/mobile/remove/remove.dart';
import 'package:rapid_cli/src/commands/mobile/set/set.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/project/project.dart';

/// {@template mobile_command}
/// `rapid mobile` command work with the Mobile part of an existing Rapid project.
/// {@endtemplate}
class MobileCommand extends PlatformCommand {
  /// {@macro mobile_command}
  MobileCommand({
    Logger? logger,
    Project? project,
  }) : super(
          platform: Platform.mobile,
          project: project,
          addCommand: MobileAddCommand(logger: logger, project: project),
          featureCommands: (featurePackages) => featurePackages.map(
            (e) => MobileFeatureCommand(
              logger: logger,
              project: project,
              featurePackage: e,
            ),
          ),
          removeCommand: MobileRemoveCommand(logger: logger, project: project),
          setCommand: MobileSetCommand(logger: logger, project: project),
        );
}
