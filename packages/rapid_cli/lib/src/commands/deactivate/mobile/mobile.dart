import 'package:rapid_cli/src/commands/deactivate/core/platform.dart';
import 'package:rapid_cli/src/core/platform.dart';

/// {@template deactivate_mobile_command}
/// `rapid deactivate mobile` command removes support for Mobile from an existing Rapid project.
/// {@endtemplate}
class DeactivateMobileCommand extends DeactivatePlatformCommand {
  DeactivateMobileCommand({
    super.logger,
    super.project,
  }) : super(
          platform: Platform.mobile,
        );
}
