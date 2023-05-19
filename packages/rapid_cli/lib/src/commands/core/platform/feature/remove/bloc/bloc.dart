import 'package:mason/mason.dart';
import 'package:path/path.dart' as p;
import 'package:rapid_cli/src/cli/cli.dart';
import 'package:rapid_cli/src/commands/android/feature/remove/bloc/bloc.dart';
import 'package:rapid_cli/src/commands/core/class_name_rest.dart';
import 'package:rapid_cli/src/commands/core/command.dart';
import 'package:rapid_cli/src/commands/core/dir_option.dart';
import 'package:rapid_cli/src/commands/core/logger_x.dart';
import 'package:rapid_cli/src/commands/core/platform_x.dart';
import 'package:rapid_cli/src/commands/core/run_when.dart';
import 'package:rapid_cli/src/commands/ios/feature/remove/bloc/bloc.dart';
import 'package:rapid_cli/src/commands/linux/feature/remove/bloc/bloc.dart';
import 'package:rapid_cli/src/commands/macos/feature/remove/bloc/bloc.dart';
import 'package:rapid_cli/src/commands/web/feature/remove/bloc/bloc.dart';
import 'package:rapid_cli/src/commands/windows/feature/remove/bloc/bloc.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/project/platform_directory/platform_features_directory/platform_feature_package/platform_feature_package.dart';

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
class PlatformFeatureRemoveBlocCommand extends RapidRootCommand
    with ClassNameGetter, DirGetter, GroupableMixin, CodeGenMixin {
  /// {@macro platform_feature_remove_bloc_command}
  PlatformFeatureRemoveBlocCommand({
    required Platform platform,
    super.logger,
    required PlatformFeaturePackage featurePackage,
    super.project,
    FlutterPubGetCommand? flutterPubGet,
    FlutterPubRunBuildRunnerBuildDeleteConflictingOutputsCommand?
        flutterPubRunBuildRunnerBuildDeleteConflictingOutputs,
  })  : _platform = platform,
        _featurePackage = featurePackage,
        flutterPubGet = flutterPubGet ?? Flutter.pubGet,
        flutterPubRunBuildRunnerBuildDeleteConflictingOutputs =
            flutterPubRunBuildRunnerBuildDeleteConflictingOutputs ??
                Flutter.pubRunBuildRunnerBuildDeleteConflictingOutputs {
    argParser
      ..addSeparator('')
      ..addDirOption(
        help: 'The directory relative to <feature_package>/lib/src .',
      );
  }

  final Platform _platform;
  final PlatformFeaturePackage _featurePackage;
  @override
  final FlutterPubGetCommand flutterPubGet;
  @override
  final FlutterPubRunBuildRunnerBuildDeleteConflictingOutputsCommand
      flutterPubRunBuildRunnerBuildDeleteConflictingOutputs;

  @override
  String get name => 'bloc';

  @override
  String get invocation =>
      'rapid ${_platform.name} ${_featurePackage.name} remove bloc <name> [arguments]';

  @override
  String get description =>
      'Removes a bloc from ${_featurePackage.name} of the ${_platform.prettyName} part of an existing Rapid project.';

  @override
  Future<int> run() => runWhen([
        projectExistsAll(project),
        platformIsActivated(
          _platform,
          project,
          '${_platform.prettyName} is not activated.',
        ),
      ], logger, () async {
        final name = super.className;
        final featureName = _featurePackage.name;
        final dir = super.dir;

        logger.commandTitle(
          'Removing "${name}Bloc" from "$featureName" (${_platform.prettyName}) ...',
        );

        final platformDirectory =
            project.platformDirectory(platform: _platform);
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

            await codeGen(packages: [featurePackage], logger: logger);

            logger.commandSuccess();

            return ExitCode.success.code;
          } else {
            logger.commandError(
              'The ${name}Bloc does not exist in "$featureName" (${_platform.prettyName}).',
            );

            return ExitCode.config.code;
          }
        } else {
          logger.commandError(
            'The Feature "$featureName" does not exist on ${_platform.prettyName}.',
          );

          return ExitCode.config.code;
        }
      });
}
