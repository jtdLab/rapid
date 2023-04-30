import 'package:rapid_cli/src/commands/core/platform/add/navigator/navigator.dart';
import 'package:rapid_cli/src/core/platform.dart';

/// {@template ios_add_navigator_command}
/// `rapid ios add navigator` command adds a navigator to the navigation package of the iOS part of an existing Rapid project.
/// {@endtemplate}
class IosAddNavigatorCommand extends PlatformAddNavigatorCommand {
  /// {@macro ios_add_navigator_command}
  IosAddNavigatorCommand({
    super.logger,
    super.project,
    super.flutterPubGet,
    super.flutterPubRunBuildRunnerBuildDeleteConflictingOutputs,
    super.dartFormatFix,
  }) : super(
          platform: Platform.ios,
        );
}
