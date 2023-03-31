import 'package:args/command_runner.dart';
import 'package:mason/mason.dart';
import 'package:rapid_cli/src/commands/infrastructure/sub_infrastructure/remove/data_transfer_object/data_transfer_object.dart';
import 'package:rapid_cli/src/commands/infrastructure/sub_infrastructure/remove/service_implementation/service_implementation.dart';
import 'package:rapid_cli/src/project/project.dart';

/// {@template infrastructure_sub_infrastructure_remove_command}
/// `rapid infrastructure sub_infrastructure remove` command remove components from the infrastructure part of an existing Rapid project.
/// {@endtemplate}
class InfrastructureSubInfrastructureRemoveCommand extends Command<int> {
  /// {@macro infrastructure_sub_infrastructure_remove_command}
  InfrastructureSubInfrastructureRemoveCommand({
    Logger? logger,
    required Project project,
  }) {
    addSubcommand(
      InfrastructureSubInfrastructureRemoveDataTransferObjectCommand(
        project: project,
      ),
    );
    addSubcommand(
      InfrastructureSubInfrastructureRemoveServiceImplementationCommand(
        project: project,
      ),
    );
  }

  @override
  String get name => 'remove';

  @override
  String get invocation =>
      'rapid infrastructure sub_infrastructure remove <component>';

  @override
  String get description =>
      'Remove a component from the infrastructure part of an existing Rapid project.';
}
