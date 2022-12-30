import 'package:mason/mason.dart';
import 'package:rapid_cli/src/cli/cli.dart';
import 'package:rapid_cli/src/commands/deactivate/deactivate_sub_command.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/project/project.dart';

/// {@template deactivate_linux_command}
/// `rapid deactivate linux` command removes support for Linux from an existing Rapid project.
/// {@endtemplate}
class LinuxCommand extends DeactivateSubCommand {
  LinuxCommand({
    Logger? logger,
    required Project project,
    FlutterPubRunBuildRunnerBuildDeleteConflictingOutputsCommand?
        flutterPubRunBuildRunnerBuildDeleteConflictingOutputs,
  }) : super(
          platform: Platform.linux,
          logger: logger ?? Logger(),
          project: project,
          flutterPubRunBuildRunnerBuildDeleteConflictingOutputs:
              flutterPubRunBuildRunnerBuildDeleteConflictingOutputs ??
                  Flutter.pubRunBuildRunnerBuildDeleteConflictingOutputs,
        );
}
