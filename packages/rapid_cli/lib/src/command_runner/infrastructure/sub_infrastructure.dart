import '../base.dart';
import 'sub_infrastructure/add.dart';
import 'sub_infrastructure/remove.dart';

/// {@template infrastructure_sub_infrastructure_command}
/// `rapid infrastructure sub_infrastructure` work with a subinfrastructure of the infrastructure part of a Rapid project.
/// {@endtemplate}
class InfrastructureSubinfrastructureCommand extends RapidBranchCommand {
  /// {@macro infrastructure_sub_infrastructure_command}
  InfrastructureSubinfrastructureCommand(
    this.subInfrastructureName,
    super.project,
  ) {
    addSubcommand(
      InfrastructureSubInfrastructureAddCommand(subInfrastructureName, project),
    );
    addSubcommand(
      InfrastructureSubInfrastructureRemoveCommand(
        subInfrastructureName,
        project,
      ),
    );
  }

  final String subInfrastructureName;

  @override
  String get name => subInfrastructureName;

  @override
  String get invocation =>
      'rapid infrastructure $subInfrastructureName <command>';

  @override
  String get description =>
      'Work with the subinfrastructure $subInfrastructureName.';
}
