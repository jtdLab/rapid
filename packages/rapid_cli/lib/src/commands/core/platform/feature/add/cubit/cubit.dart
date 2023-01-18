import 'package:args/command_runner.dart';
import 'package:mason/mason.dart';
import 'package:rapid_cli/src/cli/cli.dart';
import 'package:rapid_cli/src/commands/android/feature/add/cubit/cubit.dart';
import 'package:rapid_cli/src/commands/core/class_name_arg.dart';
import 'package:rapid_cli/src/commands/core/generator_builder.dart';
import 'package:rapid_cli/src/commands/core/overridable_arg_results.dart';
import 'package:rapid_cli/src/commands/core/run_when_cwd_has_melos.dart';
import 'package:rapid_cli/src/commands/core/validate_dart_package_name.dart';
import 'package:rapid_cli/src/commands/ios/feature/add/cubit/cubit.dart';
import 'package:rapid_cli/src/commands/linux/feature/add/cubit/cubit.dart';
import 'package:rapid_cli/src/commands/macos/feature/add/cubit/cubit.dart';
import 'package:rapid_cli/src/commands/web/feature/add/cubit/cubit.dart';
import 'package:rapid_cli/src/commands/windows/feature/add/cubit/cubit.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/project/project.dart';
import 'package:recase/recase.dart';
import 'package:universal_io/io.dart';

import 'cubit_bundle.dart';

/// {@template platform_feature_add_cubit_command}
/// Base class for:
///
///  * [AndroidFeatureAddCubitCommand]
///
///  * [IosFeatureAddCubitCommand]
///
///  * [LinuxFeatureAddCubitCommand]
///
///  * [MacosFeatureAddCubitCommand]
///
///  * [WebFeatureAddCubitCommand]
///
///  * [WindowsFeatureAddCubitCommand]
/// {@endtemplate}
abstract class PlatformFeatureAddCubitCommand extends Command<int>
    with OverridableArgResults, ClassNameGetter {
  /// {@macro platform_feature_add_cubit_command}
  PlatformFeatureAddCubitCommand({
    required Platform platform,
    Logger? logger,
    required Project project,
    FlutterPubRunBuildRunnerBuildDeleteConflictingOutputsCommand?
        flutterPubRunBuildRunnerBuildDeleteConflictingOutputs,
    GeneratorBuilder? generator,
  })  : _platform = platform,
        _logger = logger ?? Logger(),
        _project = project,
        _flutterPubRunBuildRunnerBuildDeleteConflictingOutputs =
            flutterPubRunBuildRunnerBuildDeleteConflictingOutputs ??
                Flutter.pubRunBuildRunnerBuildDeleteConflictingOutputs,
        _generator = generator ?? MasonGenerator.fromBundle {
    argParser
      ..addSeparator('')
      ..addOption(
        'feature-name',
        help: 'The name of the feature this new cubit will be added to.\n'
            'This must be the name of an existing ${_platform.prettyName} feature.',
      );
  }

  final Platform _platform;
  final Logger _logger;
  final Project _project;
  final FlutterPubRunBuildRunnerBuildDeleteConflictingOutputsCommand
      _flutterPubRunBuildRunnerBuildDeleteConflictingOutputs;
  final GeneratorBuilder _generator;

  @override
  String get name => 'cubit';

  @override
  String get invocation =>
      'rapid ${_platform.name} feature add cubit <name> [arguments]';

  @override
  String get description =>
      'Adds a cubit to a feature of the ${_platform.prettyName} part of an existing Rapid project.';

  @override
  Future<int> run() => runWhenCwdHasMelos(_project, _logger, () async {
        final platformIsActivated = _project.isActivated(_platform);

        if (platformIsActivated) {
          final projectName = _project.melosFile.name();
          final featureName = _featureName;
          final name = super.className;

          final platformDirectory = _project.platformDirectory(_platform);
          if (platformDirectory.featureExists(_featureName)) {
            final feature = platformDirectory.findFeature(_featureName);

            // TODO check if cubit exists

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

            await _flutterPubRunBuildRunnerBuildDeleteConflictingOutputs(
              cwd: feature.path,
              logger: _logger,
            );

            _logger.success(
              'Added ${name.pascalCase}Cubit to ${_platform.prettyName} feature $featureName.',
            );

            return ExitCode.success.code;
          } else {
            _logger.err(
              'The feature "$_featureName" does not exist on ${_platform.prettyName}.',
            );

            return ExitCode.config.code;
          }
        } else {
          _logger.err('${_platform.prettyName} is not activated.');

          return ExitCode.config.code;
        }
      });

  /// Gets the name the feature the cubit should be added to.
  String get _featureName {
    final raw = argResults['feature-name'] as String?;

    if (raw == null) {
      throw UsageException(
        'No option specified for the feature name.',
        usage,
      );
    }

    final isValid = isValidPackageName(raw);
    if (!isValid) {
      throw UsageException(
        '"$raw" is not a valid package name.\n\n'
        'See https://dart.dev/tools/pub/pubspec#name for more information.',
        usage,
      );
    }

    return raw;
  }
}
