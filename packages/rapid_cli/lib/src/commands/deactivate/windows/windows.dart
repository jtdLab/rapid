import 'package:rapid_cli/src/commands/deactivate/core/platform.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/project/project.dart';

/// {@template deactivate_windows_command}
/// `rapid deactivate windows` command removes support for Windows from an existing Rapid project.
/// {@endtemplate}
class DeactivateWindowsCommand extends DeactivatePlatformCommand {
  DeactivateWindowsCommand({
    super.logger,
    required Project project,
  }) : super(
          platform: Platform.windows,
          project: project,
        );
}
