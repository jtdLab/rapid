import 'package:args/command_runner.dart';
import 'package:mason/mason.dart';
import 'package:rapid_cli/src/commands/pub/add/add.dart';
import 'package:rapid_cli/src/commands/pub/remove/remove.dart';

/// {@template pub_command}
/// `rapid pub` command work with packages in a Rapid environment.
/// {@endtemplate}
class PubCommand extends Command<int> {
  /// {@macro ui_command}
  PubCommand({
    Logger? logger,
  }) {
    addSubcommand(PubAddCommand(logger: logger));
    addSubcommand(PubRemoveCommand(logger: logger));
  }

  @override
  String get name => 'pub';

  @override
  String get invocation => 'rapid pub <subcommand>';

  @override
  String get description => 'Work with packages in a Rapid environment.';
}
