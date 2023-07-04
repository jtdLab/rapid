import '../../../base.dart';
import '../../../util/class_name_rest.dart';
import '../../../util/output_dir_option.dart';

/// {@template domain_sub_domain_add_entity_command}
/// `rapid domain sub_domain add entity` command adds entity to the domain part of an existing Rapid project.
/// {@endtemplate}
class DomainSubDomainAddEntityCommand extends RapidLeafCommand
    with ClassNameGetter, OutputDirGetter {
  /// {@macro domain_sub_domain_add_entity_command}
  DomainSubDomainAddEntityCommand(this.subDomainName, super.project) {
    argParser
      ..addSeparator('')
      ..addOutputDirOption(
        help: 'The output directory relative to <domain_package>/lib/ .',
      );
  }

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
    // final outputDir = super.outputDir; TODO rm?

    return rapid.domainSubDomainAddEntity(
      name: name,
      subDomainName: subDomainName,
    );
  }
}
