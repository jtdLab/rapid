import 'package:rapid_cli/src/commands/core/platform/add/navigator/navigator.dart';
import 'package:rapid_cli/src/core/platform.dart';

/// {@template windows_add_navigator_command}
/// `rapid windows add navigator` command adds a navigator to the navigation package of the Windows part of an existing Rapid project.
/// {@endtemplate}
class WindowsAddNavigatorCommand extends PlatformAddNavigatorCommand {
  /// {@macro windows_add_navigator_command}
  WindowsAddNavigatorCommand({
    super.logger,
    super.project,
    super.flutterPubGet,
    super.flutterPubRunBuildRunnerBuildDeleteConflictingOutputs,
    super.dartFormatFix,
  }) : super(
          platform: Platform.windows,
        );
}
