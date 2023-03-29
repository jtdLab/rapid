import 'package:mason/mason.dart';
import 'package:rapid_cli/src/cli/cli.dart';
import 'package:rapid_cli/src/commands/activate/core/platform.dart';
import 'package:rapid_cli/src/commands/activate/core/platform_is_deactivated.dart';
import 'package:rapid_cli/src/commands/core/language_option.dart';
import 'package:rapid_cli/src/commands/core/org_name_option.dart';
import 'package:rapid_cli/src/commands/core/platform_x.dart';
import 'package:rapid_cli/src/commands/core/run_when.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/project/platform_directory/platform_features_directory/platform_feature_package/platform_feature_package.dart';
import 'package:rapid_cli/src/project/project.dart';

/// {@template activate_windows_command}
/// `rapid activate windows` command adds support for Windows to an existing Rapid project.
/// {@endtemplate}
class ActivateWindowsCommand extends ActivatePlatformCommand
    with OrgNameGetter, LanguageGetter {
  /// {@macro activate_windows_command}
  ActivateWindowsCommand({
    Logger? logger,
    Project? project,
    MelosBootstrapCommand? melosBootstrap,
    FlutterPubGetCommand? flutterPubGet,
    FlutterPubRunBuildRunnerBuildDeleteConflictingOutputsCommand?
        flutterPubRunBuildRunnerBuildDeleteConflictingOutputs,
    FlutterGenl10nCommand? flutterGenl10n,
    DartFormatFixCommand? dartFormatFix,
    FlutterConfigEnablePlatformCommand? flutterConfigEnableWindows,
  })  : _logger = logger ?? Logger(),
        _project = project ?? Project(),
        _melosBootstrap = melosBootstrap ?? Melos.bootstrap,
        _flutterPubGet = flutterPubGet ?? Flutter.pubGet,
        _flutterPubRunBuildRunnerBuildDeleteConflictingOutputs =
            flutterPubRunBuildRunnerBuildDeleteConflictingOutputs ??
                Flutter.pubRunBuildRunnerBuildDeleteConflictingOutputs,
        _flutterGenl10n = flutterGenl10n ?? Flutter.genl10n,
        _dartFormatFix = dartFormatFix ?? Dart.formatFix,
        _flutterConfigEnableWindows =
            flutterConfigEnableWindows ?? Flutter.configEnableWindows,
        super(platform: Platform.windows) {
    argParser
      ..addOrgNameOption(
        help: 'The organization for the native Windows project.',
      )
      ..addLanguageOption(
        help: 'The default language for Windows',
      );
  }

  final Logger _logger;
  final Project _project;
  final MelosBootstrapCommand _melosBootstrap;
  final FlutterPubGetCommand _flutterPubGet;
  final FlutterPubRunBuildRunnerBuildDeleteConflictingOutputsCommand
      _flutterPubRunBuildRunnerBuildDeleteConflictingOutputs;
  final FlutterGenl10nCommand _flutterGenl10n;
  final DartFormatFixCommand _dartFormatFix;
  final FlutterConfigEnablePlatformCommand _flutterConfigEnableWindows;

  @override
  Future<int> run() => runWhen(
        [
          projectExistsAll(_project),
          platformIsDeactivated(platform, _project),
        ],
        _logger,
        () async {
          final orgName = super.orgName;
          final language = super.language;

          _logger.info('Activating ${platform.prettyName} ...');

          await _project.addPlatform(
            platform,
            orgName: orgName,
            language: language,
            logger: _logger,
          );

          final platformDirectory =
              _project.platformDirectory(platform: platform);
          final rootPackage = platformDirectory.rootPackage;
          final navigationPackage = platformDirectory.navigationPackage;
          final featuresDirectory = platformDirectory.featuresDirectory;
          final appFeaturePackage = featuresDirectory
              .featurePackage<PlatformAppFeaturePackage>('app');
          final homePageFeaturePackage =
              platformDirectory.featuresDirectory.featurePackage('home_page');
          final platformUiPackage =
              _project.platformUiPackage(platform: platform);

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

          await _flutterConfigEnableWindows(logger: _logger);

          _logger
            ..info('')
            ..success('${platform.prettyName} activated!');

          return ExitCode.success.code;
        },
      );
}
