import 'package:mason/mason.dart';
import 'package:rapid_cli/src/commands/core/platform/platform.dart';
import 'package:rapid_cli/src/commands/web/add/add.dart';
import 'package:rapid_cli/src/commands/web/feature/feature.dart';
import 'package:rapid_cli/src/commands/web/remove/remove.dart';
import 'package:rapid_cli/src/commands/web/set/set.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/project/project.dart';

/// {@template web_command}
/// `rapid web` command work with the Web part of an existing Rapid project.
/// {@endtemplate}
class WebCommand extends PlatformCommand {
  /// {@macro web_command}
  WebCommand({
    Logger? logger,
    Project? project,
  }) : super(
          platform: Platform.web,
          addCommand: WebAddCommand(logger: logger, project: project),
          featureCommands: (featurePackages) => featurePackages.map(
            (e) => WebFeatureCommand(
              logger: logger,
              project: project,
              featurePackage: e,
            ),
          ),
          removeCommand: WebRemoveCommand(logger: logger, project: project),
          setCommand: WebSetCommand(logger: logger, project: project),
        );
}
