import '../../../base.dart';
import '../../../util/class_name_rest.dart';

const _defaultType = 'String';

/// {@template domain_sub_domain_add_value_object_command}
/// `rapid domain sub_domain add value_object` add a value object
/// to the domain part of a Rapid project.
/// {@endtemplate}
class DomainSubDomainAddValueObjectCommand extends RapidSubDomainLeafCommand
    with ClassNameGetter {
  /// {@macro domain_sub_domain_add_value_object_command}
  DomainSubDomainAddValueObjectCommand(
    super.project, {
    required super.subDomainName,
  }) {
    argParser
      ..addSeparator('')
      ..addOption(
        'type',
        help: 'The type that gets wrapped by this value object.\n'
            'Generics get escaped via "#" e.g Tuple<#A, #B, String>.',
        defaultsTo: _defaultType,
      );
  }

  @override
  String get name => 'value_object';

  @override
  List<String> get aliases => ['vo'];

  @override
  String get invocation =>
      'rapid domain $subDomainName add value_object <name> [arguments]';

  @override
  String get description =>
      'Add a value object to the subdomain $subDomainName.';

  @override
  Future<void> run() {
    final name = super.className;
    final subDomainName =
        this.subDomainName == 'default' ? null : this.subDomainName;
    final type = _type;
    final generics = _generics;

    return rapid.domainSubDomainAddValueObject(
      name: name,
      subDomainName: subDomainName,
      type: type,
      generics: generics,
    );
  }

  String get _type =>
      (argResults['type'] as String?)?.replaceAll('#', '') ?? _defaultType;

  String get _generics {
    final raw = argResults['type'] as String? ?? _defaultType;
    final buffer = StringBuffer();
    buffer.write('<');

    final generics = raw
        .replaceAll(' ', '')
        .split(RegExp('[,<>]'))
        .where((element) => element.startsWith('#'))
        .map((element) => element.replaceAll('#', ''))
        .toSet();

    for (var i = 0; i < generics.length; i++) {
      buffer.write(generics.elementAt(i));
      if (i != generics.length - 1) {
        buffer.write(', ');
      }
    }

    buffer.write('>');

    final string = buffer.toString();

    if (string == '<>') {
      return '';
    }

    return buffer.toString();
  }
}
