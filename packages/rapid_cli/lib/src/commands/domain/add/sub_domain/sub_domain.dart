import 'package:args/command_runner.dart';
import 'package:mason/mason.dart';
import 'package:rapid_cli/src/commands/core/overridable_arg_results.dart';
import 'package:rapid_cli/src/commands/core/run_when.dart';
import 'package:rapid_cli/src/commands/core/validate_dart_package_name.dart';
import 'package:rapid_cli/src/project/project.dart';

/// {@template domain_add_sub_domain_command}
/// `rapid domain add sub_domain` command add subdomains to the domain part of an existing Rapid project.
/// {@endtemplate}
class DomainAddSubDomainCommand extends Command<int>
    with OverridableArgResults {
  /// {@macro domain_add_sub_domain_command}
  DomainAddSubDomainCommand({
    Logger? logger,
    required Project project,
  })  : _logger = logger ?? Logger(),
        _project = project;

  final Logger _logger;
  final Project _project;

  @override
  String get name => 'add';

  @override
  String get invocation => 'rapid domain add sub_domain <name>';

  @override
  String get description =>
      'Remove subdomains of the domain part of an existing Rapid project.';

  @override
  Future<int> run() => runWhen(
        [projectExistsAll(_project)],
        _logger,
        () async {
          final name = _name;

          _logger.info('Adding Sub domain package ...');

          try {
            await _project.addSubDomain(
              name: name,
              logger: _logger,
            );

            _logger
              ..info('')
              ..success('Added sub domain $name.');

            return ExitCode.success.code;
          } on SubDomainAlreadyExists {
            _logger
              ..info('')
              ..err('The subdomain "$name" already exists.');

            return ExitCode.config.code;
          }
        },
      );

  String get _name => _validateNameArg(argResults.rest);

  /// Validates whether [name] is valid feature name.
  ///
  /// Returns [name] when valid.
  String _validateNameArg(List<String> args) {
    if (args.isEmpty) {
      throw UsageException(
        'No option specified for the name.',
        usage,
      );
    }

    if (args.length > 1) {
      throw UsageException('Multiple names specified.', usage);
    }

    final name = args.first;
    final isValid = isValidPackageName(name);
    if (!isValid) {
      throw UsageException(
        '"$name" is not a valid package name.\n\n'
        'See https://dart.dev/tools/pub/pubspec#name for more information.',
        usage,
      );
    }

    return name;
  }
}
