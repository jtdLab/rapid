import 'package:mason/mason.dart';
import 'package:path/path.dart' as p;
import 'package:rapid_cli/src/commands/core/class_name_rest.dart';
import 'package:rapid_cli/src/commands/core/command.dart';
import 'package:rapid_cli/src/commands/core/dir_option.dart';
import 'package:rapid_cli/src/commands/core/logger_x.dart';
import 'package:rapid_cli/src/commands/core/run_when.dart';
import 'package:rapid_cli/src/project/domain_directory/domain_package/domain_package.dart';

/// {@template domain_sub_domain_remove_value_object_command}
/// `rapid domain sub_domain remove value_object` command removes value object from the domain part of an existing Rapid project.
/// {@endtemplate}
class DomainSubDomainRemoveValueObjectCommand extends RapidRootCommand
    with ClassNameGetter, DirGetter {
  /// {@macro domain_sub_domain_remove_value_object_command}
  DomainSubDomainRemoveValueObjectCommand({
    super.logger,
    required DomainPackage domainPackage,
    super.project,
  }) : _domainPackage = domainPackage {
    argParser
      ..addSeparator('')
      ..addDirOption(
        help: 'The directory relative to <domain_package>/lib/ .',
      );
  }

  final DomainPackage _domainPackage;

  @override
  String get name => 'value_object';

  @override
  List<String> get aliases => ['vo'];

  @override
  String get invocation =>
      'rapid domain ${_domainPackage.name ?? 'default'} remove value_object <name> [arguments]';

  @override
  String get description =>
      'Remove a value object from the subdomain ${_domainPackage.name ?? 'default'}.';

  @override
  Future<int> run() => runWhen(
        [projectExistsAll(project)],
        logger,
        () async {
          final name = super.className;
          final domainName = _domainPackage.name ?? 'default';
          final dir = super.dir;

          logger.commandTitle(
            'Removing Value Object "$name" from $domainName ...',
          );

          final valueObject = _domainPackage.valueObject(name: name, dir: dir);
          if (valueObject.existsAny()) {
            valueObject.delete();

            final barrelFile = _domainPackage.barrelFile;
            barrelFile.removeExport(
              p.normalize(
                p.join('src', dir, '${name.snakeCase}.dart'),
              ),
            );

            logger.commandSuccess();

            return ExitCode.success.code;
          } else {
            logger.commandError('Value Object $name does not exist.');

            return ExitCode.config.code;
          }
        },
      );
}
