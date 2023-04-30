import 'package:rapid_cli/src/commands/core/platform/remove/navigator/navigator.dart';
import 'package:rapid_cli/src/core/platform.dart';

/// {@template windows_remove_navigator_command}
/// `rapid windows remove navigator` command removes a navigator from the navigation package of the Windows part of an existing Rapid project.
/// {@endtemplate}
class WindowsRemoveNavigatorCommand extends PlatformRemoveNavigatorCommand {
  /// {@macro windows_remove_navigator_command}
  WindowsRemoveNavigatorCommand({
    super.logger,
    super.project,
    super.flutterPubGet,
    super.flutterPubRunBuildRunnerBuildDeleteConflictingOutputs,
    super.dartFormatFix,
  }) : super(
          platform: Platform.windows,
        );
}
