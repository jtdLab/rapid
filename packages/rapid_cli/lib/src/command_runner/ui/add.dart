import '../base.dart';
import 'add/widget.dart';

/// {@template ui_add_command}
/// `rapid ui add` add a component to the platform independent UI part of a
/// Rapid project.
/// {@endtemplate}
class UiAddCommand extends RapidBranchCommand {
  /// {@macro ui_add_command}
  UiAddCommand(super.project) {
    addSubcommand(UiAddWidgetCommand(project));
  }

  @override
  String get name => 'add';

  @override
  String get invocation => 'rapid ui add <component>';

  @override
  String get description =>
      'Add a component to the platform independent UI part of a Rapid project.';
}
