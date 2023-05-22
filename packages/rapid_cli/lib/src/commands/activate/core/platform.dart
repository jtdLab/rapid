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
import 'package:rapid_cli/src/commands/core/command.dart';
import 'package:rapid_cli/src/commands/core/logger_x.dart';
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
abstract class ActivatePlatformCommand extends RapidRootCommand
    with GroupableMixin, BootstrapMixin, CodeGenMixin {
  /// {@macro activate_platform_command}
  ActivatePlatformCommand({
    required this.platform,
    super.logger,
    super.project,
    MelosBootstrapCommand? melosBootstrap,
    FlutterPubGetCommand? flutterPubGet,
    FlutterPubRunBuildRunnerBuildDeleteConflictingOutputsCommand?
        flutterPubRunBuildRunnerBuildDeleteConflictingOutputs,
    FlutterGenl10nCommand? flutterGenl10n,
    DartFormatFixCommand? dartFormatFix,
    required List<FlutterConfigEnablePlatformCommand>
        flutterConfigEnablePlatforms,
  })  : melosBootstrap = melosBootstrap ?? Melos.bootstrap,
        flutterPubGet = flutterPubGet ?? Flutter.pubGet,
        flutterPubRunBuildRunnerBuildDeleteConflictingOutputs =
            flutterPubRunBuildRunnerBuildDeleteConflictingOutputs ??
                Flutter.pubRunBuildRunnerBuildDeleteConflictingOutputs,
        _flutterGenl10n = flutterGenl10n ?? Flutter.genl10n,
        _dartFormatFix = dartFormatFix ?? Dart.formatFix,
        _flutterConfigEnablePlatforms = flutterConfigEnablePlatforms;

  final Platform platform;
  @override
  final MelosBootstrapCommand melosBootstrap;
  @override
  final FlutterPubGetCommand flutterPubGet;
  @override
  final FlutterPubRunBuildRunnerBuildDeleteConflictingOutputsCommand
      flutterPubRunBuildRunnerBuildDeleteConflictingOutputs;
  final FlutterGenl10nCommand _flutterGenl10n;
  final DartFormatFixCommand _dartFormatFix;
  final List<FlutterConfigEnablePlatformCommand> _flutterConfigEnablePlatforms;

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
          projectExistsAll(project),
          platformIsDeactivated(platform, project),
        ],
        logger,
        () async {
          logger.commandTitle('Activating ${platform.prettyName} ...');

          final platformDirectory =
              await createPlatformDirectory(project: project);

          final platformUiPackage =
              project.platformUiPackage(platform: platform);
          await platformUiPackage.create();

          final rootPackage = platformDirectory.rootPackage;
          final navigationPackage = platformDirectory.navigationPackage;
          final featuresDirectory = platformDirectory.featuresDirectory;
          final appFeaturePackage = featuresDirectory
              .featurePackage<PlatformAppFeaturePackage>(name: 'app');
          final homePageFeaturePackage =
              featuresDirectory.featurePackage(name: 'home_page');

          await bootstrap(
            packages: [
              rootPackage,
              navigationPackage,
              appFeaturePackage,
              homePageFeaturePackage,
              platformUiPackage,
            ],
            logger: logger,
          );
          await codeGen(packages: [rootPackage], logger: logger);

          await _flutterGenl10n(cwd: appFeaturePackage.path, logger: logger);
          await _flutterGenl10n(
            cwd: homePageFeaturePackage.path,
            logger: logger,
          );

          await _dartFormatFix(cwd: project.path, logger: logger);

          for (final flutterConfigEnablePlatform
              in _flutterConfigEnablePlatforms) {
            await flutterConfigEnablePlatform(logger: logger);
          }

          logger.commandSuccess();

          return ExitCode.success.code;
        },
      );

  @protected
  Future<PlatformDirectory> createPlatformDirectory({required Project project});
}
