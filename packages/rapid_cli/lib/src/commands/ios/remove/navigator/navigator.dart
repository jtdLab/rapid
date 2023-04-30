import 'package:rapid_cli/src/commands/core/platform/remove/navigator/navigator.dart';
import 'package:rapid_cli/src/core/platform.dart';

/// {@template ios_remove_navigator_command}
/// `rapid ios remove navigator` command removes a navigator from the navigation package of the iOS part of an existing Rapid project.
/// {@endtemplate}
class IosRemoveNavigatorCommand extends PlatformRemoveNavigatorCommand {
  /// {@macro ios_remove_navigator_command}
  IosRemoveNavigatorCommand({
    super.logger,
    super.project,
    super.flutterPubGet,
    super.flutterPubRunBuildRunnerBuildDeleteConflictingOutputs,
    super.dartFormatFix,
  }) : super(
          platform: Platform.ios,
        );
}
