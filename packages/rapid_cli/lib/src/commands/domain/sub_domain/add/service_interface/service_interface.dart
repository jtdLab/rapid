import 'package:args/command_runner.dart';
import 'package:mason/mason.dart';
import 'package:rapid_cli/src/cli/cli.dart';
import 'package:rapid_cli/src/commands/core/class_name_rest.dart';
import 'package:rapid_cli/src/commands/core/output_dir_option.dart';
import 'package:rapid_cli/src/commands/core/overridable_arg_results.dart';
import 'package:rapid_cli/src/commands/core/run_when.dart';
import 'package:rapid_cli/src/commands/domain/sub_domain/core/sub_domain_option.dart';
import 'package:rapid_cli/src/project/project.dart';

/// {@template domain_sub_domain_add_service_interface_command}
/// `rapid domain sub_domain add service_interface` command adds service_interface to the domain part of an existing Rapid project.
/// {@endtemplate}
class DomainSubDomainAddServiceInterfaceCommand extends Command<int>
    with
        OverridableArgResults,
        ClassNameGetter,
        SubDomainGetter,
        OutputDirGetter {
  /// {@macro domain_sub_domain_add_service_interface_command}
  DomainSubDomainAddServiceInterfaceCommand({
    Logger? logger,
    Project? project,
    DartFormatFixCommand? dartFormatFix,
  })  : _logger = logger ?? Logger(),
        _project = project ?? Project(),
        _dartFormatFix = dartFormatFix ?? Dart.formatFix {
    argParser
      ..addSeparator('')
      ..addSubDomainOption(
        help:
            'The name of the subdomain this new service interface will be added to.\n'
            'This must be the name of an existing subdomain.',
      )
      ..addSeparator('')
      ..addOutputDirOption(
        help: 'The output directory relative to <domain_package>/lib/ .',
      );
  }

  final Logger _logger;
  final Project _project;
  final DartFormatFixCommand _dartFormatFix;

  @override
  String get name => 'service_interface';

  @override
  List<String> get aliases => ['service', 'si'];

  @override
  String get invocation =>
      'rapid domain sub_domain add service_interface <name> [arguments]';

  @override
  String get description =>
      'Add a service interface to the domain part of an existing Rapid project.';

  @override
  Future<int> run() => runWhen(
        [projectExistsAll(_project)],
        _logger,
        () async {
          final name = super.className;
          final domainName = super.subDomain;
          final outputDir = super.outputDir;

          _logger.info('Adding Service Interface ...');

          final domainDirectory = _project.domainDirectory;
          final domainPackage = domainDirectory.domainPackage(name: domainName);
          final serviceInterface =
              domainPackage.serviceInterface(name: name, dir: outputDir);
          if (!serviceInterface.existsAny()) {
            await serviceInterface.create();

            await _dartFormatFix(cwd: domainPackage.path, logger: _logger);

            _logger
              ..info('')
              ..success('Added Service Interface I${name}Service.');

            return ExitCode.success.code;
          } else {
            // TODO only name is not enough
            _logger
              ..info('')
              ..err('Service Interface I${name}Service already exists.');

            return ExitCode.config.code;
          }
        },
      );
}
