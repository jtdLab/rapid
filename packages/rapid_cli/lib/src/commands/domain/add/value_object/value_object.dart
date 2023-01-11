import 'package:args/command_runner.dart';
import 'package:mason/mason.dart';
import 'package:rapid_cli/src/commands/core/generator_builder.dart';
import 'package:rapid_cli/src/commands/core/overridable_arg_results.dart';
import 'package:rapid_cli/src/commands/core/run_when_cwd_has_melos.dart';
import 'package:rapid_cli/src/commands/core/validate_class_name.dart';
import 'package:rapid_cli/src/project/project.dart';
import 'package:recase/recase.dart';
import 'package:universal_io/io.dart';

import 'value_object_bundle.dart';

// TODO share code with other domain add commands

// TODO fix the template needs super class from rapid

/// The default output directory inside `<domain_package>/lib/`.
const _defaultOutputDir = '.';

/// {@template domain_add_value_object_command}
/// `rapid domain add value_object` command adds value object to the domain part of an existing Rapid project.
/// {@endtemplate}
class DomainAddValueObjectCommand extends Command<int>
    with OverridableArgResults {
  /// {@macro domain_add_value_object_command}
  DomainAddValueObjectCommand({
    Logger? logger,
    required Project project,
    GeneratorBuilder? generator,
  })  : _logger = logger ?? Logger(),
        _project = project,
        _generator = generator ?? MasonGenerator.fromBundle {
    argParser
      ..addSeparator('')
      ..addOption(
        'output-dir',
        help: 'The output directory inside domain packages lib directory.',
        defaultsTo: _defaultOutputDir,
      );
  }

  final Logger _logger;
  final Project _project;
  final GeneratorBuilder _generator;

  @override
  String get name => 'value_object';

  @override
  List<String> get aliases => ['vo'];

  @override
  String get invocation => 'rapid domain add value_object [arguments]';

  @override
  String get description =>
      'Adds a value object to the domain part of an existing Rapid project.';

  @override
  Future<int> run() => runWhenCwdHasMelos(_project, _logger, () async {
        final projectName = _project.melosFile.name();
        final domainPackage = _project.domainPackage;

        final name = _name;
        final outputDir = _outputDir;

        final generateProgress = _logger.progress('Generating files');
        final generator = await _generator(valueObjectBundle);
        final files = await generator.generate(
          DirectoryGeneratorTarget(Directory(domainPackage.path)),
          vars: <String, dynamic>{
            'project_name': projectName,
            'name': name,
            'output_dir': outputDir,
            'type': 'List<T>', // TODO
            'generics': '<T>', // TODO
          },
          logger: _logger,
        );
        generateProgress.complete('Generated ${files.length} file(s)');

        _logger.success(
          'Added Value Object ${name.pascalCase}.',
        );

        return ExitCode.success.code;
      });

  /// Gets the name of the value object.
  String get _name => _validateNameArg(argResults.rest);

  /// The output directory inside domain packages lib directory.
  String get _outputDir => argResults['output-dir'] ?? _defaultOutputDir;

  /// Validates whether args is a valid value object name.
  ///
  /// Returns the name when valid.
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
    final isValid = isValidClassName(name);
    if (!isValid) {
      throw UsageException(
        '"$name" is not a valid dart class name.',
        usage,
      );
    }

    return name;
  }
}
