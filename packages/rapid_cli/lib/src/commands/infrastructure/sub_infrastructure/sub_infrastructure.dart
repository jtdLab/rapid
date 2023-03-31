import 'package:args/command_runner.dart';
import 'package:mason/mason.dart';
import 'package:rapid_cli/src/commands/infrastructure/sub_infrastructure/add/add.dart';
import 'package:rapid_cli/src/commands/infrastructure/sub_infrastructure/remove/remove.dart';
import 'package:rapid_cli/src/project/project.dart';

/// {@template infrastructure_sub_infrastructure_command}
/// `rapid infrastructure sub_infrastructure` command work with subinfrastructures of the infrastructure part of an existing Rapid project.
/// {@endtemplate}
class InfrastructureSubinfrastructureCommand extends Command<int> {
  /// {@macro infrastructure_sub_infrastructure_command}
  InfrastructureSubinfrastructureCommand({
    Logger? logger,
    required Project project,
  }) {
    addSubcommand(InfrastructureSubInfrastructureAddCommand(project: project));
    addSubcommand(
      InfrastructureSubInfrastructureRemoveCommand(project: project),
    );
  }

  @override
  String get name => 'sub_infrastructure';

  @override
  String get invocation =>
      'rapid infrastructure sub_infrastructure <subcommand>';

  @override
  String get description =>
      'Work with the subinfrastructures of the infrastructure part of an existing Rapid project.';
}
