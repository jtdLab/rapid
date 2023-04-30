import 'package:rapid_cli/src/commands/core/platform/remove/navigator/navigator.dart';
import 'package:rapid_cli/src/core/platform.dart';

/// {@template web_remove_navigator_command}
/// `rapid web remove navigator` command removes a navigator from the navigation package of the Web part of an existing Rapid project.
/// {@endtemplate}
class WebRemoveNavigatorCommand extends PlatformRemoveNavigatorCommand {
  /// {@macro web_remove_navigator_command}
  WebRemoveNavigatorCommand({
    super.logger,
    super.project,
    super.flutterPubGet,
    super.flutterPubRunBuildRunnerBuildDeleteConflictingOutputs,
    super.dartFormatFix,
  }) : super(
          platform: Platform.web,
        );
}
