import '../../../project/platform.dart';
import '../../../utils.dart';
import '../../base.dart';
import 'remove/widget.dart';

/// {@template ui_platform_remove_command}
/// `rapid ui <platform> remove` remove a component from the platform UI part of a Rapid project.
/// {@endtemplate}
class UiPlatformRemoveCommand extends RapidBranchCommand {
  /// {@macro ui_platform_remove_command}
  UiPlatformRemoveCommand(this.platform, super.project) {
    addSubcommand(UiPlatformRemoveWidgetCommand(platform, project));
  }

  final Platform platform;

  @override
  String get name => 'remove';

  @override
  String get invocation => 'rapid ui ${platform.name} remove <component>';

  @override
  String get description =>
      'Remove a component from the ${platform.prettyName} UI part of a Rapid project.';
}
