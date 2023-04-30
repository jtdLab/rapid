import 'package:rapid_cli/src/commands/core/platform/add/navigator/navigator.dart';
import 'package:rapid_cli/src/core/platform.dart';

/// {@template web_add_navigator_command}
/// `rapid web add navigator` command adds a navigator to the navigation package of the Web part of an existing Rapid project.
/// {@endtemplate}
class WebAddNavigatorCommand extends PlatformAddNavigatorCommand {
  /// {@macro web_add_navigator_command}
  WebAddNavigatorCommand({
    super.logger,
    super.project,
    super.flutterPubGet,
    super.flutterPubRunBuildRunnerBuildDeleteConflictingOutputs,
    super.dartFormatFix,
  }) : super(
          platform: Platform.web,
        );
}
