import 'package:args/command_runner.dart';
import 'package:mason/mason.dart';
import 'package:rapid_cli/src/commands/core/class_name_arg.dart';
import 'package:rapid_cli/src/commands/core/output_dir_option.dart';
import 'package:rapid_cli/src/commands/core/overridable_arg_results.dart';
import 'package:rapid_cli/src/commands/core/run_when.dart';
import 'package:rapid_cli/src/project/project.dart';

// TODO fix the template needs super class from rapid

/// The default type.
const _defaultType = 'String';

/// {@template domain_add_value_object_command}
/// `rapid domain add value_object` command adds value object to the domain part of an existing Rapid project.
/// {@endtemplate}
class DomainAddValueObjectCommand extends Command<int>
    with OverridableArgResults, ClassNameGetter, OutputDirGetter {
  /// {@macro domain_add_value_object_command}
  DomainAddValueObjectCommand({
    Logger? logger,
    required Project project,
  })  : _logger = logger ?? Logger(),
        _project = project {
    argParser
      ..addSeparator('')
      ..addOutputDirOption(
        help: 'The output directory relative to <domain_package>/lib/ .',
      )
      ..addOption(
        'type',
        help: 'The type that gets wrapped by this value object.\n'
            'Generics get escaped via "#" e.g Tuple<#A, #B, String>.',
        defaultsTo: _defaultType,
      );
  }

  final Logger _logger;
  final Project _project;

  @override
  String get name => 'value_object';

  @override
  List<String> get aliases => ['vo'];

  @override
  String get invocation => 'rapid domain add value_object <name> [arguments]';

  @override
  String get description =>
      'Add a value object to the domain part of an existing Rapid project.';

  @override
  Future<int> run() => runWhen(
        [projectExistsAll(_project)],
        _logger,
        () async {
          final name = super.className;
          final outputDir = super.outputDir;
          final type = _type;
          final generics = _generics;

          _logger.info('Adding Value Object ...');

          try {
            await _project.addValueObject(
              name: name,
              outputDir: outputDir,
              type: type,
              generics: generics,
              logger: _logger,
            );

            _logger
              ..info('')
              ..success('Added Value Object ${name.pascalCase}.');

            return ExitCode.success.code;
          } on ValueObjectAlreadyExists {
            _logger
              ..info('')
              ..err('Value Object $name already exists.');

            return ExitCode.config.code;
          }
        },
      );

  String get _type => argResults['type']?.replaceAll('#', '') ?? _defaultType;

  String get _generics {
    final raw = argResults['type'] as String? ?? _defaultType;
    StringBuffer buffer = StringBuffer();
    buffer.write('<');

    final generics = raw
        .replaceAll(' ', '')
        .split(RegExp('[,<>]'))
        .where((element) => element.startsWith('#'))
        .map((element) => element.replaceAll('#', ''))
        .toSet();

    for (int i = 0; i < generics.length; i++) {
      buffer.write(generics.elementAt(i));
      if (i != generics.length - 1) {
        buffer.write(', ');
      }
    }

    buffer.write('>');

    final string = buffer.toString();

    if (string == '<>') {
      return '';
    }

    return buffer.toString();
  }
}
