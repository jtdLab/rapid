import 'package:mason/mason.dart';
import 'package:path/path.dart' as p;
import 'package:rapid_cli/src/cli/cli.dart';
import 'package:rapid_cli/src/commands/core/class_name_rest.dart';
import 'package:rapid_cli/src/commands/core/command.dart';
import 'package:rapid_cli/src/commands/core/logger_x.dart';
import 'package:rapid_cli/src/commands/core/output_dir_option.dart';
import 'package:rapid_cli/src/commands/core/run_when.dart';
import 'package:rapid_cli/src/project/domain_directory/domain_package/domain_package.dart';

/// {@template domain_sub_domain_add_service_interface_command}
/// `rapid domain sub_domain add service_interface` command adds service_interface to the domain part of an existing Rapid project.
/// {@endtemplate}
class DomainSubDomainAddServiceInterfaceCommand extends RapidRootCommand
    with ClassNameGetter, OutputDirGetter {
  /// {@macro domain_sub_domain_add_service_interface_command}
  DomainSubDomainAddServiceInterfaceCommand({
    super.logger,
    required DomainPackage domainPackage,
    super.project,
    DartFormatFixCommand? dartFormatFix,
  })  : _domainPackage = domainPackage,
        _dartFormatFix = dartFormatFix ?? Dart.formatFix {
    argParser
      ..addSeparator('')
      ..addOutputDirOption(
        help: 'The output directory relative to <domain_package>/lib/ .',
      );
  }

  final DomainPackage _domainPackage;

  final DartFormatFixCommand _dartFormatFix;

  @override
  String get name => 'service_interface';

  @override
  List<String> get aliases => ['service', 'si'];

  @override
  String get invocation =>
      'rapid domain  ${_domainPackage.name ?? 'default'} add service_interface <name> [arguments]';

  @override
  String get description =>
      'Add a service interface to the subdomain ${_domainPackage.name ?? 'default'}.';

  @override
  Future<int> run() => runWhen(
        [projectExistsAll(project)],
        logger,
        () async {
          final name = super.className;
          final domainName = _domainPackage.name ?? 'default';
          final outputDir = super.outputDir;

          logger.commandTitle(
            'Adding Service Interface "$name" to $domainName ...',
          );

          final serviceInterface =
              _domainPackage.serviceInterface(name: name, dir: outputDir);
          if (!serviceInterface.existsAny()) {
            await serviceInterface.create();

            final barrelFile = _domainPackage.barrelFile;
            barrelFile.addExport(
              p.normalize(
                p.join('src', outputDir, 'i_${name.snakeCase}_service.dart'),
              ),
            );

            await _dartFormatFix(cwd: _domainPackage.path, logger: logger);

            logger.commandSuccess();

            return ExitCode.success.code;
          } else {
            // TODO only name is not enough
            logger.commandError(
              'Service Interface I${name}Service already exists.',
            );

            return ExitCode.config.code;
          }
        },
      );
}
