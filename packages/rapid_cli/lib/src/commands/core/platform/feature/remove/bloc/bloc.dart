import 'package:args/command_runner.dart';
import 'package:mason/mason.dart';
import 'package:path/path.dart' as p;
import 'package:rapid_cli/src/cli/cli.dart';
import 'package:rapid_cli/src/commands/android/feature/remove/bloc/bloc.dart';
import 'package:rapid_cli/src/commands/core/class_name_rest.dart';
import 'package:rapid_cli/src/commands/core/dir_option.dart';
import 'package:rapid_cli/src/commands/core/overridable_arg_results.dart';
import 'package:rapid_cli/src/commands/core/platform/feature/core/feature_option.dart';
import 'package:rapid_cli/src/commands/core/platform_x.dart';
import 'package:rapid_cli/src/commands/core/run_when.dart';
import 'package:rapid_cli/src/commands/ios/feature/remove/bloc/bloc.dart';
import 'package:rapid_cli/src/commands/linux/feature/remove/bloc/bloc.dart';
import 'package:rapid_cli/src/commands/macos/feature/remove/bloc/bloc.dart';
import 'package:rapid_cli/src/commands/web/feature/remove/bloc/bloc.dart';
import 'package:rapid_cli/src/commands/windows/feature/remove/bloc/bloc.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/project/project.dart';

// TODO share code with remove bloc command

/// {@template platform_feature_remove_bloc_command}
/// Base class for:
///
///  * [AndroidFeatureRemoveBlocCommand]
///
///  * [IosFeatureRemoveBlocCommand]
///
///  * [LinuxFeatureRemoveBlocCommand]
///
///  * [MacosFeatureRemoveBlocCommand]
///
///  * [WebFeatureRemoveBlocCommand]
///
///  * [WindowsFeatureRemoveBlocCommand]
/// {@endtemplate}
class PlatformFeatureRemoveBlocCommand extends Command<int>
    with OverridableArgResults, ClassNameGetter, FeatureGetter, DirGetter {
  /// {@macro platform_feature_remove_bloc_command}
  PlatformFeatureRemoveBlocCommand({
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
        help: 'The name of the feature the bloc will be removed from.\n'
            'This must be the name of an existing ${_platform.prettyName} feature.',
      )
      ..addSeparator('')
      ..addDirOption(
        help: 'The directory relative to <feature_package>/lib/src .',
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
      'rapid ${_platform.name} feature remove bloc <name> [arguments]';

  @override
  String get description =>
      'Removes a bloc from a feature of the ${_platform.prettyName} part of an existing Rapid project.';

  @override
  Future<int> run() => runWhen([
        projectExistsAll(_project),
        platformIsActivated(
          _platform,
          _project,
          '${_platform.prettyName} is not activated.',
        ),
      ], _logger, () async {
        final name = super.className;
        final featureName = super.feature;
        final dir = super.dir;

        _logger.info('Removing Bloc ...');

        final platformDirectory =
            _project.platformDirectory(platform: _platform);
        final featuresDirectory = platformDirectory.featuresDirectory;
        final featurePackage =
            featuresDirectory.featurePackage(name: featureName);
        if (featurePackage.exists()) {
          final bloc = featurePackage.bloc(name: name, dir: dir);
          if (bloc.existsAny()) {
            bloc.delete();
            // TODO delete application dir if empty

            final applicationBarrelFile = featurePackage.applicationBarrelFile;
            applicationBarrelFile.removeExport(
              p.normalize(
                p.join(dir, '${name.snakeCase}_bloc.dart'),
              ),
            );
            if (applicationBarrelFile.read().trim().isEmpty) {
              applicationBarrelFile.delete();
              final barrelFile = featurePackage.barrelFile;
              barrelFile.removeExport('src/application/application.dart');
            }

            await _flutterPubGet(cwd: featurePackage.path, logger: _logger);
            await _flutterPubRunBuildRunnerBuildDeleteConflictingOutputs(
              cwd: featurePackage.path,
              logger: _logger,
            );

            _logger
              ..info('')
              ..success(
                'Removed ${name}Bloc from ${_platform.prettyName} feature $featureName.',
              );

            return ExitCode.success.code;
          } else {
            _logger
              ..info('')
              ..err(
                'The ${name}Bloc does not exist in $featureName on ${_platform.prettyName}.',
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
      });
}
