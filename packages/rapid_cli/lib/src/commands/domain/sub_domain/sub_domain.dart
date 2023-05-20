import 'package:args/command_runner.dart';
import 'package:mason/mason.dart';
import 'package:rapid_cli/src/commands/domain/sub_domain/add/add.dart';
import 'package:rapid_cli/src/commands/domain/sub_domain/remove/remove.dart';
import 'package:rapid_cli/src/project/domain_directory/domain_package/domain_package.dart';
import 'package:rapid_cli/src/project/project.dart';

/// {@template domain_sub_domain_command}
/// `rapid domain sub_domain` command work with subdomains of the domain part of an existing Rapid project.
/// {@endtemplate}
class DomainSubdomainCommand extends Command<int> {
  /// {@macro domain_sub_domain_command}
  DomainSubdomainCommand({
    Logger? logger,
    Project? project,
    required DomainPackage domainPackage,
  }) : _domainPackage = domainPackage {
    addSubcommand(
      DomainSubDomainAddCommand(
        project: project,
        domainPackage: domainPackage,
      ),
    );
    addSubcommand(
      DomainSubDomainRemoveCommand(
        project: project,
        domainPackage: domainPackage,
      ),
    );
  }

  final DomainPackage _domainPackage;

  @override
  String get name => _domainPackage.name ?? 'default'; // TODO not clean

  @override
  List<String> get aliases => ['sub', 'sd'];

  @override
  String get invocation =>
      'rapid domain ${_domainPackage.name ?? 'default'} <subcommand>';

  @override
  String get description =>
      'Work with the subdomain ${_domainPackage.name ?? 'default'}.';
}
