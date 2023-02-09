import 'package:rapid_cli/src/commands/deactivate/core/platform.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/project/project.dart';

/// {@template deactivate_macos_command}
/// `rapid deactivate macos` command removes support for macOS from an existing Rapid project.
/// {@endtemplate}
class DeactivateMacosCommand extends DeactivatePlatformCommand {
  DeactivateMacosCommand({
    super.logger,
    super.project,
  }) : super(
          platform: Platform.macos,
        );
}
