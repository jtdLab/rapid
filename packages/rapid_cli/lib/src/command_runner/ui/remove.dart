import '../base.dart';
import 'remove/widget.dart';

/// {@template ui_remove_command}
/// `rapid ui remove` remove a component from the platform independent UI part of a Rapid project.
/// {@endtemplate}
class UiRemoveCommand extends RapidBranchCommand {
  /// {@macro ui_remove_command}
  UiRemoveCommand(super.project) {
    addSubcommand(UiRemoveWidgetCommand(project));
  }

  @override
  String get name => 'remove';

  @override
  String get invocation => 'rapid ui remove <component>';

  @override
  String get description =>
      'Remove a component from the platform independent UI part of a Rapid project.';
}
