import 'package:mason/mason.dart';
import 'package:path/path.dart' as p;
import 'package:rapid_cli/src/cli/cli.dart';
import 'package:rapid_cli/src/commands/core/class_name_rest.dart';
import 'package:rapid_cli/src/commands/core/command.dart';
import 'package:rapid_cli/src/commands/core/output_dir_option.dart';
import 'package:rapid_cli/src/commands/core/run_when.dart';
import 'package:rapid_cli/src/commands/domain/sub_domain/core/sub_domain_option.dart';
import 'package:rapid_cli/src/project/project.dart';

// TODO fix the template needs super class from rapid

/// The default type.
const _defaultType = 'String';

/// {@template domain_sub_domain_add_value_object_command}
/// `rapid domain sub_domain add value_object` command adds value object to the domain part of an existing Rapid project.
/// {@endtemplate}
class DomainSubDomainAddValueObjectCommand extends RapidRootCommand
    with
        ClassNameGetter,
        SubDomainGetter,
        OutputDirGetter,
        GroupableMixin,
        CodeGenMixin {
  /// {@macro domain_sub_domain_add_value_object_command}
  DomainSubDomainAddValueObjectCommand({
    Logger? logger,
    Project? project,
    FlutterPubGetCommand? flutterPubGet,
    FlutterPubRunBuildRunnerBuildDeleteConflictingOutputsCommand?
        flutterPubRunBuildRunnerBuildDeleteConflictingOutputs,
    DartFormatFixCommand? dartFormatFix,
  })  : _logger = logger ?? Logger(),
        _project = project ?? Project(),
        flutterPubGet = flutterPubGet ?? Flutter.pubGet,
        flutterPubRunBuildRunnerBuildDeleteConflictingOutputs =
            flutterPubRunBuildRunnerBuildDeleteConflictingOutputs ??
                Flutter.pubRunBuildRunnerBuildDeleteConflictingOutputs,
        _dartFormatFix = dartFormatFix ?? Dart.formatFix {
    argParser
      ..addSeparator('')
      ..addSubDomainOption(
        help:
            'The name of the subdomain this new value object will be added to.\n'
            'This must be the name of an existing subdomain.',
      )
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
  final FlutterPubGetCommand flutterPubGet;
  @override
  final FlutterPubRunBuildRunnerBuildDeleteConflictingOutputsCommand
      flutterPubRunBuildRunnerBuildDeleteConflictingOutputs;
  final DartFormatFixCommand _dartFormatFix;

  @override
  String get name => 'value_object';

  @override
  List<String> get aliases => ['vo'];

  @override
  String get invocation =>
      'rapid domain sub_domain add value_object <name> [arguments]';

  @override
  String get description =>
      'Add a value object to the domain part of an existing Rapid project.';

  @override
  Future<int> run() => runWhen(
        [projectExistsAll(_project)],
        _logger,
        () async {
          final name = super.className;
          final domainName = super.subDomain;
          final outputDir = super.outputDir;
          final type = _type;
          final generics = _generics;

          _logger.info('Adding Value Object ...');

          final domainDirectory = _project.domainDirectory;
          final domainPackage = domainDirectory.domainPackage(name: domainName);
          final valueObject = domainPackage.valueObject(
            name: name,
            dir: outputDir,
          );

          if (!valueObject.existsAny()) {
            await valueObject.create(type: type, generics: generics);

            final barrelFile = domainPackage.barrelFile;
            barrelFile.addExport(
              p.normalize(
                p.join('src', outputDir, '${name.snakeCase}.dart'),
              ),
            );

            await codeGen(packages: [domainPackage], logger: logger);
            await _dartFormatFix(cwd: domainPackage.path, logger: _logger);

            _logger
              ..info('')
              ..success('Added Value Object $name.');

            return ExitCode.success.code;
          } else {
            _logger
              ..info('')
              ..err('Entity or Value Object $name already exists.');

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
