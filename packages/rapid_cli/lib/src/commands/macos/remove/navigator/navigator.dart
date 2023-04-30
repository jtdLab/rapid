import 'package:rapid_cli/src/commands/core/platform/remove/navigator/navigator.dart';
import 'package:rapid_cli/src/core/platform.dart';

/// {@template macos_remove_navigator_command}
/// `rapid macos remove navigator` command removes a navigator from the navigation package of the macOS part of an existing Rapid project.
/// {@endtemplate}
class MacosRemoveNavigatorCommand extends PlatformRemoveNavigatorCommand {
  /// {@macro macos_remove_navigator_command}
  MacosRemoveNavigatorCommand({
    super.logger,
    super.project,
    super.flutterPubGet,
    super.flutterPubRunBuildRunnerBuildDeleteConflictingOutputs,
    super.dartFormatFix,
  }) : super(
          platform: Platform.macos,
        );
}
