import '../../../base.dart';
import '../../../util/class_name_rest.dart';
import '../../../util/dir_option.dart';

// TODO maybe introduce super class for entity, service interface and value object remove

/// {@template domain_sub_domain_remove_entity_command}
/// `rapid domain sub_domain remove entity` command removes entity from the domain part of an existing Rapid project.
/// {@endtemplate}
class DomainSubDomainRemoveEntityCommand extends RapidLeafCommand
    with ClassNameGetter, DirGetter {
  /// {@macro domain_sub_domain_remove_entity_command}
  DomainSubDomainRemoveEntityCommand(this.subDomainName, super.project) {
    argParser
      ..addSeparator('')
      ..addDirOption(
        help: 'The directory relative to <domain_package>/lib/ .',
      );
  }

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
    // final dir = super.dir; // TODO rm

    return rapid.domainSubDomainRemoveEntity(
      name: name,
      subDomainName: subDomainName,
    );
  }
}
