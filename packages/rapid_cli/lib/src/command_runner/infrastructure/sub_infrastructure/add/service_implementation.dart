import '../../../base.dart';
import '../../../util/class_name_rest.dart';
import '../../../util/service_option.dart';

/// {@template infra_sub_infrastructure_add_service_implementation_command}
/// `rapid infrastructure sub_infrastructure add service_implementation`
/// adds service_implementation to the infrastructure part of a Rapid project.
/// {@endtemplate}
class InfrastructureSubInfrastructureAddServiceImplementationCommand
    extends RapidSubInfrastructureLeafCommand
    with ClassNameGetter, ServiceGetter {
  /// {@macro infra_sub_infrastructure_add_service_implementation_command}
  InfrastructureSubInfrastructureAddServiceImplementationCommand(
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
      '''rapid infrastructure $subInfrastructureName add service_implementation <name> [arguments]''';

  @override
  String get description =>
      'Add a service implementation to the subinfrastructure '
      '$subInfrastructureName.';

  @override
  Future<void> run() {
    final name = super.className;
    final subInfrastructureName = this.subInfrastructureName == 'default'
        ? null
        : this.subInfrastructureName;
    final service = super.service;

    return rapid.infrastructureSubInfrastructureAddServiceImplementation(
      name: name,
      subInfrastructureName: subInfrastructureName,
      serviceInterfaceName: service,
    );
  }
}
