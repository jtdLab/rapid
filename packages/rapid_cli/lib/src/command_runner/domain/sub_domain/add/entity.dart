import '../../../base.dart';
import '../../../util/class_name_rest.dart';

/// {@template domain_sub_domain_add_entity_command}
/// `rapid domain sub_domain add entity` add an entity to the domain part of a Rapid project.
/// {@endtemplate}
class DomainSubDomainAddEntityCommand extends RapidLeafCommand
    with ClassNameGetter {
  /// {@macro domain_sub_domain_add_entity_command}
  DomainSubDomainAddEntityCommand(this.subDomainName, super.project);

  final String subDomainName;

  @override
  String get name => 'entity';

  @override
  String get invocation =>
      'rapid domain $subDomainName add entity <name> [arguments]';

  @override
  String get description => 'Add an entity to the subdomain $subDomainName.';

  @override
  Future<void> run() {
    final name = super.className;
    final subDomainName =
        this.subDomainName == 'default' ? null : this.subDomainName;

    return rapid.domainSubDomainAddEntity(
      name: name,
      subDomainName: subDomainName,
    );
  }
}
