import 'package:args/command_runner.dart';
import 'package:mason/mason.dart';
import 'package:rapid_cli/src/cli/cli.dart';
import 'package:rapid_cli/src/commands/core/generator_builder.dart';
import 'package:rapid_cli/src/commands/core/overridable_arg_results.dart';
import 'package:rapid_cli/src/commands/core/platform/add/feature/feature_bundle.dart';
import 'package:rapid_cli/src/commands/core/run_when_cwd_has_melos.dart';
import 'package:rapid_cli/src/commands/core/validate_dart_package_name.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/project/project.dart';
import 'package:universal_io/io.dart';

/// The default description.
const _defaultDescription = 'A Rapid feature.';

/// {@template platform_add_feature_command}
/// Base class for TODO
/// {@endtemplate}
abstract class PlatformAddFeatureCommand extends Command<int>
    with OverridableArgResults {
  /// {@macro platform_add_feature_command}
  PlatformAddFeatureCommand({
    required Platform platform,
    Logger? logger,
    required Project project,
    GeneratorBuilder? generator,
    MelosBootstrapCommand? melosBootstrap,
    MelosCleanCommand? melosClean,
  })  : _platform = platform,
        _logger = logger ?? Logger(),
        _project = project,
        _generator = generator ?? MasonGenerator.fromBundle,
        _melosBootstrap = Melos.bootstrap,
        _melosClean = Melos.clean {
    argParser
      ..addSeparator('')
      ..addOption(
        'desc',
        help: 'The description of this new feature.',
        defaultsTo: _defaultDescription,
      );
  }

  final GeneratorBuilder _generator;
  final Logger _logger;
  final MelosBootstrapCommand _melosBootstrap;
  final MelosCleanCommand _melosClean;
  final Platform _platform;
  final Project _project;

  @override
  String get name => 'feature';

  @override
  List<String> get aliases => ['feat'];

  @override
  String get invocation => 'rapid android add feature <name> [arguments]';

  @override
  String get description =>
      'Adds a feature to the ${_platform.prettyName} part of an existing Rapid project.';

  @override
  Future<int> run() => runWhenCwdHasMelos(_project, _logger, () async {
        // TODO add a application layer to the feature template

        final platformIsActivated = _project.isActivated(_platform);

        if (platformIsActivated) {
          final projectName = _project.melosFile.name();
          final name = _name;
          final description = _description;

          // TODO check if feature exists

          final generateProgress = _logger.progress('Generating files');
          final generator = await _generator(featureBundle);
          final files = await generator.generate(
            DirectoryGeneratorTarget(Directory('.')),
            vars: <String, dynamic>{
              'project_name': projectName,
              'name': name,
              'description': description,
              'platform': _platform.name,
              _platform.name: true
            },
            logger: _logger,
          );
          generateProgress.complete('Generated ${files.length} file(s)');

          // TODO HIGH PRIO add the localizations delegate of this feature to the app feature

          final melosCleanProgress = _logger.progress(
            'Running "melos clean" in . ',
          );
          await _melosClean();
          melosCleanProgress.complete();
          final melosBootstrapProgress = _logger.progress(
            'Running "melos bootstrap" in . ',
          );
          await _melosBootstrap();
          melosBootstrapProgress.complete();

          _logger.success(
            'Added ${_platform.prettyName} feature $name.',
          );

          // TODO maybe add hint how to register a page in the routing feature

          return ExitCode.success.code;
        } else {
          _logger.err('${_platform.prettyName} is not activated.');

          return ExitCode.config.code;
        }
      });

  String get _name => _validateNameArg(argResults.rest);

  /// Gets the description for the project specified by the user.
  String get _description => argResults['desc'] ?? _defaultDescription;

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
