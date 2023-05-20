import 'package:args/command_runner.dart';
import 'package:mason/mason.dart';
import 'package:rapid_cli/src/commands/domain/sub_domain/remove/entity/entity.dart';
import 'package:rapid_cli/src/commands/domain/sub_domain/remove/service_interface/service_interface.dart';
import 'package:rapid_cli/src/commands/domain/sub_domain/remove/value_object/value_object.dart';
import 'package:rapid_cli/src/project/domain_directory/domain_package/domain_package.dart';
import 'package:rapid_cli/src/project/project.dart';

/// {@template domain_sub_domain_remove_command}
/// `rapid domain sub_domain remove` command remove components from the domain part of an existing Rapid project.
/// {@endtemplate}
class DomainSubDomainRemoveCommand extends Command<int> {
  /// {@macro domain_sub_domain_remove_command}
  DomainSubDomainRemoveCommand({
    Logger? logger,
    Project? project,
    required DomainPackage domainPackage,
  }) : _domainPackage = domainPackage {
    addSubcommand(
      DomainSubDomainRemoveEntityCommand(
        project: project,
        domainPackage: domainPackage,
      ),
    );
    addSubcommand(
      DomainSubDomainRemoveServiceInterfaceCommand(
        project: project,
        domainPackage: domainPackage,
      ),
    );
    addSubcommand(
      DomainSubDomainRemoveValueObjectCommand(
        project: project,
        domainPackage: domainPackage,
      ),
    );
  }

  final DomainPackage _domainPackage;

  @override
  String get name => 'remove';

  @override
  String get invocation =>
      'rapid domain ${_domainPackage.name ?? 'default'} remove <component>';

  @override
  String get description =>
      'Remove a component from the subdomain ${_domainPackage.name ?? 'default'}.';
}
