import 'package:rapid_cli/src/commands/deactivate/core/platform.dart';
import 'package:rapid_cli/src2/core/platform.dart';
import 'package:rapid_cli/src2/project/project.dart';

/// {@template deactivate_web_command}
/// `rapid deactivate web` command removes support for Web from an existing Rapid project.
/// {@endtemplate}
class DeactivateWebCommand extends DeactivatePlatformCommand {
  DeactivateWebCommand({
    super.logger,
    required Project project,
  }) : super(
          platform: Platform.web,
          project: project,
        );
}
