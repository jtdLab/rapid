import 'package:args/command_runner.dart';
import 'package:mason/mason.dart';
import 'package:rapid_cli/src/commands/infrastructure/add/add.dart';
import 'package:rapid_cli/src/commands/infrastructure/remove/remove.dart';
import 'package:rapid_cli/src/project/project.dart';

/// {@template infrastructure_command}
/// `rapid infrastructure` command work with the infrastructure part of an existing Rapid project.
/// {@endtemplate}
class InfrastructureCommand extends Command<int> {
  /// {@macro infrastructure_command}
  InfrastructureCommand({
    Logger? logger,
    required Project project,
  }) {
    addSubcommand(InfrastructureAddCommand(project: project));
    addSubcommand(InfrastructureRemoveCommand(project: project));
  }

  @override
  String get name => 'infrastructure';

  @override
  List<String> get aliases => ['infra'];

  @override
  String get invocation => 'rapid infrastructure <subcommand>';

  @override
  String get description =>
      'Work with the infrastructure part of an existing Rapid project.';
}
