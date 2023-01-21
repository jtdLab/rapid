import 'package:mason/mason.dart';
import 'package:rapid_cli/src/commands/web/add/add.dart';
import 'package:rapid_cli/src/commands/web/feature/feature.dart';
import 'package:rapid_cli/src/commands/web/remove/remove.dart';
import 'package:rapid_cli/src/commands/core/platform/platform.dart';
import 'package:rapid_cli/src2/core/platform.dart';
import 'package:rapid_cli/src2/project/project.dart';

/// {@template web_command}
/// `rapid web` command work with the Web part of an existing Rapid project.
/// {@endtemplate}
class WebCommand extends PlatformCommand {
  /// {@macro web_command}
  WebCommand({
    Logger? logger,
    required Project project,
  }) : super(
          platform: Platform.web,
          addCommand: WebAddCommand(logger: logger, project: project),
          featureCommand: WebFeatureCommand(logger: logger, project: project),
          removeCommand: WebRemoveCommand(logger: logger, project: project),
        );
}
