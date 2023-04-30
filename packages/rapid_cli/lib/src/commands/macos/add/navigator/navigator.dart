import 'package:rapid_cli/src/commands/core/platform/add/navigator/navigator.dart';
import 'package:rapid_cli/src/core/platform.dart';

/// {@template macos_add_navigator_command}
/// `rapid macos add navigator` command adds a navigator to the navigation package of the macOS part of an existing Rapid project.
/// {@endtemplate}
class MacosAddNavigatorCommand extends PlatformAddNavigatorCommand {
  /// {@macro macos_add_navigator_command}
  MacosAddNavigatorCommand({
    super.logger,
    super.project,
    super.flutterPubGet,
    super.flutterPubRunBuildRunnerBuildDeleteConflictingOutputs,
    super.dartFormatFix,
  }) : super(
          platform: Platform.macos,
        );
}
