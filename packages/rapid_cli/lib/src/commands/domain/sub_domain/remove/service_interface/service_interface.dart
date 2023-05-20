import 'package:mason/mason.dart';
import 'package:path/path.dart' as p;
import 'package:rapid_cli/src/commands/core/class_name_rest.dart';
import 'package:rapid_cli/src/commands/core/command.dart';
import 'package:rapid_cli/src/commands/core/dir_option.dart';
import 'package:rapid_cli/src/commands/core/logger_x.dart';
import 'package:rapid_cli/src/commands/core/run_when.dart';
import 'package:rapid_cli/src/project/domain_directory/domain_package/domain_package.dart';

/// {@template domain_sub_domain_remove_service_interface_command}
/// `rapid domain sub_domain remove service_interface` command removes service interface from the domain part of an existing Rapid project.
/// {@endtemplate}
class DomainSubDomainRemoveServiceInterfaceCommand extends RapidRootCommand
    with ClassNameGetter, DirGetter {
  /// {@macro domain_sub_domain_remove_service_interface_command}
  DomainSubDomainRemoveServiceInterfaceCommand({
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
  String get name => 'service_interface';

  @override
  List<String> get aliases => ['service', 'si'];

  @override
  String get invocation =>
      'rapid domain ${_domainPackage.name ?? 'default'} remove service_interface <name> [arguments]';

  @override
  String get description =>
      'Remove a service interface from the subdomain ${_domainPackage.name ?? 'default'}.';

  @override
  Future<int> run() => runWhen(
        [projectExistsAll(project)],
        logger,
        () async {
          final name = super.className;
          final domainName = _domainPackage.name ?? 'default';
          final dir = super.dir;

          logger.commandTitle(
            'Removing Service Interface "$name" from $domainName ...',
          );

          final serviceInterface =
              _domainPackage.serviceInterface(name: name, dir: dir);
          if (serviceInterface.existsAny()) {
            serviceInterface.delete();

            final barrelFile = _domainPackage.barrelFile;
            barrelFile.removeExport(
              p.normalize(
                p.join('src', dir, 'i_${name.snakeCase}_service.dart'),
              ),
            );

            logger.commandSuccess();

            return ExitCode.success.code;
          } else {
            logger.commandError(
              'Service Interface I${name}Service does not exist.',
            );

            return ExitCode.config.code;
          }
        },
      );
}
