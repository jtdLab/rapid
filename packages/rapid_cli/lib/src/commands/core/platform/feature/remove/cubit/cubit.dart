import 'package:mason/mason.dart';
import 'package:path/path.dart' as p;
import 'package:rapid_cli/src/cli/cli.dart';
import 'package:rapid_cli/src/commands/android/feature/remove/cubit/cubit.dart';
import 'package:rapid_cli/src/commands/core/class_name_rest.dart';
import 'package:rapid_cli/src/commands/core/command.dart';
import 'package:rapid_cli/src/commands/core/dir_option.dart';
import 'package:rapid_cli/src/commands/core/platform/feature/core/feature_option.dart';
import 'package:rapid_cli/src/commands/core/platform_x.dart';
import 'package:rapid_cli/src/commands/core/run_when.dart';
import 'package:rapid_cli/src/commands/ios/feature/remove/cubit/cubit.dart';
import 'package:rapid_cli/src/commands/linux/feature/remove/cubit/cubit.dart';
import 'package:rapid_cli/src/commands/macos/feature/remove/cubit/cubit.dart';
import 'package:rapid_cli/src/commands/web/feature/remove/cubit/cubit.dart';
import 'package:rapid_cli/src/commands/windows/feature/remove/cubit/cubit.dart';
import 'package:rapid_cli/src/core/platform.dart';

// TODO share code with remove cubit command

/// {@template platform_feature_remove_cubit_command}
/// Base class for:
///
///  * [AndroidFeatureRemoveCubitCommand]
///
///  * [IosFeatureRemoveCubitCommand]
///
///  * [LinuxFeatureRemoveCubitCommand]
///
///  * [MacosFeatureRemoveCubitCommand]
///
///  * [WebFeatureRemoveCubitCommand]
///
///  * [WindowsFeatureRemoveCubitCommand]
/// {@endtemplate}
class PlatformFeatureRemoveCubitCommand extends RapidRootCommand
    with
        ClassNameGetter,
        FeatureGetter,
        DirGetter,
        GroupableMixin,
        CodeGenMixin {
  /// {@macro platform_feature_remove_cubit_command}
  PlatformFeatureRemoveCubitCommand({
    required Platform platform,
    super.logger,
    super.project,
    FlutterPubGetCommand? flutterPubGet,
    FlutterPubRunBuildRunnerBuildDeleteConflictingOutputsCommand?
        flutterPubRunBuildRunnerBuildDeleteConflictingOutputs,
  })  : _platform = platform,
        flutterPubGet = flutterPubGet ?? Flutter.pubGet,
        flutterPubRunBuildRunnerBuildDeleteConflictingOutputs =
            flutterPubRunBuildRunnerBuildDeleteConflictingOutputs ??
                Flutter.pubRunBuildRunnerBuildDeleteConflictingOutputs {
    argParser
      ..addSeparator('')
      // TODO add hint that its a dart package nameish string but not the full name of the related package
      ..addFeatureOption(
        help: 'The name of the feature the cubit will be removed from.\n'
            'This must be the name of an existing ${_platform.prettyName} feature.',
      )
      ..addSeparator('')
      ..addDirOption(
        help: 'The directory relative to <feature_package>/lib/src .',
      );
  }

  final Platform _platform;
  @override
  final FlutterPubGetCommand flutterPubGet;
  @override
  final FlutterPubRunBuildRunnerBuildDeleteConflictingOutputsCommand
      flutterPubRunBuildRunnerBuildDeleteConflictingOutputs;

  @override
  String get name => 'cubit';

  @override
  String get invocation =>
      'rapid ${_platform.name} feature remove cubit <name> [arguments]';

  @override
  String get description =>
      'Removes a cubit from a feature of the ${_platform.prettyName} part of an existing Rapid project.';

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
        final featureName = super.feature;
        final dir = super.dir;

        logger.info('Removing Cubit ...');

        final platformDirectory =
            project.platformDirectory(platform: _platform);
        final featuresDirectory = platformDirectory.featuresDirectory;
        final featurePackage =
            featuresDirectory.featurePackage(name: featureName);
        if (featurePackage.exists()) {
          final cubit = featurePackage.cubit(name: name, dir: dir);
          if (cubit.existsAny()) {
            cubit.delete();
            // TODO delete application dir if empty

            final applicationBarrelFile = featurePackage.applicationBarrelFile;
            applicationBarrelFile.removeExport(
              p.normalize(
                p.join(dir, '${name.snakeCase}_cubit.dart'),
              ),
            );
            if (applicationBarrelFile.read().trim().isEmpty) {
              applicationBarrelFile.delete();
              final barrelFile = featurePackage.barrelFile;
              barrelFile.removeExport('src/application/application.dart');
            }

            await codeGen(packages: [featurePackage], logger: logger);

            logger
              ..info('')
              ..success(
                'Removed ${name}Cubit from ${_platform.prettyName} feature $featureName.',
              );

            return ExitCode.success.code;
          } else {
            logger
              ..info('')
              ..err(
                'The ${name}Cubit does not exist in $featureName on ${_platform.prettyName}.',
              );

            return ExitCode.config.code;
          }
        } else {
          logger
            ..info('')
            ..err(
              'The feature $featureName does not exist on ${_platform.prettyName}.',
            );

          return ExitCode.config.code;
        }
      });
}
