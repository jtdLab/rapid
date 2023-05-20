import 'package:mason/mason.dart';
import 'package:path/path.dart' as p;
import 'package:rapid_cli/src/commands/core/class_name_rest.dart';
import 'package:rapid_cli/src/commands/core/command.dart';
import 'package:rapid_cli/src/commands/core/dir_option.dart';
import 'package:rapid_cli/src/commands/core/logger_x.dart';
import 'package:rapid_cli/src/commands/core/run_when.dart';
import 'package:rapid_cli/src/project/domain_directory/domain_package/domain_package.dart';

// TODO maybe introduce super class for entity, service interface and value object remove

/// {@template domain_sub_domain_remove_entity_command}
/// `rapid domain sub_domain remove entity` command removes entity from the domain part of an existing Rapid project.
/// {@endtemplate}
class DomainSubDomainRemoveEntityCommand extends RapidRootCommand
    with ClassNameGetter, DirGetter {
  /// {@macro domain_sub_domain_remove_entity_command}
  DomainSubDomainRemoveEntityCommand({
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
  String get name => 'entity';

  @override
  String get invocation =>
      'rapid domain ${_domainPackage.name ?? 'default'} remove entity <name> [arguments]';

  @override
  String get description =>
      'Remove an entity from the subdomain ${_domainPackage.name ?? 'default'}.';

  @override
  Future<int> run() => runWhen(
        [projectExistsAll(project)],
        logger,
        () async {
          final name = super.className;
          final domainName = _domainPackage.name ?? 'default';
          final dir = super.dir;

          logger.commandTitle(
            'Removing Entity "$name" from $domainName ...',
          );

          final entity = _domainPackage.entity(name: name, dir: dir);
          // TODO this does delete a value_object because they have same files
          if (entity.existsAny()) {
            entity.delete();

            final barrelFile = _domainPackage.barrelFile;
            barrelFile.removeExport(
              p.normalize(
                p.join('src', dir, '${name.snakeCase}.dart'),
              ),
            );

            logger.commandSuccess();

            return ExitCode.success.code;
          } else {
            logger.commandError('Entity $name does not exist.');

            return ExitCode.config.code;
          }
        },
      );
}
