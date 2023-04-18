import 'package:args/command_runner.dart';
import 'package:mason/mason.dart';
import 'package:rapid_cli/src/cli/cli.dart';
import 'package:rapid_cli/src/commands/android/remove/feature/feature.dart';
import 'package:rapid_cli/src/commands/core/dart_package_name_rest.dart';
import 'package:rapid_cli/src/commands/core/overridable_arg_results.dart';
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
abstract class PlatformRemoveFeatureCommand extends Command<int>
    with OverridableArgResults, DartPackageNameGetter {
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
        _melosBootstrap = melosBootstrap ?? Melos.bootstrap,
        _flutterPubGet = flutterPubGet ?? Flutter.pubGet,
        _flutterPubRunBuildRunnerBuildDeleteConflictingOutputs =
            flutterPubRunBuildRunnerBuildDeleteConflictingOutputs ??
                Flutter.pubRunBuildRunnerBuildDeleteConflictingOutputs;

  final Platform _platform;
  final Logger _logger;
  final Project _project;
  final MelosBootstrapCommand _melosBootstrap;
  final FlutterPubGetCommand _flutterPubGet;
  final FlutterPubRunBuildRunnerBuildDeleteConflictingOutputsCommand
      _flutterPubRunBuildRunnerBuildDeleteConflictingOutputs;

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

            await _melosBootstrap(
              cwd: _project.path,
              logger: _logger,
              scope: [
                ...remainingFeaturePackages.map((e) => e.packageName()),
                rootPackage.packageName(),
              ],
            );

            await _flutterPubGet(cwd: rootPackage.path, logger: _logger);
            await _flutterPubRunBuildRunnerBuildDeleteConflictingOutputs(
              cwd: rootPackage.path,
              logger: _logger,
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
