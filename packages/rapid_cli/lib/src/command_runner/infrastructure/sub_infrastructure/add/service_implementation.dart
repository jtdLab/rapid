import '../../../base.dart';
import '../../../util/class_name_rest.dart';
import '../../../util/output_dir_option.dart';
import '../../../util/service_option.dart';

/// {@template infrastructure_sub_infrastructure_add_service_implementation_command}
/// `rapid infrastructure sub_infrastructure add service_implementation` command adds service_implementation to the infrastructure part of an existing Rapid project.
/// {@endtemplate}
class InfrastructureSubInfrastructureAddServiceImplementationCommand
    extends RapidLeafCommand
    with ClassNameGetter, ServiceGetter, OutputDirGetter {
  /// {@macro infrastructure_sub_infrastructure_add_service_implementation_command}
  InfrastructureSubInfrastructureAddServiceImplementationCommand(
    this.subInfrastructureName,
    super.project,
  ) {
    argParser
      ..addSeparator('')
      ..addServiceOption()
      ..addOutputDirOption(
        help:
            'The output directory relative to <infrastructure_package>/lib/src .',
      );
  }

  final String subInfrastructureName;

  @override
  String get name => 'service_implementation';

  @override
  List<String> get aliases => ['service', 'si'];

  @override
  String get invocation =>
      'rapid infrastructure $subInfrastructureName add service_implementation <name> [arguments]';

  @override
  String get description =>
      'Add a service implementation to the subinfrastructure $subInfrastructureName.';

  @override
  Future<void> run() {
    final name = super.className;
    final subInfrastructureName = this.subInfrastructureName == 'default'
        ? null
        : this.subInfrastructureName;
    final serviceName = super.service; // TODO rename
    // final outputDir = super.outputDir; TODO rm?

    return rapid.infrastructureSubInfrastructureAddServiceImplementation(
      name: name,
      subInfrastructureName: subInfrastructureName,
      serviceInterfaceName: serviceName,
    );
  }
}
