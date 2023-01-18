import 'package:args/command_runner.dart';
import 'package:mason/mason.dart';
import 'package:rapid_cli/src/commands/core/class_name_arg.dart';
import 'package:rapid_cli/src/commands/core/dir_option.dart';
import 'package:rapid_cli/src/commands/core/overridable_arg_results.dart';
import 'package:rapid_cli/src/commands/core/run_when.dart';
import 'package:rapid_cli/src/project/project.dart';

// TODO maybe introduce super class for entity, service interface and value object remove

/// {@template domain_remove_entity_command}
/// `rapid domain remove entity` command removes entity from the domain part of an existing Rapid project.
/// {@endtemplate}
class DomainRemoveEntityCommand extends Command<int>
    with OverridableArgResults, ClassNameGetter, DirGetter {
  /// {@macro domain_remove_entity_command}
  DomainRemoveEntityCommand({
    Logger? logger,
    required Project project,
  })  : _logger = logger ?? Logger(),
        _project = project {
    argParser
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
  String get invocation => 'rapid domain remove entity [arguments]';

  @override
  String get description =>
      'Remove an entity from the domain part of an existing Rapid project.';

  @override
  Future<int> run() => runWhen(
        [melosExists(_project)],
        _logger,
        () async {
          final name = super.className;
          final dir = super.dir;

          final domainPackage = _project.domainPackage;
          final entity = domainPackage.entity(name: name, dir: dir);

          final exists = entity.exists();
          if (exists) {
            final deletedFiles = entity.delete();

            for (final file in deletedFiles) {
              _logger.info(file.path);
            }

            _logger.info('');
            _logger.info('Deleted ${deletedFiles.length} item(s)');
            _logger.info('');
            _logger.success('Removed Entity $name.');

            return ExitCode.success.code;
          } else {
            _logger.err('Entity $name not found.');

            return ExitCode.config.code;
          }
        },
      );
}
