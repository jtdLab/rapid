import '../../base.dart';
import 'add/data_transfer_object.dart';
import 'add/service_implementation.dart';

/// {@template infrastructure_sub_infrastructure_add_command}
/// `rapid infrastructure sub_infrastructure add` command add components to the infrastructure part of an existing Rapid project.
/// {@endtemplate}
class InfrastructureSubInfrastructureAddCommand extends RapidBranchCommand {
  /// {@macro infrastructure_sub_infrastructure_add_command}
  InfrastructureSubInfrastructureAddCommand(
    this.subInfrastructureName,
    super.project,
  ) {
    addSubcommand(
      InfrastructureSubInfrastructureAddDataTransferObjectCommand(
        subInfrastructureName,
        project,
      ),
    );
    addSubcommand(
      InfrastructureSubInfrastructureAddServiceImplementationCommand(
        subInfrastructureName,
        project,
      ),
    );
  }

  final String subInfrastructureName;

  @override
  String get name => 'add';

  @override
  String get invocation =>
      'rapid infrastructure $subInfrastructureName add <component>';

  @override
  String get description =>
      'Add a component to the subinfrastructure $subInfrastructureName.';
}
