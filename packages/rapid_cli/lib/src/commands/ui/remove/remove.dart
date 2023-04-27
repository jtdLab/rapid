import 'package:args/command_runner.dart';
import 'package:mason/mason.dart';
import 'package:rapid_cli/src/commands/ui/remove/widget/widget.dart';
import 'package:rapid_cli/src/project/project.dart';

/// {@template ui_remove_command}
/// `rapid ui remove` command removes components from the platform independent UI part of an existing Rapid project.
/// {@endtemplate}
class UiRemoveCommand extends Command<int> {
  /// {@macro ui_remove_command}
  UiRemoveCommand({
    Logger? logger,
    Project? project,
  }) {
    addSubcommand(UiRemoveWidgetCommand(logger: logger, project: project));
  }

  @override
  String get name => 'remove';

  @override
  String get invocation => 'rapid ui remove <subcommand>';

  @override
  String get description =>
      'Remove components from the platform independent UI part of an existing Rapid project.';
}
