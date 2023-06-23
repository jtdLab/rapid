import '../../base.dart';
import 'remove/data_transfer_object.dart';
import 'remove/service_implementation.dart';

/// {@template infrastructure_sub_infrastructure_remove_command}
/// `rapid infrastructure sub_infrastructure remove` command remove components from the infrastructure part of an existing Rapid project.
/// {@endtemplate}
class InfrastructureSubInfrastructureRemoveCommand extends RapidBranchCommand {
  /// {@macro infrastructure_sub_infrastructure_remove_command}
  InfrastructureSubInfrastructureRemoveCommand(
    this.subInfrastructureName,
    super.project,
  ) {
    addSubcommand(
      InfrastructureSubInfrastructureRemoveDataTransferObjectCommand(
        subInfrastructureName,
        project,
      ),
    );
    addSubcommand(
      InfrastructureSubInfrastructureRemoveServiceImplementationCommand(
        subInfrastructureName,
        project,
      ),
    );
  }

  final String subInfrastructureName;

  @override
  String get name => 'remove';

  @override
  String get invocation =>
      'rapid infrastructure $subInfrastructureName remove <component>';

  @override
  String get description =>
      'Remove a component from the subinfrastructure $subInfrastructureName.';
}
