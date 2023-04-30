import 'package:rapid_cli/src/commands/core/platform/add/navigator/navigator.dart';
import 'package:rapid_cli/src/core/platform.dart';

/// {@template android_add_navigator_command}
/// `rapid android add navigator` command adds a navigator to the navigation package of the Android part of an existing Rapid project.
/// {@endtemplate}
class AndroidAddNavigatorCommand extends PlatformAddNavigatorCommand {
  /// {@macro android_add_navigator_command}
  AndroidAddNavigatorCommand({
    super.logger,
    super.project,
    super.flutterPubGet,
    super.flutterPubRunBuildRunnerBuildDeleteConflictingOutputs,
    super.dartFormatFix,
  }) : super(
          platform: Platform.android,
        );
}
