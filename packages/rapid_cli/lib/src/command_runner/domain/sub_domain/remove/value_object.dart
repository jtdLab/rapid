import '../../../base.dart';
import '../../../util/class_name_rest.dart';

/// {@template domain_sub_domain_remove_value_object_command}
/// `rapid domain sub_domain remove value_object` remove a value object
/// from the domain part of a Rapid project.
/// {@endtemplate}
class DomainSubDomainRemoveValueObjectCommand extends RapidSubDomainLeafCommand
    with ClassNameGetter {
  /// {@macro domain_sub_domain_remove_value_object_command}
  DomainSubDomainRemoveValueObjectCommand(
    super.project, {
    required super.subDomainName,
  });

  @override
  String get name => 'value_object';

  @override
  List<String> get aliases => ['vo'];

  @override
  String get invocation =>
      'rapid domain $subDomainName remove value_object <name> [arguments]';

  @override
  String get description =>
      'Remove a value object from the subdomain $subDomainName.';

  @override
  Future<void> run() {
    final name = super.className;
    final subDomainName =
        this.subDomainName == 'default' ? null : this.subDomainName;

    return rapid.domainSubDomainRemoveValueObject(
      name: name,
      subDomainName: subDomainName,
    );
  }
}
