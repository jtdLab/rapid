import 'package:rapid_cli/src/commands/core/platform/remove/navigator/navigator.dart';
import 'package:rapid_cli/src/core/platform.dart';

/// {@template linux_remove_navigator_command}
/// `rapid linux remove navigator` command removes a navigator from the navigation package of the Linux part of an existing Rapid project.
/// {@endtemplate}
class LinuxRemoveNavigatorCommand extends PlatformRemoveNavigatorCommand {
  /// {@macro linux_remove_navigator_command}
  LinuxRemoveNavigatorCommand({
    super.logger,
    super.project,
    super.flutterPubGet,
    super.flutterPubRunBuildRunnerBuildDeleteConflictingOutputs,
    super.dartFormatFix,
  }) : super(
          platform: Platform.linux,
        );
}
