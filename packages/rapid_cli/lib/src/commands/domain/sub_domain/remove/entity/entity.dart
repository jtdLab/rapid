import 'package:mason/mason.dart';
import 'package:path/path.dart' as p;
import 'package:rapid_cli/src/commands/core/class_name_rest.dart';
import 'package:rapid_cli/src/commands/core/command.dart';
import 'package:rapid_cli/src/commands/core/dir_option.dart';
import 'package:rapid_cli/src/commands/core/run_when.dart';
import 'package:rapid_cli/src/commands/domain/sub_domain/core/sub_domain_option.dart';
import 'package:rapid_cli/src/project/project.dart';

// TODO maybe introduce super class for entity, service interface and value object remove

/// {@template domain_sub_domain_remove_entity_command}
/// `rapid domain sub_domain remove entity` command removes entity from the domain part of an existing Rapid project.
/// {@endtemplate}
class DomainSubDomainRemoveEntityCommand extends RapidRootCommand
    with ClassNameGetter, SubDomainGetter, DirGetter {
  /// {@macro domain_sub_domain_remove_entity_command}
  DomainSubDomainRemoveEntityCommand({
    Logger? logger,
    Project? project,
  })  : _logger = logger ?? Logger(),
        _project = project ?? Project() {
    argParser
      ..addSeparator('')
      ..addSubDomainOption(
        help: 'The name of the subdomain this entity will be removed from.\n'
            'This must be the name of an existing subdomain.',
      )
      ..addSeparator('')
      ..addDirOption(
        help: 'The directory relative to <domain_package>/lib/ .',
      );
  }

  final Logger _logger;
  final Project _project;

  @override
  String get name => 'entity';

  @override
  String get invocation =>
      'rapid domain sub_domain remove entity <name> [arguments]';

  @override
  String get description =>
      'Remove an entity from the domain part of an existing Rapid project.';

  @override
  Future<int> run() => runWhen(
        [projectExistsAll(_project)],
        _logger,
        () async {
          final name = super.className;
          final domainName = super.subDomain;
          final dir = super.dir;

          _logger.info('Removing Entity ...');

          final domainDirectory = _project.domainDirectory;
          final domainPackage = domainDirectory.domainPackage(name: domainName);
          final entity = domainPackage.entity(name: name, dir: dir);
          if (entity.existsAny()) {
            entity.delete();

            final barrelFile = domainPackage.barrelFile;
            barrelFile.removeExport(
              p.normalize(
                p.join('src', dir, '${name.snakeCase}.dart'),
              ),
            );

            _logger
              ..info('')
              ..success('Removed Entity $name.');

            return ExitCode.success.code;
          } else {
            _logger
              ..info('')
              ..err('Entity $name does not exist.');

            return ExitCode.config.code;
          }
        },
      );
}
