import 'package:mason/mason.dart';
import 'package:path/path.dart' as p;
import 'package:rapid_cli/src/commands/core/class_name_rest.dart';
import 'package:rapid_cli/src/commands/core/command.dart';
import 'package:rapid_cli/src/commands/core/dir_option.dart';
import 'package:rapid_cli/src/commands/core/run_when.dart';
import 'package:rapid_cli/src/commands/domain/sub_domain/core/sub_domain_option.dart';

/// {@template domain_sub_domain_remove_service_interface_command}
/// `rapid domain sub_domain remove service_interface` command removes service interface from the domain part of an existing Rapid project.
/// {@endtemplate}
class DomainSubDomainRemoveServiceInterfaceCommand extends RapidRootCommand
    with ClassNameGetter, SubDomainGetter, DirGetter {
  /// {@macro domain_sub_domain_remove_service_interface_command}
  DomainSubDomainRemoveServiceInterfaceCommand({
    super.logger,
    super.project,
  }) {
    argParser
      ..addSeparator('')
      ..addSubDomainOption(
        help:
            'The name of the subdomain this new service interface will be added to.\n'
            'This must be the name of an existing subdomain.',
      )
      ..addSeparator('')
      ..addDirOption(
        help: 'The directory relative to <domain_package>/lib/ .',
      );
  }

  @override
  String get name => 'service_interface';

  @override
  List<String> get aliases => ['service', 'si'];

  @override
  String get invocation =>
      'rapid domain sub_domain remove service_interface <name> [arguments]';

  @override
  String get description =>
      'Remove a service interface from the domain part of an existing Rapid project.';

  @override
  Future<int> run() => runWhen(
        [projectExistsAll(project)],
        logger,
        () async {
          final name = super.className;
          final domainName = super.subDomain;
          final dir = super.dir;

          logger.info('Removing Service Interface ...');

          final domainDirectory = project.domainDirectory;
          final domainPackage = domainDirectory.domainPackage(name: domainName);
          final serviceInterface =
              domainPackage.serviceInterface(name: name, dir: dir);
          if (serviceInterface.existsAny()) {
            serviceInterface.delete();

            final barrelFile = domainPackage.barrelFile;
            barrelFile.removeExport(
              p.normalize(
                p.join('src', dir, 'i_${name.snakeCase}_service.dart'),
              ),
            );

            logger
              ..info('')
              ..success('Removed Service Interface I${name}Service.');

            return ExitCode.success.code;
          } else {
            logger
              ..info('')
              ..err('Service Interface I${name}Service does not exist.');

            return ExitCode.config.code;
          }
        },
      );
}
