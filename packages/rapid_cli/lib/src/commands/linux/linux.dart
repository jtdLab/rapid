import 'package:mason/mason.dart';
import 'package:rapid_cli/src/commands/core/platform/platform.dart';
import 'package:rapid_cli/src/commands/linux/add/add.dart';
import 'package:rapid_cli/src/commands/linux/feature/feature.dart';
import 'package:rapid_cli/src/commands/linux/remove/remove.dart';
import 'package:rapid_cli/src/commands/linux/set/set.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/project/project.dart';

/// {@template linux_command}
/// `rapid linux` command work with the Linux part of an existing Rapid project.
/// {@endtemplate}
class LinuxCommand extends PlatformCommand {
  /// {@macro linux_command}
  LinuxCommand({
    Logger? logger,
    required Project project,
  }) : super(
          platform: Platform.linux,
          addCommand: LinuxAddCommand(logger: logger, project: project),
          featureCommand: LinuxFeatureCommand(logger: logger, project: project),
          removeCommand: LinuxRemoveCommand(logger: logger, project: project),
          setCommand: LinuxSetCommand(logger: logger, project: project),
        );
}
