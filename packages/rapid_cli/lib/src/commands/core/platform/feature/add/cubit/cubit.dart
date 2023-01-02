import 'package:args/command_runner.dart';
import 'package:mason/mason.dart';
import 'package:rapid_cli/src/cli/cli.dart';
import 'package:rapid_cli/src/commands/core/generator_builder.dart';
import 'package:rapid_cli/src/commands/core/overridable_arg_results.dart';
import 'package:rapid_cli/src/commands/core/run_when_cwd_has_melos.dart';
import 'package:rapid_cli/src/core/dart_package.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/project/project.dart';
import 'package:recase/recase.dart';
import 'package:universal_io/io.dart';

import 'cubit_bundle.dart';

/// {@template platform_feature_add_cubit_command}
/// Base class for TODO
/// {@endtemplate}
abstract class PlatformFeatureAddCubitCommand extends Command<int>
    with OverridableArgResults {
  /// {@macro platform_feature_add_cubit_command}
  PlatformFeatureAddCubitCommand({
    required Platform platform,
    required Logger logger,
    required Project project,
    required FlutterPubRunBuildRunnerBuildDeleteConflictingOutputsCommand
        flutterPubRunBuildRunnerBuildDeleteConflictingOutputs,
    required GeneratorBuilder generator,
  })  : _platform = platform,
        _logger = logger,
        _project = project,
        _flutterPubRunBuildRunnerBuildDeleteConflictingOutputs =
            flutterPubRunBuildRunnerBuildDeleteConflictingOutputs,
        _generator = generator {
    argParser
      ..addSeparator('')
      ..addOption(
        'feature-name',
        help: 'The name of the feature this new cubit will be added to. '
            'This must be the name of an existing ${_platform.prettyName} feature.',
      );
  }

  final Logger _logger;
  final Platform _platform;
  final Project _project;
  final FlutterPubRunBuildRunnerBuildDeleteConflictingOutputsCommand
      _flutterPubRunBuildRunnerBuildDeleteConflictingOutputs;
  final GeneratorBuilder _generator;

  @override
  String get name => 'cubit';

  @override
  String get description =>
      'Adds a cubit to a feature of the ${_platform.prettyName} part of an existing Rapid project.';

  @override
  Future<int> run() => runWhenCwdHasMelos(_project, _logger, () async {
        final platformIsActivated = _project.isActivated(_platform);

        if (platformIsActivated) {
          final projectName = _project.melosFile.name();
          final featureName = _featureName;

          late final DartPackage featurePackage;
          try {
            final platformDirectory = _project.platformDirectory(_platform);
            featurePackage = platformDirectory.findFeature(_featureName);
          } catch (_) {
            _logger.err(
              'The feature "$_featureName" does no exist on ${_platform.prettyName}.',
            );

            return ExitCode.config.code;
          }

          final name = _name;

          final generateProgress = _logger.progress('Generating files');
          final generator = await _generator(cubitBundle);
          final files = await generator.generate(
            DirectoryGeneratorTarget(Directory('.')),
            vars: <String, dynamic>{
              'project_name': projectName,
              'feature_name': featureName,
              'name': name,
              'platform': _platform.name,
            },
            logger: _logger,
          );
          generateProgress.complete('Generated ${files.length} file(s)');

          final featureBuildProgress = _logger.progress(
            'Running "flutter pub run build_runner build --delete-conflicting-outputs" in ${featurePackage.path} ',
          );
          await _flutterPubRunBuildRunnerBuildDeleteConflictingOutputs(
            cwd: featurePackage.path,
          );
          featureBuildProgress.complete();

          _logger.success(
            'Added ${name.pascalCase}Cubit to ${_platform.prettyName} feature ${featureName.pascalCase}.',
          );

          return ExitCode.success.code;
        } else {
          _logger.err('${_platform.prettyName} is not activated.');

          return ExitCode.config.code;
        }
      });

  /// Gets the name of the cubit.
  String get _name => argResults.rest.first;

  /// Gets the name the feature the cubit should be added to.
  String get _featureName {
    final raw = argResults['feature-name'] as String?;
    if (raw != null) {
      return raw.snakeCase;
    }

    throw UsageException(
      'No option specified for the feature name.',
      usage,
    );
  }
}
