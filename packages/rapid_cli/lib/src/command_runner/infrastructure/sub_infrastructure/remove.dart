import '../../base.dart';
import 'remove/data_transfer_object.dart';
import 'remove/service_implementation.dart';

/// {@template infrastructure_sub_infrastructure_remove_command}
/// `rapid infrastructure sub_infrastructure remove` remove a component from
/// the infrastructure part of a Rapid project.
/// {@endtemplate}
class InfrastructureSubInfrastructureRemoveCommand
    extends RapidSubInfrastructureBranchCommand {
  /// {@macro infrastructure_sub_infrastructure_remove_command}
  InfrastructureSubInfrastructureRemoveCommand(
    super.project, {
    required super.subInfrastructureName,
  }) {
    addSubcommand(
      InfrastructureSubInfrastructureRemoveDataTransferObjectCommand(
        project,
        subInfrastructureName: subInfrastructureName,
      ),
    );
    addSubcommand(
      InfrastructureSubInfrastructureRemoveServiceImplementationCommand(
        project,
        subInfrastructureName: subInfrastructureName,
      ),
    );
  }

  @override
  String get name => 'remove';

  @override
  String get invocation =>
      'rapid infrastructure $subInfrastructureName remove <component>';

  @override
  String get description =>
      'Remove a component from the subinfrastructure $subInfrastructureName.';
}
