import '../project/project.dart';
import 'base.dart';
import 'infrastructure/sub_infrastructure.dart';

/// {@template infrastructure_command}
/// `rapid infrastructure` work with the infrastructure part of a Rapid project.
/// {@endtemplate}
class InfrastructureCommand extends RapidBranchCommand {
  /// {@macro infrastructure_command}
  InfrastructureCommand(super.project) {
    final infrastructurePackages =
        project?.appModule.infrastructureDirectory.infrastructurePackages();
    for (final infrastructurePackage
        in infrastructurePackages ?? <InfrastructurePackage>[]) {
      addSubcommand(
        InfrastructureSubinfrastructureCommand(
          infrastructurePackage.name ?? 'default',
          project,
        ),
      );
    }
  }

  @override
  String get name => 'infrastructure';

  @override
  List<String> get aliases => ['infra'];

  @override
  String get invocation => 'rapid infrastructure <subcommand>';

  @override
  String get description =>
      'Work with the infrastructure part of a Rapid project.';
}
