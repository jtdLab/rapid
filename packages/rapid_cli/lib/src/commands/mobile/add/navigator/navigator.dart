import 'package:rapid_cli/src/commands/core/platform/add/navigator/navigator.dart';
import 'package:rapid_cli/src/core/platform.dart';

/// {@template mobile_add_navigator_command}
/// `rapid mobile add navigator` command adds a navigator to the navigation package of the Mobile part of an existing Rapid project.
/// {@endtemplate}
class MobileAddNavigatorCommand extends PlatformAddNavigatorCommand {
  /// {@macro mobile_add_navigator_command}
  MobileAddNavigatorCommand({
    super.logger,
    super.project,
    super.flutterPubGet,
    super.flutterPubRunBuildRunnerBuildDeleteConflictingOutputs,
    super.dartFormatFix,
  }) : super(
          platform: Platform.mobile,
        );
}
