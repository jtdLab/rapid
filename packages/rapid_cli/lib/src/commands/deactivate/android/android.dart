import 'package:rapid_cli/src/commands/deactivate/core/platform.dart';
import 'package:rapid_cli/src2/core/platform.dart';
import 'package:rapid_cli/src2/project/project.dart';

/// {@template deactivate_android_command}
/// `rapid deactivate android` command removes support for Android from an existing Rapid project.
/// {@endtemplate}
class DeactivateAndroidCommand extends DeactivatePlatformCommand {
  DeactivateAndroidCommand({
    super.logger,
    required Project project,
  }) : super(
          platform: Platform.android,
          project: project,
        );
}
