import '../../../base.dart';
import '../../../util/class_name_rest.dart';
import '../../../util/dir_option.dart';

/// {@template domain_sub_domain_remove_service_interface_command}
/// `rapid domain sub_domain remove service_interface` command removes service interface from the domain part of an existing Rapid project.
/// {@endtemplate}
class DomainSubDomainRemoveServiceInterfaceCommand extends RapidLeafCommand
    with ClassNameGetter, DirGetter {
  /// {@macro domain_sub_domain_remove_service_interface_command}
  DomainSubDomainRemoveServiceInterfaceCommand(
    this.subDomainName,
    super.project,
  ) {
    argParser
      ..addSeparator('')
      ..addDirOption(
        help: 'The directory relative to <domain_package>/lib/ .',
      );
  }

  final String subDomainName;

  @override
  String get name => 'service_interface';

  @override
  List<String> get aliases => ['service', 'si'];

  @override
  String get invocation =>
      'rapid domain $subDomainName remove service_interface <name> [arguments]';

  @override
  String get description =>
      'Remove a service interface from the subdomain $subDomainName.';

  @override
  Future<void> run() {
    final name = super.className;
    final subDomainName =
        this.subDomainName == 'default' ? null : this.subDomainName;
    final dir = super.dir;

    return rapid.domainSubDomainRemoveServiceInterface(
      name: name,
      subDomainName: subDomainName,
      dir: dir,
    );
  }
}
