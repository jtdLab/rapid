import 'package:args/command_runner.dart';
import 'package:mason/mason.dart';
import 'package:rapid_cli/src/commands/infrastructure/add/data_transfer_object/data_transfer_object.dart';
import 'package:rapid_cli/src/commands/infrastructure/add/service_implementation/service_implementation.dart';
import 'package:rapid_cli/src/project/project.dart';

/// {@template infrastructure_add_command}
/// `rapid infrastructure add` command add components to the infrastructure part part of an existing Rapid project.
/// {@endtemplate}
class InfrastructureAddCommand extends Command<int> {
  /// {@macro infrastructure_add_command}
  InfrastructureAddCommand({
    Logger? logger,
    required Project project,
  }) {
    addSubcommand(InfrastructureAddDataTransferObjectCommand(project: project));
    addSubcommand(
      InfrastructureAddServiceImplementationCommand(project: project),
    );
  }

  @override
  String get name => 'add';

  @override
  String get invocation => 'rapid infrastructure add <component>';

  @override
  String get description =>
      'Adds a component to the infrastructure part of an existing Rapid project.';
}
