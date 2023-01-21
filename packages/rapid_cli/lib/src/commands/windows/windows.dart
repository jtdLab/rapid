import 'package:mason/mason.dart';
import 'package:rapid_cli/src/commands/windows/add/add.dart';
import 'package:rapid_cli/src/commands/windows/feature/feature.dart';
import 'package:rapid_cli/src/commands/windows/remove/remove.dart';
import 'package:rapid_cli/src/commands/core/platform/platform.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/project/project.dart';

/// {@template windows_command}
/// `rapid windows` command work with the Windows part of an existing Rapid project.
/// {@endtemplate}
class WindowsCommand extends PlatformCommand {
  /// {@macro windows_command}
  WindowsCommand({
    Logger? logger,
    required Project project,
  }) : super(
          platform: Platform.windows,
          addCommand: WindowsAddCommand(logger: logger, project: project),
          featureCommand:
              WindowsFeatureCommand(logger: logger, project: project),
          removeCommand: WindowsRemoveCommand(logger: logger, project: project),
        );
}
