import 'package:mason/mason.dart';
import 'package:path/path.dart' as p;
import 'package:rapid_cli/src/cli/cli.dart';
import 'package:rapid_cli/src/commands/core/class_name_rest.dart';
import 'package:rapid_cli/src/commands/core/command.dart';
import 'package:rapid_cli/src/commands/core/output_dir_option.dart';
import 'package:rapid_cli/src/commands/core/run_when.dart';
import 'package:rapid_cli/src/commands/infrastructure/sub_infrastructure/core/service_option.dart';
import 'package:rapid_cli/src/commands/infrastructure/sub_infrastructure/core/sub_infrastructure_option.dart';
import 'package:rapid_cli/src/project/project.dart';

/// {@template infrastructure_sub_infrastructure_add_service_implementation_command}
/// `rapid infrastructure sub_infrastructure add service_implementation` command adds service_implementation to the infrastructure part of an existing Rapid project.
/// {@endtemplate}
class InfrastructureSubInfrastructureAddServiceImplementationCommand
    extends RapidRootCommand
    with
        ClassNameGetter,
        SubInfrastructureGetter,
        ServiceGetter,
        OutputDirGetter {
  /// {@macro infrastructure_sub_infrastructure_add_service_implementation_command}
  InfrastructureSubInfrastructureAddServiceImplementationCommand({
    Logger? logger,
    Project? project,
    DartFormatFixCommand? dartFormatFix,
  })  : _logger = logger ?? Logger(),
        _project = project ?? Project(),
        _dartFormatFix = dartFormatFix ?? Dart.formatFix {
    argParser
      ..addSeparator('')
      ..addSubInfrastructureOption(
        help:
            'The name of the subinfrastructure this new service implementation will be added to.\n'
            'This must be the name of an existing subinfrastructure.',
      )
      ..addSeparator('')
      ..addServiceOption()
      ..addOutputDirOption(
        help:
            'The output directory relative to <infrastructure_package>/lib/src .',
      );
  }

  final Logger _logger;
  final Project _project;
  final DartFormatFixCommand _dartFormatFix;

  @override
  String get name => 'service_implementation';

  @override
  List<String> get aliases => ['service', 'si'];

  @override
  String get invocation =>
      'rapid infrastructure sub_infrastructure add service_implementation <name> [arguments]';

  @override
  String get description =>
      'Add a service implementation to the infrastructure part of an existing Rapid project.';

  @override
  Future<int> run() => runWhen(
        [projectExistsAll(_project)],
        _logger,
        () async {
          final name = super.className;
          final infrastructureName = super.subInfrastructure;
          final serviceName = super.service;
          final outputDir = super.outputDir;

          _logger.info('Adding Service Implementation ...');

          final domainDirectory = _project.domainDirectory;
          final domainPackage =
              domainDirectory.domainPackage(name: infrastructureName);
          final serviceInterface =
              domainPackage.serviceInterface(name: serviceName, dir: outputDir);
          if (serviceInterface.existsAll()) {
            final infrastructureDirectory = _project.infrastructureDirectory;
            final infrastructurePackage = infrastructureDirectory
                .infrastructurePackage(name: infrastructureName);
            final serviceImplementation =
                infrastructurePackage.serviceImplementation(
              name: name,
              serviceName: serviceName,
              dir: outputDir,
            );

            if (!serviceImplementation.existsAny()) {
              await serviceImplementation.create();

              final barrelFile = infrastructurePackage.barrelFile;
              barrelFile.addExport(
                p.normalize(
                  p.join(
                    'src',
                    outputDir,
                    '${name.snakeCase}_${serviceName.snakeCase}_service.dart',
                  ),
                ),
              );

              await _dartFormatFix(
                cwd: infrastructurePackage.path,
                logger: _logger,
              );

              // Move component name to the component as a getter
              // TODO better hint containg related service etc
              _logger
                ..info('')
                ..success(
                  'Added Service Implementation $name${serviceName}Service.',
                );

              return ExitCode.success.code;
            } else {
              _logger
                ..info('')
                ..err(
                  'Service Implementation $name${serviceName}Service already exists.',
                );

              return ExitCode.config.code;
            }
          } else {
            _logger
              ..info('')
              ..err('Service Interface I${serviceName}Service does not exist.');

            return ExitCode.config.code;
          }
        },
      );
}
