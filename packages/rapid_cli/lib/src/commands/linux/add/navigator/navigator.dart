import 'package:rapid_cli/src/commands/core/platform/add/navigator/navigator.dart';
import 'package:rapid_cli/src/core/platform.dart';

/// {@template linux_add_navigator_command}
/// `rapid linux add navigator` command adds a navigator to the navigation package of the Linux part of an existing Rapid project.
/// {@endtemplate}
class LinuxAddNavigatorCommand extends PlatformAddNavigatorCommand {
  /// {@macro linux_add_navigator_command}
  LinuxAddNavigatorCommand({
    super.logger,
    super.project,
    super.flutterPubGet,
    super.flutterPubRunBuildRunnerBuildDeleteConflictingOutputs,
    super.dartFormatFix,
  }) : super(
          platform: Platform.linux,
        );
}
