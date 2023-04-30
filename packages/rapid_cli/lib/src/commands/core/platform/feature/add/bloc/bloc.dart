import 'package:args/command_runner.dart';
import 'package:mason/mason.dart';
import 'package:path/path.dart' as p;
import 'package:rapid_cli/src/cli/cli.dart';
import 'package:rapid_cli/src/commands/android/feature/add/bloc/bloc.dart';
import 'package:rapid_cli/src/commands/core/class_name_rest.dart';
import 'package:rapid_cli/src/commands/core/output_dir_option.dart';
import 'package:rapid_cli/src/commands/core/overridable_arg_results.dart';
import 'package:rapid_cli/src/commands/core/platform/feature/core/feature_option.dart';
import 'package:rapid_cli/src/commands/core/platform_x.dart';
import 'package:rapid_cli/src/commands/core/run_when.dart';
import 'package:rapid_cli/src/commands/ios/feature/add/bloc/bloc.dart';
import 'package:rapid_cli/src/commands/linux/feature/add/bloc/bloc.dart';
import 'package:rapid_cli/src/commands/macos/feature/add/bloc/bloc.dart';
import 'package:rapid_cli/src/commands/web/feature/add/bloc/bloc.dart';
import 'package:rapid_cli/src/commands/windows/feature/add/bloc/bloc.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/project/project.dart';

// TODO share code with add cubit command

/// {@template platform_feature_add_bloc_command}
/// Base class for:
///
///  * [AndroidFeatureAddBlocCommand]
///
///  * [IosFeatureAddBlocCommand]
///
///  * [LinuxFeatureAddBlocCommand]
///
///  * [MacosFeatureAddBlocCommand]
///
///  * [WebFeatureAddBlocCommand]
///
///  * [WindowsFeatureAddBlocCommand]
/// {@endtemplate}
abstract class PlatformFeatureAddBlocCommand extends Command<int>
    with
        OverridableArgResults,
        ClassNameGetter,
        FeatureGetter,
        OutputDirGetter {
  /// {@macro platform_feature_add_bloc_command}
  PlatformFeatureAddBlocCommand({
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
      // TODO add hint that its a dart package nameish string but not the full name of the related package
      ..addFeatureOption(
        help: 'The name of the feature this new bloc will be added to.\n'
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
  String get name => 'bloc';

  @override
  String get invocation =>
      'rapid ${_platform.name} feature add bloc <name> [arguments]';

  @override
  String get description =>
      'Adds a bloc to a feature of the ${_platform.prettyName} part of an existing Rapid project.';

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

          _logger.info('Adding Bloc ...');

          final platformDirectory =
              _project.platformDirectory(platform: _platform);
          final featuresDirectory = platformDirectory.featuresDirectory;
          final featurePackage =
              featuresDirectory.featurePackage(name: featureName);
          if (featurePackage.exists()) {
            final bloc = featurePackage.bloc(name: name, dir: outputDir);
            if (!bloc.existsAny()) {
              await bloc.create();

              final applicationBarrelFile =
                  featurePackage.applicationBarrelFile;
              if (!applicationBarrelFile.exists()) {
                await applicationBarrelFile.create();
                applicationBarrelFile.addExport(
                  p.normalize(
                    p.join(outputDir, '${name.snakeCase}_bloc.dart'),
                  ),
                );

                final barrelFile = featurePackage.barrelFile;
                barrelFile.addExport(
                  'src/application/application.dart',
                );
              } else {
                applicationBarrelFile.addExport(
                  p.normalize(
                    p.join(outputDir, '${name.snakeCase}_bloc.dart'),
                  ),
                );
              }

              await _flutterPubGet(cwd: featurePackage.path, logger: _logger);
              await _flutterPubRunBuildRunnerBuildDeleteConflictingOutputs(
                cwd: featurePackage.path,
                logger: _logger,
              );

              _logger
                ..info('')
                ..success(
                  'Added ${name}Bloc to ${_platform.prettyName} feature $featureName.',
                );

              return ExitCode.success.code;
            } else {
              _logger
                ..info('')
                ..err(
                  'The ${name}Bloc does already exist in $featureName on ${_platform.prettyName}.',
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
