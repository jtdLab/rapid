import '../../../base.dart';
import '../../../util/class_name_rest.dart';
import '../../../util/output_dir_option.dart';

/// {@template domain_sub_domain_add_service_interface_command}
/// `rapid domain sub_domain add service_interface` command adds service_interface to the domain part of an existing Rapid project.
/// {@endtemplate}
class DomainSubDomainAddServiceInterfaceCommand extends RapidLeafCommand
    with ClassNameGetter, OutputDirGetter {
  /// {@macro domain_sub_domain_add_service_interface_command}
  DomainSubDomainAddServiceInterfaceCommand(this.subDomainName, super.project) {
    argParser
      ..addSeparator('')
      ..addOutputDirOption(
        help: 'The output directory relative to <domain_package>/lib/ .',
      );
  }

  final String subDomainName;

  @override
  String get name => 'service_interface';

  @override
  List<String> get aliases => ['service', 'si'];

  @override
  String get invocation =>
      'rapid domain $subDomainName add service_interface <name> [arguments]';

  @override
  String get description =>
      'Add a service interface to the subdomain $subDomainName.';

  @override
  Future<void> run() {
    final name = super.className;
    final subDomainName =
        this.subDomainName == 'default' ? null : this.subDomainName;
    final outputDir = super.outputDir;

    return rapid.domainSubDomainAddServiceInterface(
      name: name,
      subDomainName: subDomainName,
      outputDir: outputDir,
    );
  }
}
