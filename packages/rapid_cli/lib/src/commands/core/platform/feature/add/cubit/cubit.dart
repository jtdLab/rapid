import 'package:args/command_runner.dart';
import 'package:mason/mason.dart';
import 'package:rapid_cli/src/cli/cli.dart';
import 'package:rapid_cli/src/commands/android/feature/add/cubit/cubit.dart';
import 'package:rapid_cli/src/commands/core/class_name_rest.dart';
import 'package:rapid_cli/src/commands/core/output_dir_option.dart';
import 'package:rapid_cli/src/commands/core/overridable_arg_results.dart';
import 'package:rapid_cli/src/commands/core/platform/feature/core/feature_option.dart';
import 'package:rapid_cli/src/commands/core/platform_x.dart';
import 'package:rapid_cli/src/commands/core/run_when.dart';
import 'package:rapid_cli/src/commands/ios/feature/add/cubit/cubit.dart';
import 'package:rapid_cli/src/commands/linux/feature/add/cubit/cubit.dart';
import 'package:rapid_cli/src/commands/macos/feature/add/cubit/cubit.dart';
import 'package:rapid_cli/src/commands/web/feature/add/cubit/cubit.dart';
import 'package:rapid_cli/src/commands/windows/feature/add/cubit/cubit.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/project/project.dart';

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
    with
        OverridableArgResults,
        ClassNameGetter,
        FeatureGetter,
        OutputDirGetter {
  /// {@macro platform_feature_add_cubit_command}
  PlatformFeatureAddCubitCommand({
    required Platform platform,
    Logger? logger,
    Project? project,
    FlutterPubGetCommand? flutterPubGet,
    FlutterPubRunBuildRunnerBuildDeleteConflictingOutputsCommand?
        flutterPubRunBuildRunnerBuildDeleteConflictingOutputs,
  })  : _platform = platform,
        _logger = logger ?? Logger(),
        _project = project ?? Project(),
        _flutterPubGet = flutterPubGet ?? Flutter.pubGet,
        _flutterPubRunBuildRunnerBuildDeleteConflictingOutputs =
            flutterPubRunBuildRunnerBuildDeleteConflictingOutputs ??
                Flutter.pubRunBuildRunnerBuildDeleteConflictingOutputs {
    argParser
      ..addSeparator('')
      ..addFeatureOption(
        help: 'The name of the feature this new cubit will be added to.\n'
            'This must be the name of an existing ${_platform.prettyName} feature.',
      )
      ..addSeparator('')
      ..addOutputDirOption(
        help: 'The output directory relative to <feature_package>/lib/src .',
      );
  }

  final Platform _platform;
  final Logger _logger;
  final Project _project;
  final FlutterPubGetCommand _flutterPubGet;
  final FlutterPubRunBuildRunnerBuildDeleteConflictingOutputsCommand
      _flutterPubRunBuildRunnerBuildDeleteConflictingOutputs;

  @override
  String get name => 'cubit';

  @override
  String get invocation =>
      'rapid ${_platform.name} feature add cubit <name> [arguments]';

  @override
  String get description =>
      'Adds a cubit to a feature of the ${_platform.prettyName} part of an existing Rapid project.';

  @override
  Future<int> run() => runWhen(
        [
          projectExistsAll(_project),
          platformIsActivated(
            _platform,
            _project,
            '${_platform.prettyName} is not activated.',
          ),
        ],
        _logger,
        () async {
          final name = super.className;
          final featureName = super.feature;
          final outputDir = super.outputDir;

          _logger.info('Adding Cubit ...');

          final platformDirectory =
              _project.platformDirectory(platform: _platform);
          final featuresDirectory = platformDirectory.featuresDirectory;
          final featurePackage =
              featuresDirectory.featurePackage(name: featureName);
          if (featurePackage.exists()) {
            final cubit = featurePackage.cubit(name: name, dir: outputDir);
            if (!cubit.existsAny()) {
              await cubit.create();

              await _flutterPubGet(cwd: featurePackage.path, logger: _logger);
              await _flutterPubRunBuildRunnerBuildDeleteConflictingOutputs(
                cwd: featurePackage.path,
                logger: _logger,
              );

              _logger
                ..info('')
                ..success(
                  'Added ${name}Cubit to ${_platform.prettyName} feature $featureName.',
                );

              return ExitCode.success.code;
            } else {
              _logger
                ..info('')
                ..err(
                  'The ${name}Cubit does already exist in $featureName on ${_platform.prettyName}.',
                );

              return ExitCode.config.code;
            }
          } else {
            _logger
              ..info('')
              ..err(
                'The feature $featureName does not exist on ${_platform.prettyName}.',
              );

            return ExitCode.config.code;
          }
        },
      );
}
