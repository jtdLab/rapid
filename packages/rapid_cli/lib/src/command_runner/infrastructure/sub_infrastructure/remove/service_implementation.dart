import '../../../base.dart';
import '../../../util/class_name_rest.dart';
import '../../../util/service_option.dart';

/// {@template infra_sub_infrastructure_remove_service_implementation_command}
/// `rapid infrastructure sub_infrastructure remove service_implementation`
/// remove a service implementation from the infrastructure part
/// of a Rapid project.
/// {@endtemplate}
class InfrastructureSubInfrastructureRemoveServiceImplementationCommand
    extends RapidSubInfrastructureLeafCommand
    with ClassNameGetter, ServiceGetter {
  /// {@macro infra_sub_infrastructure_remove_service_implementation_command}
  InfrastructureSubInfrastructureRemoveServiceImplementationCommand(
    super.project, {
    required super.subInfrastructureName,
  }) {
    argParser
      ..addSeparator('')
      ..addServiceOption();
  }

  @override
  String get name => 'service_implementation';

  @override
  List<String> get aliases => ['service', 'si'];

  @override
  String get invocation =>
      '''rapid infrastructure $subInfrastructureName remove service_implementation <name> [arguments]''';

  @override
  String get description =>
      'Remove a service implementation from the subinfrastructure '
      '$subInfrastructureName.';

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
