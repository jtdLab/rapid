import '../../../base.dart';
import '../../../util/dir_option.dart';
import '../../../util/entity_option.dart';

// TODO maybe introduce super class for dto and service implementation remove

/// {@template infrastructure_sub_infrastructure_remove_data_transfer_object_command}
/// `rapid infrastructure sub_infrastructure remove data_transfer_object` command removes data transfer object from the infrastructure part of an existing Rapid project.
/// {@endtemplate}
class InfrastructureSubInfrastructureRemoveDataTransferObjectCommand
    extends RapidLeafCommand with EntityGetter, DirGetter {
  /// {@macro infrastructure_sub_infrastructure_remove_data_transfer_object_command}
  InfrastructureSubInfrastructureRemoveDataTransferObjectCommand(
    this.subInfrastructureName,
    super.project,
  ) {
    argParser
      ..addSeparator('')
      ..addEntityOption()
      ..addDirOption(
        help: 'The directory relative to <infrastructure_package>/lib/ .',
      );
  }

  final String subInfrastructureName;

  @override
  String get name => 'data_transfer_object';

  @override
  List<String> get aliases => ['dto'];

  @override
  String get invocation =>
      'rapid infrastructure $subInfrastructureName remove data_transfer_object <name> [arguments]';

  @override
  String get description =>
      'Remove a data transfer object from the subinfrastructure $subInfrastructureName.';

  @override
  Future<void> run() {
    final subInfrastructureName = this.subInfrastructureName == 'default'
        ? null
        : this.subInfrastructureName;
    final entityName = super.entity;
    // final dir = super.dir; // TODO rm

    return rapid.infrastructureSubInfrastructureRemoveDataTransferObject(
      subInfrastructureName: subInfrastructureName,
      entityName: entityName,
    );
  }
}
