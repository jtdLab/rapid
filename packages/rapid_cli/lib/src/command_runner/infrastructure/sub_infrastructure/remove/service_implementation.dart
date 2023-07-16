import '../../../base.dart';
import '../../../util/class_name_rest.dart';
import '../../../util/service_option.dart';

/// {@template infrastructure_sub_infrastructure_remove_service_implementation_command}
/// `rapid infrastructure sub_infrastructure remove service_implementation` command removes service implementation from the infrastructure part of an existing Rapid project.
/// {@endtemplate}
class InfrastructureSubInfrastructureRemoveServiceImplementationCommand
    extends RapidLeafCommand with ClassNameGetter, ServiceGetter {
  /// {@macro infrastructure_sub_infrastructure_remove_service_implementation_command}
  InfrastructureSubInfrastructureRemoveServiceImplementationCommand(
    this.subInfrastructureName,
    super.project,
  ) {
    argParser
      ..addSeparator('')
      ..addServiceOption();
  }

  final String subInfrastructureName;

  @override
  String get name => 'service_implementation';

  @override
  List<String> get aliases => ['service', 'si'];

  @override
  String get invocation =>
      'rapid infrastructure $subInfrastructureName remove service_implementation <name> [arguments]';

  @override
  String get description =>
      'Remove a service implementation from the subinfrastructure $subInfrastructureName.';

  @override
  Future<void> run() {
    final name = super.className;
    final subInfrastructureName = this.subInfrastructureName == 'default'
        ? null
        : this.subInfrastructureName;
    final service = super.service;

    return rapid.infrastructureSubInfrastructureRemoveServiceImplementation(
      name: name,
      subInfrastructureName: subInfrastructureName,
      serviceInterfaceName: service,
    );
  }
}
