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

/// The default description.
const _defaultDescription = 'A Rapid app.';

/// {@template activate_web_command}
/// `rapid activate web` command adds support for Web to an existing Rapid project.
/// {@endtemplate}
class ActivateWebCommand extends ActivatePlatformCommand
    with OrgNameGetter, LanguageGetter {
  /// {@macro activate_web_command}
  ActivateWebCommand({
    Logger? logger,
    Project? project,
    MelosBootstrapCommand? melosBootstrap,
    FlutterPubGetCommand? flutterPubGet,
    FlutterPubRunBuildRunnerBuildDeleteConflictingOutputsCommand?
        flutterPubRunBuildRunnerBuildDeleteConflictingOutputs,
    FlutterGenl10nCommand? flutterGenl10n,
    DartFormatFixCommand? dartFormatFix,
    FlutterConfigEnablePlatformCommand? flutterConfigEnableWeb,
  })  : _logger = logger ?? Logger(),
        _project = project ?? Project(),
        _melosBootstrap = melosBootstrap ?? Melos.bootstrap,
        _flutterPubGet = flutterPubGet ?? Flutter.pubGet,
        _flutterPubRunBuildRunnerBuildDeleteConflictingOutputs =
            flutterPubRunBuildRunnerBuildDeleteConflictingOutputs ??
                Flutter.pubRunBuildRunnerBuildDeleteConflictingOutputs,
        _flutterGenl10n = flutterGenl10n ?? Flutter.genl10n,
        _dartFormatFix = dartFormatFix ?? Dart.formatFix,
        _flutterConfigEnableWeb =
            flutterConfigEnableWeb ?? Flutter.configEnableWeb,
        super(platform: Platform.web) {
    argParser
      ..addOption(
        'desc',
        help: 'The description for the native Web project.',
        defaultsTo: _defaultDescription,
      )
      ..addLanguageOption(
        help: 'The default language for Web',
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
  final FlutterConfigEnablePlatformCommand _flutterConfigEnableWeb;

  @override
  Future<int> run() => runWhen(
        [
          projectExistsAll(_project),
          platformIsDeactivated(platform, _project),
        ],
        _logger,
        () async {
          final description = _description;
          final language = super.language;

          _logger.info('Activating ${platform.prettyName} ...');

          await _project.addPlatform(
            platform,
            description: description,
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

          await _flutterConfigEnableWeb(logger: _logger);

          _logger
            ..info('')
            ..success('${platform.prettyName} activated!');

          return ExitCode.success.code;
        },
      );

  /// Gets the description for the project specified by the user.
  String get _description => argResults['desc'] ?? _defaultDescription;
}
