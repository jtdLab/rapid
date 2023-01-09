import 'package:rapid_cli/src/commands/deactivate/core/platform.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/project/project.dart';

/// {@template deactivate_ios_command}
/// `rapid deactivate ios` command removes support for iOS from an existing Rapid project.
/// {@endtemplate}
class DeactivateIosCommand extends DeactivatePlatformCommand {
  DeactivateIosCommand({
    super.logger,
    required Project project,
    super.flutterPubGet,
    super.flutterPubRunBuildRunnerBuildDeleteConflictingOutputs,
  }) : super(
          platform: Platform.ios,
          project: project,
        );
}
