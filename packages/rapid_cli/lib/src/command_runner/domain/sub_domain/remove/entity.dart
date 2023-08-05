import '../../../base.dart';
import '../../../util/class_name_rest.dart';

/// {@template domain_sub_domain_remove_entity_command}
/// `rapid domain sub_domain remove entity` command removes entity from the domain part of an existing Rapid project.
/// {@endtemplate}
class DomainSubDomainRemoveEntityCommand extends RapidLeafCommand
    with ClassNameGetter {
  /// {@macro domain_sub_domain_remove_entity_command}
  DomainSubDomainRemoveEntityCommand(this.subDomainName, super.project);

  final String subDomainName;

  @override
  String get name => 'entity';

  @override
  String get invocation =>
      'rapid domain $subDomainName remove entity <name> [arguments]';

  @override
  String get description =>
      'Remove an entity from the subdomain $subDomainName.';

  @override
  Future<void> run() {
    final name = super.className;
    final subDomainName =
        this.subDomainName == 'default' ? null : this.subDomainName;

    return rapid.domainSubDomainRemoveEntity(
      name: name,
      subDomainName: subDomainName,
    );
  }
}
