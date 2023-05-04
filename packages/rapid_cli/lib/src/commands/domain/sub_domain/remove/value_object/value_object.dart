import 'package:mason/mason.dart';
import 'package:path/path.dart' as p;
import 'package:rapid_cli/src/commands/core/class_name_rest.dart';
import 'package:rapid_cli/src/commands/core/command.dart';
import 'package:rapid_cli/src/commands/core/dir_option.dart';
import 'package:rapid_cli/src/commands/core/run_when.dart';
import 'package:rapid_cli/src/commands/domain/sub_domain/core/sub_domain_option.dart';
import 'package:rapid_cli/src/project/project.dart';

/// {@template domain_sub_domain_remove_value_object_command}
/// `rapid domain sub_domain remove value_object` command removes value object from the domain part of an existing Rapid project.
/// {@endtemplate}
class DomainSubDomainRemoveValueObjectCommand extends RapidRootCommand
    with ClassNameGetter, SubDomainGetter, DirGetter {
  /// {@macro domain_sub_domain_remove_value_object_command}
  DomainSubDomainRemoveValueObjectCommand({
    Logger? logger,
    Project? project,
  })  : _logger = logger ?? Logger(),
        _project = project ?? Project() {
    argParser
      ..addSeparator('')
      ..addSubDomainOption(
        help:
            'The name of the subdomain this new value object will be added to.\n'
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
  String get name => 'value_object';

  @override
  List<String> get aliases => ['vo'];

  @override
  String get invocation =>
      'rapid domain sub_domain remove value_object <name> [arguments]';

  @override
  String get description =>
      'Remove a value object from the domain part of an existing Rapid project.';

  @override
  Future<int> run() => runWhen(
        [projectExistsAll(_project)],
        _logger,
        () async {
          final name = super.className;
          final domainName = super.subDomain;
          final dir = super.dir;

          _logger.info('Removing Value Object ...');

          final domainDirectory = _project.domainDirectory;
          final domainPackage = domainDirectory.domainPackage(name: domainName);
          final valueObject = domainPackage.valueObject(name: name, dir: dir);
          if (valueObject.existsAny()) {
            valueObject.delete();

            final barrelFile = domainPackage.barrelFile;
            barrelFile.removeExport(
              p.normalize(
                p.join('src', dir, '${name.snakeCase}.dart'),
              ),
            );

            _logger
              ..info('')
              ..success('Removed Value Object $name.');

            return ExitCode.success.code;
          } else {
            _logger
              ..info('')
              ..err('Value Object $name does not exist.');

            return ExitCode.config.code;
          }
        },
      );
}
