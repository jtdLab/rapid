import '../../../base.dart';
import '../../../util/entity_option.dart';

/// {@template infrastructure_sub_infrastructure_add_data_transfer_object_command}
/// `rapid infrastructure sub_infrastructure add data_transfer_object` command adds data_transfer_object to the infrastructure part of an existing Rapid project.
/// {@endtemplate}
class InfrastructureSubInfrastructureAddDataTransferObjectCommand
    extends RapidLeafCommand with EntityGetter {
  /// {@macro infrastructure_sub_infrastructure_add_data_transfer_object_command}
  InfrastructureSubInfrastructureAddDataTransferObjectCommand(
    this.subInfrastructureName,
    super.project,
  ) {
    argParser
      ..addSeparator('')
      ..addEntityOption();
  }

  final String subInfrastructureName;

  @override
  String get name => 'data_transfer_object';

  @override
  List<String> get aliases => ['dto'];

  @override
  String get invocation =>
      'rapid infrastructure $subInfrastructureName add data_transfer_object [arguments]';

  @override
  String get description =>
      'Add a data transfer object to the subinfrastructure $subInfrastructureName.';

  @override
  Future<void> run() {
    final subInfrastructureName = this.subInfrastructureName == 'default'
        ? null
        : this.subInfrastructureName;
    final entityName = super.entity;

    return rapid.infrastructureSubInfrastructureAddDataTransferObject(
      subInfrastructureName: subInfrastructureName,
      entityName: entityName,
    );
  }
}
