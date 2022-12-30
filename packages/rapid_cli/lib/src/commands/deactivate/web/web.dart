import 'package:mason/mason.dart';
import 'package:rapid_cli/src/cli/cli.dart';
import 'package:rapid_cli/src/commands/deactivate/deactivate_sub_command.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/project/project.dart';

/// {@template deactivate_web_command}
/// `rapid deactivate web` command removes support for Web from an existing Rapid project.
/// {@endtemplate}
class WebCommand extends DeactivateSubCommand {
  WebCommand({
    Logger? logger,
    required Project project,
    FlutterPubRunBuildRunnerBuildDeleteConflictingOutputsCommand?
        flutterPubRunBuildRunnerBuildDeleteConflictingOutputs,
  }) : super(
          platform: Platform.web,
          logger: logger ?? Logger(),
          project: project,
          flutterPubRunBuildRunnerBuildDeleteConflictingOutputs:
              flutterPubRunBuildRunnerBuildDeleteConflictingOutputs ??
                  Flutter.pubRunBuildRunnerBuildDeleteConflictingOutputs,
        );
}
