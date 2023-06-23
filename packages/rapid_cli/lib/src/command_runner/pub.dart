import 'base.dart';
import 'pub/add.dart';
import 'pub/get.dart';
import 'pub/remove.dart';

/// {@template pub_command}
/// `rapid pub` command work with packages in a Rapid environment.
/// {@endtemplate}
class PubCommand extends RapidBranchCommand {
  /// {@macro ui_command}
  PubCommand(super.project) {
    addSubcommand(PubAddCommand(project));
    addSubcommand(PubGetCommand(project));
    addSubcommand(PubRemoveCommand(project));
  }

  @override
  String get name => 'pub';

  @override
  String get invocation => 'rapid pub <subcommand>';

  @override
  String get description => 'Work with packages in a Rapid environment.';
}
