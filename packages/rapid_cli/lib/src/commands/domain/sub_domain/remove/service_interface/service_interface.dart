import 'package:args/command_runner.dart';
import 'package:mason/mason.dart';
import 'package:rapid_cli/src/commands/core/class_name_rest.dart';
import 'package:rapid_cli/src/commands/core/dir_option.dart';
import 'package:rapid_cli/src/commands/core/overridable_arg_results.dart';
import 'package:rapid_cli/src/commands/core/run_when.dart';
import 'package:rapid_cli/src/commands/domain/sub_domain/core/sub_domain_option.dart';
import 'package:rapid_cli/src/project/project.dart';

/// {@template domain_sub_domain_remove_service_interface_command}
/// `rapid domain sub_domain remove service_interface` command removes service interface from the domain part of an existing Rapid project.
/// {@endtemplate}
class DomainSubDomainRemoveServiceInterfaceCommand extends Command<int>
    with OverridableArgResults, ClassNameGetter, SubDomainGetter, DirGetter {
  /// {@macro domain_sub_domain_remove_service_interface_command}
  DomainSubDomainRemoveServiceInterfaceCommand({
    Logger? logger,
    Project? project,
  })  : _logger = logger ?? Logger(),
        _project = project ?? Project() {
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

  final Logger _logger;
  final Project _project;

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
        [projectExistsAll(_project)],
        _logger,
        () async {
          final name = super.className;
          final domainName = super.subDomain;
          final dir = super.dir;

          _logger.info('Removing Service Interface ...');

          final domainDirectory = _project.domainDirectory;
          final domainPackage = domainDirectory.domainPackage(name: domainName);
          final serviceInterface =
              domainPackage.serviceInterface(name: name, dir: dir);
          if (serviceInterface.existsAny()) {
            serviceInterface.delete();

            _logger
              ..info('')
              ..success('Removed Service Interface I${name}Service.');

            return ExitCode.success.code;
          } else {
            _logger
              ..info('')
              ..err('Service Interface I${name}Service does not exist.');

            return ExitCode.config.code;
          }
        },
      );
}
