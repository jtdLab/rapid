import '../../base.dart';
import 'add/data_transfer_object.dart';
import 'add/service_implementation.dart';

/// {@template infrastructure_sub_infrastructure_add_command}
/// `rapid infrastructure sub_infrastructure add` add a component to
/// the infrastructure part of a Rapid project.
/// {@endtemplate}
class InfrastructureSubInfrastructureAddCommand
    extends RapidSubInfrastructureBranchCommand {
  /// {@macro infrastructure_sub_infrastructure_add_command}
  InfrastructureSubInfrastructureAddCommand(
    super.project, {
    required super.subInfrastructureName,
  }) {
    addSubcommand(
      InfrastructureSubInfrastructureAddDataTransferObjectCommand(
        project,
        subInfrastructureName: subInfrastructureName,
      ),
    );
    addSubcommand(
      InfrastructureSubInfrastructureAddServiceImplementationCommand(
        project,
        subInfrastructureName: subInfrastructureName,
      ),
    );
  }

  @override
  String get name => 'add';

  @override
  String get invocation =>
      'rapid infrastructure $subInfrastructureName add <component>';

  @override
  String get description =>
      'Add a component to the subinfrastructure $subInfrastructureName.';
}
