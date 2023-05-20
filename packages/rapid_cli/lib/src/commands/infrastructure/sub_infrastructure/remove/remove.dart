import 'package:args/command_runner.dart';
import 'package:mason/mason.dart';
import 'package:rapid_cli/src/commands/infrastructure/sub_infrastructure/remove/data_transfer_object/data_transfer_object.dart';
import 'package:rapid_cli/src/commands/infrastructure/sub_infrastructure/remove/service_implementation/service_implementation.dart';
import 'package:rapid_cli/src/project/infrastructure_directory/infrastructure_package/infrastructure_package.dart';
import 'package:rapid_cli/src/project/project.dart';

/// {@template infrastructure_sub_infrastructure_remove_command}
/// `rapid infrastructure sub_infrastructure remove` command remove components from the infrastructure part of an existing Rapid project.
/// {@endtemplate}
class InfrastructureSubInfrastructureRemoveCommand extends Command<int> {
  /// {@macro infrastructure_sub_infrastructure_remove_command}
  InfrastructureSubInfrastructureRemoveCommand({
    Logger? logger,
    Project? project,
    required InfrastructurePackage infrastructurePackage,
  }) : _infrastructurePackage = infrastructurePackage {
    addSubcommand(
      InfrastructureSubInfrastructureRemoveDataTransferObjectCommand(
        project: project,
        infrastructurePackage: infrastructurePackage,
      ),
    );
    addSubcommand(
      InfrastructureSubInfrastructureRemoveServiceImplementationCommand(
        project: project,
        infrastructurePackage: infrastructurePackage,
      ),
    );
  }

  final InfrastructurePackage _infrastructurePackage;

  @override
  String get name => 'remove';

  @override
  String get invocation =>
      'rapid infrastructure ${_infrastructurePackage.name ?? 'default'} remove <component>';

  @override
  String get description =>
      'Remove a component from the subinfrastructure${_infrastructurePackage.name ?? 'default'}.';
}
