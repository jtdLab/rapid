import 'package:mason/mason.dart';
import 'package:rapid_cli/src/cli/cli.dart';
import 'package:rapid_cli/src/commands/android/remove/feature/feature.dart';
import 'package:rapid_cli/src/commands/core/command.dart';
import 'package:rapid_cli/src/commands/core/dart_package_name_rest.dart';
import 'package:rapid_cli/src/commands/core/platform_x.dart';
import 'package:rapid_cli/src/commands/core/run_when.dart';
import 'package:rapid_cli/src/commands/ios/remove/feature/feature.dart';
import 'package:rapid_cli/src/commands/linux/remove/feature/feature.dart';
import 'package:rapid_cli/src/commands/macos/remove/feature/feature.dart';
import 'package:rapid_cli/src/commands/web/remove/feature/feature.dart';
import 'package:rapid_cli/src/commands/windows/remove/feature/feature.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/project/project.dart';

/// {@template platform_remove_feature_command}
/// Base class for:
///
///  * [AndroidRemoveFeatureCommand]
///
///  * [IosRemoveFeatureCommand]
///
///  * [LinuxRemoveFeatureCommand]
///
///  * [MacosRemoveFeatureCommand]
///
///  * [WebRemoveFeatureCommand]
///
///  * [WindowsRemoveFeatureCommand]
/// {@endtemplate}
abstract class PlatformRemoveFeatureCommand extends RapidRootCommand
    with DartPackageNameGetter, GroupableMixin, BootstrapMixin, CodeGenMixin {
  /// {@macro platform_remove_feature_command}
  PlatformRemoveFeatureCommand({
    required Platform platform,
    Logger? logger,
    Project? project,
    MelosBootstrapCommand? melosBootstrap,
    FlutterPubGetCommand? flutterPubGet,
    FlutterPubRunBuildRunnerBuildDeleteConflictingOutputsCommand?
        flutterPubRunBuildRunnerBuildDeleteConflictingOutputs,
  })  : _platform = platform,
        _logger = logger ?? Logger(),
        _project = project ?? Project(),
        melosBootstrap = melosBootstrap ?? Melos.bootstrap,
        flutterPubGet = flutterPubGet ?? Flutter.pubGet,
        flutterPubRunBuildRunnerBuildDeleteConflictingOutputs =
            flutterPubRunBuildRunnerBuildDeleteConflictingOutputs ??
                Flutter.pubRunBuildRunnerBuildDeleteConflictingOutputs;

  final Platform _platform;
  final Logger _logger;
  final Project _project;
  @override
  final MelosBootstrapCommand melosBootstrap;
  @override
  final FlutterPubGetCommand flutterPubGet;
  @override
  final FlutterPubRunBuildRunnerBuildDeleteConflictingOutputsCommand
      flutterPubRunBuildRunnerBuildDeleteConflictingOutputs;

  @override
  String get name => 'feature';

  @override
  List<String> get aliases => ['feat'];

  @override
  String get invocation => 'rapid ${_platform.name} remove feature <name>';

  @override
  String get description =>
      'Removes a feature from the ${_platform.prettyName} part of an existing Rapid project.';

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
          final name = super.dartPackageName;

          _logger.info('Removing Feature ...');

          final platformDirectory =
              _project.platformDirectory(platform: _platform);
          final featuresDirectory = platformDirectory.featuresDirectory;
          final featurePackage = featuresDirectory.featurePackage(name: name);
          if (featurePackage.exists()) {
            final rootPackage = platformDirectory.rootPackage;
            // TODO if routing add router to root router list
            await rootPackage.unregisterFeaturePackage(featurePackage);

            final remainingFeaturePackages = featuresDirectory.featurePackages()
              ..remove(featurePackage);

            for (final remainingFeaturePackage in remainingFeaturePackages) {
              final pubspecFile = remainingFeaturePackage.pubspecFile;
              pubspecFile.removeDependency(featurePackage.packageName());
            }

            featurePackage.delete();

            await bootstrap(
              packages: [
                ...remainingFeaturePackages,
                rootPackage,
              ],
              logger: logger,
            );
            await codeGen(
              packages: [rootPackage],
              logger: logger,
            );

            _logger
              ..info('')
              ..success('Removed ${_platform.prettyName} feature $name.');

            return ExitCode.success.code;
          } else {
            _logger
              ..info('')
              ..err(
                'The feature "$name" does not exist on ${_platform.prettyName}.',
              );

            return ExitCode.config.code;
          }
        },
      );
}
