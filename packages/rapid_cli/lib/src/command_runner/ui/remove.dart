import '../base.dart';
import 'remove/widget.dart';

/// {@template ui_remove_command}
/// `rapid ui remove` command removes components from the platform independent UI part of an existing Rapid project.
/// {@endtemplate}
class UiRemoveCommand extends RapidBranchCommand {
  /// {@macro ui_remove_command}
  UiRemoveCommand(super.project) {
    addSubcommand(UiRemoveWidgetCommand(project));
  }

  @override
  String get name => 'remove';

  @override
  String get invocation => 'rapid ui remove <subcommand>';

  @override
  String get description =>
      'Remove components from the platform independent UI part of an existing Rapid project.';
}
