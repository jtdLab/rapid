import 'package:rapid_cli/src/commands/core/platform/remove/navigator/navigator.dart';
import 'package:rapid_cli/src/core/platform.dart';

/// {@template android_remove_navigator_command}
/// `rapid android remove navigator` command removes a navigator from the navigation package of the Android part of an existing Rapid project.
/// {@endtemplate}
class AndroidRemoveNavigatorCommand extends PlatformRemoveNavigatorCommand {
  /// {@macro android_remove_navigator_command}
  AndroidRemoveNavigatorCommand({
    super.logger,
    super.project,
    super.flutterPubGet,
    super.flutterPubRunBuildRunnerBuildDeleteConflictingOutputs,
    super.dartFormatFix,
  }) : super(
          platform: Platform.android,
        );
}
