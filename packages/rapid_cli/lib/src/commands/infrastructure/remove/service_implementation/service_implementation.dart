import 'package:args/command_runner.dart';
import 'package:mason/mason.dart';
import 'package:rapid_cli/src/commands/core/class_name_arg.dart';
import 'package:rapid_cli/src/commands/core/dir_option.dart';
import 'package:rapid_cli/src/commands/core/overridable_arg_results.dart';
import 'package:rapid_cli/src/commands/core/run_when.dart';
import 'package:rapid_cli/src/commands/core/validate_class_name.dart';
import 'package:rapid_cli/src/project/project.dart';

/// {@template infrastructure_remove_service_implementation_command}
/// `rapid infrastructure remove service_implementation` command removes service implementation from the infrastructure part of an existing Rapid project.
/// {@endtemplate}
class InfrastructureRemoveServiceImplementationCommand extends Command<int>
    with OverridableArgResults, ClassNameGetter, DirGetter {
  /// {@macro infrastructure_remove_service_implementation_command}
  InfrastructureRemoveServiceImplementationCommand({
    Logger? logger,
    required Project project,
  })  : _logger = logger ?? Logger(),
        _project = project {
    argParser
      ..addSeparator('')
      ..addOption(
        'service',
        help:
            'The name of the service interface the service implementation is related to.',
        abbr: 's',
      )
      ..addDirOption(
        help: 'The directory relative to <infrastructure_package>/lib/ .',
      );
  }

  final Logger _logger;
  final Project _project;

  @override
  String get name => 'service_implementation';

  @override
  List<String> get aliases => ['service', 'si'];

  @override
  String get invocation =>
      'rapid infrastructure remove service_implementation <name> [arguments]';

  @override
  String get description =>
      'Remove a service implementation from the infrastructure part of an existing Rapid project.';

  @override
  Future<int> run() => runWhen(
        [projectExistsAll(_project)],
        _logger,
        () async {
          final name = super.className;
          final service = _service;
          final dir = super.dir;

          _logger.info('Removing Service Implementation ...');

          try {
            await _project.removeServiceImplementation(
              name: name,
              serviceName: service,
              dir: dir,
              logger: _logger,
            );

            _logger
              ..info('')
              ..success(
                'Removed Service Implementation ${name.pascalCase}${service.pascalCase}Service.',
              );

            return ExitCode.success.code;
          } on ServiceImplementationDoesNotExist {
            _logger
              ..info('')
              ..err(
                'Service Implementation ${name.pascalCase}${service.pascalCase}Service not found.',
              );

            return ExitCode.config.code;
          }
        },
      );

  /// Gets the name of the service interface this service implementation is related to.
  String get _service => _validateServiceArg(argResults['service']);

  /// Validates whether `service` is a valid service name.
  ///
  /// Returns `service` when valid.
  String _validateServiceArg(String? service) {
    if (service == null) {
      throw UsageException(
        'No option specified for the service.',
        usage,
      );
    }

    final isValid = isValidClassName(service);
    if (!isValid) {
      throw UsageException(
        '"$service" is not a valid dart class name.',
        usage,
      );
    }

    return service;
  }
}
