import 'package:args/command_runner.dart';
import 'package:mason/mason.dart';
import 'package:rapid_cli/src/commands/infrastructure/sub_infrastructure/add/data_transfer_object/data_transfer_object.dart';
import 'package:rapid_cli/src/commands/infrastructure/sub_infrastructure/add/service_implementation/service_implementation.dart';
import 'package:rapid_cli/src/project/project.dart';

/// {@template infrastructure_sub_infrastructure_add_command}
/// `rapid infrastructure sub_infrastructure add` command add components to the infrastructure part of an existing Rapid project.
/// {@endtemplate}
class InfrastructureSubInfrastructureAddCommand extends Command<int> {
  /// {@macro infrastructure_sub_infrastructure_add_command}
  InfrastructureSubInfrastructureAddCommand({
    Logger? logger,
    required Project project,
  }) {
    addSubcommand(
      InfrastructureSubInfrastructureAddDataTransferObjectCommand(
        project: project,
      ),
    );
    addSubcommand(
      InfrastructureSubInfrastructureAddServiceImplementationCommand(
        project: project,
      ),
    );
  }

  @override
  String get name => 'add';

  @override
  String get invocation =>
      'rapid infrastructure sub_infrastructure add <component>';

  @override
  String get description =>
      'Add a component to the infrastructure part of an existing Rapid project.';
}
