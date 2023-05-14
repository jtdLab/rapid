import 'package:mason/mason.dart';
import 'package:path/path.dart' as p;
import 'package:rapid_cli/src/cli/cli.dart';
import 'package:rapid_cli/src/commands/core/class_name_rest.dart';
import 'package:rapid_cli/src/commands/core/command.dart';
import 'package:rapid_cli/src/commands/core/logger_x.dart';
import 'package:rapid_cli/src/commands/core/output_dir_option.dart';
import 'package:rapid_cli/src/commands/core/run_when.dart';
import 'package:rapid_cli/src/commands/domain/sub_domain/core/sub_domain_option.dart';

/// {@template domain_sub_domain_add_entity_command}
/// `rapid domain sub_domain add entity` command adds entity to the domain part of an existing Rapid project.
/// {@endtemplate}
class DomainSubDomainAddEntityCommand extends RapidRootCommand
    with ClassNameGetter, SubDomainGetter, OutputDirGetter {
  /// {@macro domain_sub_domain_add_entity_command}
  DomainSubDomainAddEntityCommand({
    super.logger,
    super.project,
    DartFormatFixCommand? dartFormatFix,
  }) : _dartFormatFix = dartFormatFix ?? Dart.formatFix {
    argParser
      ..addSeparator('')
      ..addSubDomainOption(
        help: 'The name of the subdomain this new entity will be added to.\n'
            'This must be the name of an existing subdomain.',
      )
      ..addSeparator('')
      ..addOutputDirOption(
        help: 'The output directory relative to <domain_package>/lib/ .',
      );
  }

  final DartFormatFixCommand _dartFormatFix;

  @override
  String get name => 'entity';

  @override
  String get invocation =>
      'rapid domain sub_domain add entity <name> [arguments]';

  @override
  String get description =>
      'Add an entity to the domain part of an existing Rapid project.';

  @override
  Future<int> run() => runWhen(
        [projectExistsAll(project)],
        logger,
        () async {
          final name = super.className;
          final domainName = super.subDomain;
          final outputDir = super.outputDir;

          logger.commandTitle(
            'Adding Entity "$name"${domainName != null ? ' to $domainName' : ''} ...',
          );

          final domainDirectory = project.domainDirectory;
          final domainPackage = domainDirectory.domainPackage(name: domainName);
          final entity = domainPackage.entity(name: name, dir: outputDir);
          if (!entity.existsAny()) {
            await entity.create();

            final barrelFile = domainPackage.barrelFile;
            barrelFile.addExport(
              p.normalize(
                p.join('src', outputDir, '${name.snakeCase}.dart'),
              ),
            );

            await _dartFormatFix(cwd: domainPackage.path, logger: logger);

            logger.commandSuccess();

            return ExitCode.success.code;
          } else {
            logger.commandError('Entity or ValueObject $name already exists.');

            return ExitCode.config.code;
          }
        },
      );
}
