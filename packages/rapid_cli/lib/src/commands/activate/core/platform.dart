import 'package:args/command_runner.dart';
import 'package:mason/mason.dart';
import 'package:meta/meta.dart';
import 'package:rapid_cli/src/cli/cli.dart';
import 'package:rapid_cli/src/commands/activate/android/android.dart';
import 'package:rapid_cli/src/commands/activate/core/platform_is_deactivated.dart';
import 'package:rapid_cli/src/commands/activate/ios/ios.dart';
import 'package:rapid_cli/src/commands/activate/linux/linux.dart';
import 'package:rapid_cli/src/commands/activate/macos/macos.dart';
import 'package:rapid_cli/src/commands/activate/web/web.dart';
import 'package:rapid_cli/src/commands/activate/windows/windows.dart';
import 'package:rapid_cli/src/commands/core/overridable_arg_results.dart';
import 'package:rapid_cli/src/commands/core/platform_x.dart';
import 'package:rapid_cli/src/commands/core/run_when.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/project/platform_directory/platform_directory.dart';
import 'package:rapid_cli/src/project/platform_directory/platform_features_directory/platform_feature_package/platform_feature_package.dart';
import 'package:rapid_cli/src/project/project.dart';

/// {@template activate_platform_command}
/// Base class for:
///
///  * [ActivateAndroidCommand]
///
///  * [ActivateIosCommand]
///
///  * [ActivateLinuxCommand]
///
///  * [ActivateMacosCommand]
///
///  * [ActivateWebCommand]
///
///  * [ActivateWindowsCommand]
/// {@endtemplate}
abstract class ActivatePlatformCommand extends Command<int>
    with OverridableArgResults {
  /// {@macro activate_platform_command}
  ActivatePlatformCommand({
    required this.platform,
    Logger? logger,
    Project? project,
    MelosBootstrapCommand? melosBootstrap,
    FlutterPubGetCommand? flutterPubGet,
    FlutterPubRunBuildRunnerBuildDeleteConflictingOutputsCommand?
        flutterPubRunBuildRunnerBuildDeleteConflictingOutputs,
    FlutterGenl10nCommand? flutterGenl10n,
    DartFormatFixCommand? dartFormatFix,
    required FlutterConfigEnablePlatformCommand flutterConfigEnablePlatform,
  })  : _logger = logger ?? Logger(),
        _project = project ?? Project(),
        _melosBootstrap = melosBootstrap ?? Melos.bootstrap,
        _flutterPubGet = flutterPubGet ?? Flutter.pubGet,
        _flutterPubRunBuildRunnerBuildDeleteConflictingOutputs =
            flutterPubRunBuildRunnerBuildDeleteConflictingOutputs ??
                Flutter.pubRunBuildRunnerBuildDeleteConflictingOutputs,
        _flutterGenl10n = flutterGenl10n ?? Flutter.genl10n,
        _dartFormatFix = dartFormatFix ?? Dart.formatFix,
        _flutterConfigEnablePlatform = flutterConfigEnablePlatform;

  final Logger _logger;
  final Project _project;
  final MelosBootstrapCommand _melosBootstrap;
  final FlutterPubGetCommand _flutterPubGet;
  final FlutterPubRunBuildRunnerBuildDeleteConflictingOutputsCommand
      _flutterPubRunBuildRunnerBuildDeleteConflictingOutputs;
  final FlutterGenl10nCommand _flutterGenl10n;
  final DartFormatFixCommand _dartFormatFix;
  final FlutterConfigEnablePlatformCommand _flutterConfigEnablePlatform;

  final Platform platform;

  @override
  String get name => platform.name;

  @override
  List<String> get aliases => platform.aliases;

  @override
  String get invocation => 'rapid activate ${platform.name}';

  @override
  String get description =>
      'Adds support for ${platform.prettyName} to this project.';

  @override
  Future<int> run() => runWhen(
        [
          projectExistsAll(_project),
          platformIsDeactivated(platform, _project),
        ],
        _logger,
        () async {
          _logger.info('Activating ${platform.prettyName} ...');

          final platformDirectory =
              await createPlatformDirectory(project: _project);

          final platformUiPackage =
              _project.platformUiPackage(platform: platform);
          await platformUiPackage.create();

          final rootPackage = platformDirectory.rootPackage;
          final navigationPackage = platformDirectory.navigationPackage;
          final featuresDirectory = platformDirectory.featuresDirectory;
          final appFeaturePackage = featuresDirectory
              .featurePackage<PlatformAppFeaturePackage>(name: 'app');
          final homePageFeaturePackage =
              featuresDirectory.featurePackage(name: 'home_page');

          await _melosBootstrap(
            cwd: _project.path,
            scope: [
              rootPackage.packageName(),
              navigationPackage.packageName(),
              appFeaturePackage.packageName(),
              homePageFeaturePackage.packageName(),
              platformUiPackage.packageName(),
            ],
            logger: _logger,
          );

          await _flutterPubGet(cwd: rootPackage.path, logger: _logger);
          await _flutterPubRunBuildRunnerBuildDeleteConflictingOutputs(
            cwd: rootPackage.path,
            logger: _logger,
          );

          await _flutterGenl10n(cwd: appFeaturePackage.path, logger: _logger);
          await _flutterGenl10n(
            cwd: homePageFeaturePackage.path,
            logger: _logger,
          );

          await _dartFormatFix(cwd: _project.path, logger: _logger);

          await _flutterConfigEnablePlatform(logger: _logger);

          _logger
            ..info('')
            ..success('${platform.prettyName} activated!');

          return ExitCode.success.code;
        },
      );

  @protected
  Future<PlatformDirectory> createPlatformDirectory({required Project project});
}
