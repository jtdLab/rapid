import 'package:args/command_runner.dart';
import 'package:mason/mason.dart';
import 'package:rapid_cli/src/commands/infrastructure/sub_infrastructure/add/data_transfer_object/data_transfer_object.dart';
import 'package:rapid_cli/src/commands/infrastructure/sub_infrastructure/add/service_implementation/service_implementation.dart';
import 'package:rapid_cli/src/project/infrastructure_directory/infrastructure_package/infrastructure_package.dart';
import 'package:rapid_cli/src/project/project.dart';

/// {@template infrastructure_sub_infrastructure_add_command}
/// `rapid infrastructure sub_infrastructure add` command add components to the infrastructure part of an existing Rapid project.
/// {@endtemplate}
class InfrastructureSubInfrastructureAddCommand extends Command<int> {
  /// {@macro infrastructure_sub_infrastructure_add_command}
  InfrastructureSubInfrastructureAddCommand({
    Logger? logger,
    Project? project,
    required InfrastructurePackage infrastructurePackage,
  }) : _infrastructurePackage = infrastructurePackage {
    addSubcommand(
      InfrastructureSubInfrastructureAddDataTransferObjectCommand(
        project: project,
        infrastructurePackage: infrastructurePackage,
      ),
    );
    addSubcommand(
      InfrastructureSubInfrastructureAddServiceImplementationCommand(
        project: project,
        infrastructurePackage: infrastructurePackage,
      ),
    );
  }

  final InfrastructurePackage _infrastructurePackage;

  @override
  String get name => 'add';

  @override
  String get invocation =>
      'rapid infrastructure ${_infrastructurePackage.name ?? 'default'} add <component>';

  @override
  String get description =>
      'Add a component to the subinfrastructure ${_infrastructurePackage.name ?? 'default'}.';
}
