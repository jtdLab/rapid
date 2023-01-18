import 'package:args/command_runner.dart';
import 'package:mason/mason.dart';
import 'package:rapid_cli/src/cli/cli.dart';
import 'package:rapid_cli/src/commands/activate/android/android.dart';
import 'package:rapid_cli/src/commands/activate/ios/ios.dart';
import 'package:rapid_cli/src/commands/activate/linux/linux.dart';
import 'package:rapid_cli/src/commands/activate/macos/macos.dart';
import 'package:rapid_cli/src/commands/activate/web/web.dart';
import 'package:rapid_cli/src/commands/activate/windows/windows.dart';
import 'package:rapid_cli/src/commands/core/generator_builder.dart';
import 'package:rapid_cli/src/commands/core/overridable_arg_results.dart';
import 'package:rapid_cli/src/commands/core/run_when.dart';
import 'package:rapid_cli/src/core/platform.dart';
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
    required Platform platform,
    required MasonBundle platformBundle,
    Logger? logger,
    required Project project,
    FlutterConfigEnablePlatformCommand? flutterConfigEnablePlatform,
    FlutterPubGetCommand? flutterPubGetCommand,
    FlutterPubRunBuildRunnerBuildDeleteConflictingOutputsCommand?
        flutterPubRunBuildRunnerBuildDeleteConflictingOutputs,
    MelosBootstrapCommand? melosBootstrap,
    MelosCleanCommand? melosClean,
    FlutterFormatFixCommand? flutterFormatFix,
    GeneratorBuilder? generator,
  })  : _platform = platform,
        _platformBundle = platformBundle,
        _logger = logger ?? Logger(),
        _project = project,
        _flutterConfigEnablePlatform =
            flutterConfigEnablePlatform ?? Flutter.configEnableAndroid,
        _flutterPubGetCommand = flutterPubGetCommand ?? Flutter.pubGet,
        _flutterPubRunBuildRunnerBuildDeleteConflictingOutputs =
            flutterPubRunBuildRunnerBuildDeleteConflictingOutputs ??
                Flutter.pubRunBuildRunnerBuildDeleteConflictingOutputs,
        _melosBootstrap = melosBootstrap ?? Melos.bootstrap,
        _melosClean = melosClean ?? Melos.clean,
        _flutterFormatFix = flutterFormatFix ?? Flutter.formatFix,
        _generator = generator ?? MasonGenerator.fromBundle;

  final Platform _platform;
  final MasonBundle _platformBundle;
  final Logger _logger;
  final Project _project;
  final FlutterConfigEnablePlatformCommand _flutterConfigEnablePlatform;
  final FlutterPubGetCommand _flutterPubGetCommand;
  final FlutterPubRunBuildRunnerBuildDeleteConflictingOutputsCommand
      _flutterPubRunBuildRunnerBuildDeleteConflictingOutputs;
  final MelosBootstrapCommand _melosBootstrap;
  final MelosCleanCommand _melosClean;
  final FlutterFormatFixCommand _flutterFormatFix;
  final GeneratorBuilder _generator;

  @override
  String get name => _platform.name;

  @override
  List<String> get aliases => _platform.aliases;

  @override
  String get invocation => 'rapid activate ${_platform.name}';

  @override
  String get description =>
      'Adds support for ${_platform.prettyName} to this project.';

  /// Generates the files needed in the process of activating a platform.
  Future<List<GeneratedFile>> generate({
    required MasonGenerator generator,
    required Logger logger,
    required Project project,
  });

  @override
  Future<int> run() => runWhen(
        [
          melosExists(_project),
          platformIsDeactivated(_platform, _project),
        ],
        _logger,
        () async {
          final projectName = _project.melosFile.name();

          _logger.info(
            'Activating ${lightYellow.wrap(_platform.prettyName)} ...',
          );

          await _flutterConfigEnablePlatform(logger: _logger);

          final generateProgress = _logger.progress(
            'Generating ${_platform.prettyName} files',
          );
          final generator = await _generator(_platformBundle);
          final files = await generate(
            logger: _logger,
            project: _project,
            generator: generator,
          );
          generateProgress.complete(
            'Generated ${files.length} ${_platform.prettyName} file(s)',
          );

          final appPackage = _project.appPackage;
          final appUpdatePackageProgress = _logger.progress(
            'Updating package ${appPackage.path} ',
          );
          final appPackagePubspec = appPackage.pubspecFile;
          appPackagePubspec.setDependency(
            '${projectName}_${_platform.name}_app',
          );
          for (final mainFile in appPackage.mainFiles) {
            mainFile.addSetupForPlatform(_platform);
          }
          appUpdatePackageProgress.complete();

          final diPackage = _project.diPackage;
          final diUpdatePackageProgress = _logger.progress(
            'Updating package ${diPackage.path} ',
          );
          final diPackagePubspec = diPackage.pubspecFile;
          final package = '${projectName}_${_platform.name}_home_page';
          diPackagePubspec.setDependency(package);
          diPackage.injectionFile.addPackage(package);
          diUpdatePackageProgress.complete();

          await _melosClean(logger: _logger);

          await _melosBootstrap(logger: _logger);

          await _flutterPubGetCommand(cwd: diPackage.path, logger: _logger);
          await _flutterPubRunBuildRunnerBuildDeleteConflictingOutputs(
            cwd: diPackage.path,
            logger: _logger,
          );

          await _flutterFormatFix(logger: _logger);

          _logger.info('${lightYellow.wrap(_platform.prettyName)} activated!');

          return ExitCode.success.code;
        },
      );

  /// Completes when [platform] is deactivated in [project].
  Future<void> platformIsDeactivated(Platform platform, Project project) async {
    final platformIsActivated = project.isActivated(platform);

    if (platformIsActivated) {
      throw EnvironmentException(
        ExitCode.config.code,
        '${platform.prettyName} is already activated.',
      );
    }
  }
}
