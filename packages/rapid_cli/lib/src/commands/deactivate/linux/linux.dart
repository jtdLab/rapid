import 'package:rapid_cli/src/commands/deactivate/core/platform.dart';
import 'package:rapid_cli/src/core/platform.dart';

/// {@template deactivate_linux_command}
/// `rapid deactivate linux` command removes support for Linux from an existing Rapid project.
/// {@endtemplate}
class DeactivateLinuxCommand extends DeactivatePlatformCommand {
  DeactivateLinuxCommand({
    super.logger,
    super.project,
  }) : super(
          platform: Platform.linux,
        );
}
