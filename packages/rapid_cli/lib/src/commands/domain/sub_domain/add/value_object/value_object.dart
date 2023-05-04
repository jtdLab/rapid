import 'package:mason/mason.dart';
import 'package:path/path.dart' as p;
import 'package:rapid_cli/src/cli/cli.dart';
import 'package:rapid_cli/src/commands/core/class_name_rest.dart';
import 'package:rapid_cli/src/commands/core/command.dart';
import 'package:rapid_cli/src/commands/core/output_dir_option.dart';
import 'package:rapid_cli/src/commands/core/run_when.dart';
import 'package:rapid_cli/src/commands/domain/sub_domain/core/sub_domain_option.dart';

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
    super.logger,
    super.project,
    FlutterPubGetCommand? flutterPubGet,
    FlutterPubRunBuildRunnerBuildDeleteConflictingOutputsCommand?
        flutterPubRunBuildRunnerBuildDeleteConflictingOutputs,
    DartFormatFixCommand? dartFormatFix,
  })  : flutterPubGet = flutterPubGet ?? Flutter.pubGet,
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
        [projectExistsAll(project)],
        logger,
        () async {
          final name = super.className;
          final domainName = super.subDomain;
          final outputDir = super.outputDir;
          final type = _type;
          final generics = _generics;

          logger.info('Adding Value Object ...');

          final domainDirectory = project.domainDirectory;
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
            await _dartFormatFix(cwd: domainPackage.path, logger: logger);

            logger
              ..info('')
              ..success('Added Value Object $name.');

            return ExitCode.success.code;
          } else {
            logger
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
