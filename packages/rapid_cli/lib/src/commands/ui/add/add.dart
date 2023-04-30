import 'package:args/command_runner.dart';
import 'package:mason/mason.dart';
import 'package:rapid_cli/src/commands/ui/add/widget/widget.dart';
import 'package:rapid_cli/src/project/project.dart';

/// {@template ui_add_command}
/// `rapid ui add` command adds components to the platform independent UI part of an existing Rapid project.
/// {@endtemplate}
class UiAddCommand extends Command<int> {
  /// {@macro ui_add_command}
  UiAddCommand({
    Logger? logger,
    Project? project,
  }) {
    addSubcommand(UiAddWidgetCommand(logger: logger, project: project));
  }

  @override
  String get name => 'add';

  @override
  String get invocation => 'rapid ui add <subcommand>';

  @override
  String get description =>
      'Add components to the platform independent UI part of an existing Rapid project.';
}
