import 'package:rapid_cli/src/commands/core/platform/remove/navigator/navigator.dart';
import 'package:rapid_cli/src/core/platform.dart';

/// {@template mobile_remove_navigator_command}
/// `rapid mobile remove navigator` command removes a navigator from the navigation package of the Mobile part of an existing Rapid project.
/// {@endtemplate}
class MobileRemoveNavigatorCommand extends PlatformRemoveNavigatorCommand {
  /// {@macro mobile_remove_navigator_command}
  MobileRemoveNavigatorCommand({
    super.logger,
    super.project,
    super.flutterPubGet,
    super.flutterPubRunBuildRunnerBuildDeleteConflictingOutputs,
    super.dartFormatFix,
  }) : super(
          platform: Platform.mobile,
        );
}
