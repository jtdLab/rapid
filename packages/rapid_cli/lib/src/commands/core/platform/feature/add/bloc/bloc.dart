import 'package:mason/mason.dart';
import 'package:path/path.dart' as p;
import 'package:rapid_cli/src/cli/cli.dart';
import 'package:rapid_cli/src/commands/android/feature/add/bloc/bloc.dart';
import 'package:rapid_cli/src/commands/core/class_name_rest.dart';
import 'package:rapid_cli/src/commands/core/command.dart';
import 'package:rapid_cli/src/commands/core/logger_x.dart';
import 'package:rapid_cli/src/commands/core/output_dir_option.dart';
import 'package:rapid_cli/src/commands/core/platform_x.dart';
import 'package:rapid_cli/src/commands/core/run_when.dart';
import 'package:rapid_cli/src/commands/ios/feature/add/bloc/bloc.dart';
import 'package:rapid_cli/src/commands/linux/feature/add/bloc/bloc.dart';
import 'package:rapid_cli/src/commands/macos/feature/add/bloc/bloc.dart';
import 'package:rapid_cli/src/commands/web/feature/add/bloc/bloc.dart';
import 'package:rapid_cli/src/commands/windows/feature/add/bloc/bloc.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/project/platform_directory/platform_features_directory/platform_feature_package/platform_feature_package.dart';

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
abstract class PlatformFeatureAddBlocCommand extends RapidRootCommand
    with ClassNameGetter, OutputDirGetter, GroupableMixin, CodeGenMixin {
  /// {@macro platform_feature_add_bloc_command}
  PlatformFeatureAddBlocCommand({
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
      ..addOutputDirOption(
        help: 'The output directory relative to <feature_package>/lib/src .',
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
      'rapid ${_platform.name} ${_featurePackage.name} add bloc <name> [arguments]';

  @override
  String get description =>
      'Adds a bloc to ${_featurePackage.name} of the ${_platform.prettyName} part of an existing Rapid project.';

  @override
  Future<int> run() => runWhen(
        [
          projectExistsAll(project),
          platformIsActivated(
            _platform,
            project,
            '${_platform.prettyName} is not activated.',
          ),
        ],
        logger,
        () async {
          final name = super.className;
          final featureName = _featurePackage.name;
          final outputDir = super.outputDir;

          logger.commandTitle(
            'Adding "${name}Bloc" to "$featureName" (${_platform.prettyName}) ...',
          );

          final platformDirectory =
              project.platformDirectory(platform: _platform);
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

              await codeGen(packages: [featurePackage], logger: logger);

              logger.commandSuccess();

              return ExitCode.success.code;
            } else {
              logger.commandError(
                'The ${name}Bloc does already exist in "$featureName" (${_platform.prettyName}).',
              );

              return ExitCode.config.code;
            }
          } else {
            logger.commandError(
              'The Feature "$featureName" does not exist on ${_platform.prettyName}.',
            );

            return ExitCode.config.code;
          }
        },
      );
}
