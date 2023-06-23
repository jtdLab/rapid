import '../base.dart';
import 'add/widget.dart';

/// {@template ui_add_command}
/// `rapid ui add` command adds components to the platform independent UI part of an existing Rapid project.
/// {@endtemplate}
class UiAddCommand extends RapidBranchCommand {
  /// {@macro ui_add_command}
  UiAddCommand(super.project) {
    addSubcommand(UiAddWidgetCommand(project));
  }

  @override
  String get name => 'add';

  @override
  String get invocation => 'rapid ui add <subcommand>';

  @override
  String get description =>
      'Add components to the platform independent UI part of an existing Rapid project.';
}
