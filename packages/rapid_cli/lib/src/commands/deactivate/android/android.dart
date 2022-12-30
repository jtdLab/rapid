import 'package:mason/mason.dart';
import 'package:rapid_cli/src/cli/cli.dart';
import 'package:rapid_cli/src/commands/deactivate/deactivate_sub_command.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/project/project.dart';

/// {@template deactivate_android_command}
/// `rapid deactivate android` command removes support for Android from an existing Rapid project.
/// {@endtemplate}
class AndroidCommand extends DeactivateSubCommand {
  AndroidCommand({
    Logger? logger,
    required Project project,
    FlutterPubRunBuildRunnerBuildDeleteConflictingOutputsCommand?
        flutterPubRunBuildRunnerBuildDeleteConflictingOutputs,
  }) : super(
          platform: Platform.android,
          logger: logger ?? Logger(),
          project: project,
          flutterPubRunBuildRunnerBuildDeleteConflictingOutputs:
              flutterPubRunBuildRunnerBuildDeleteConflictingOutputs ??
                  Flutter.pubRunBuildRunnerBuildDeleteConflictingOutputs,
        );
}
