import '../../../utils.dart';
import '../../base.dart';
import 'remove/widget.dart';

/// {@template ui_platform_remove_command}
/// `rapid ui <platform> remove` remove a component from the platform UI part of a Rapid project.
/// {@endtemplate}
class UiPlatformRemoveCommand extends RapidPlatformBranchCommand {
  /// {@macro ui_platform_remove_command}
  UiPlatformRemoveCommand(super.project, {required super.platform}) {
    addSubcommand(UiPlatformRemoveWidgetCommand(project, platform: platform));
  }

  @override
  String get name => 'remove';

  @override
  String get invocation => 'rapid ui ${platform.name} remove <component>';

  @override
  String get description =>
      'Remove a component from the ${platform.prettyName} UI part of a Rapid project.';
}
