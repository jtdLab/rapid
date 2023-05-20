import 'package:args/command_runner.dart';
import 'package:mason/mason.dart';
import 'package:rapid_cli/src/commands/infrastructure/sub_infrastructure/add/add.dart';
import 'package:rapid_cli/src/commands/infrastructure/sub_infrastructure/remove/remove.dart';
import 'package:rapid_cli/src/project/infrastructure_directory/infrastructure_package/infrastructure_package.dart';
import 'package:rapid_cli/src/project/project.dart';

/// {@template infrastructure_sub_infrastructure_command}
/// `rapid infrastructure sub_infrastructure` command work with subinfrastructures of the infrastructure part of an existing Rapid project.
/// {@endtemplate}
class InfrastructureSubinfrastructureCommand extends Command<int> {
  /// {@macro infrastructure_sub_infrastructure_command}
  InfrastructureSubinfrastructureCommand({
    Logger? logger,
    Project? project,
    required InfrastructurePackage infrastructurePackage,
  }) : _infrastructurePackage = infrastructurePackage {
    addSubcommand(
      InfrastructureSubInfrastructureAddCommand(
        project: project,
        infrastructurePackage: infrastructurePackage,
      ),
    );
    addSubcommand(
      InfrastructureSubInfrastructureRemoveCommand(
        project: project,
        infrastructurePackage: infrastructurePackage,
      ),
    );
  }

  final InfrastructurePackage _infrastructurePackage;

  @override
  String get name => _infrastructurePackage.name ?? 'default'; // TODO not clean

  @override
  List<String> get aliases => ['sub', 'si'];

  @override
  String get invocation =>
      'rapid infrastructure ${_infrastructurePackage.name ?? 'default'} <subcommand>';

  @override
  String get description =>
      'Work with the subinfrastructure ${_infrastructurePackage.name ?? 'default'}.';
}
