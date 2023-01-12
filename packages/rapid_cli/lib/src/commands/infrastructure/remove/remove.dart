import 'package:args/command_runner.dart';
import 'package:mason/mason.dart';
import 'package:rapid_cli/src/commands/infrastructure/remove/data_transfer_object/data_transfer_object.dart';
import 'package:rapid_cli/src/commands/infrastructure/remove/service_implementation/service_implementation.dart';
import 'package:rapid_cli/src/project/project.dart';

/// {@template infrastructure_remove_command}
/// `rapid infrastructure remove` command remove components from the infrastructure part of an existing Rapid project.
/// {@endtemplate}
class InfrastructureRemoveCommand extends Command<int> {
  /// {@macro infrastructure_remove_command}
  InfrastructureRemoveCommand({
    Logger? logger,
    required Project project,
  }) {
    addSubcommand(
        InfrastructureRemoveDataTransferObjectCommand(project: project));
    addSubcommand(
        InfrastructureRemoveServiceImplementationCommand(project: project));
  }

  @override
  String get name => 'remove';

  @override
  String get invocation => 'rapid infrastructure remove <component>';

  @override
  String get description =>
      'Remove a component from the infrastructure part of an existing Rapid project.';
}
