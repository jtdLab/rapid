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
import 'package:rapid_cli/src/commands/core/run_when_cwd_has_melos.dart';
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
  Future<int> run() => runWhenCwdHasMelos(_project, _logger, () async {
        final platformIsActivated = _project.isActivated(_platform);

        if (platformIsActivated) {
          _logger.err('${_platform.prettyName} is already activated.');

          return ExitCode.config.code;
        } else {
          _logger
              .info('Activating ${lightYellow.wrap(_platform.prettyName)} ...');

          final enablePlatformProgress = _logger.progress(
            'Running "flutter config --enable-${_platform.flutterConfigName}"',
          );
          await _flutterConfigEnablePlatform();
          enablePlatformProgress.complete();

          final projectName = _project.melosFile.name();

          final generateProgress =
              _logger.progress('Generating ${_platform.prettyName} files');
          final generator = await _generator(_platformBundle);
          final files = await generate(
            logger: _logger,
            project: _project,
            generator: generator,
          );
          generateProgress.complete(
              'Generated ${files.length} ${_platform.prettyName} file(s)');

          final appPackage = _project.appPackage;
          final appUpdatePackageProgress =
              _logger.progress('Updating package ${appPackage.path} ');
          final appPackagePubspec = appPackage.pubspecFile;
          appPackagePubspec
              .setDependency('${projectName}_${_platform.name}_app');
          for (final mainFile in appPackage.mainFiles) {
            mainFile.addSetupCodeForPlatform(_platform);
          }
          appUpdatePackageProgress.complete();

          final diPackage = _project.diPackage;
          final diUpdatePackageProgress =
              _logger.progress('Updating package ${diPackage.path} ');
          final diPackagePubspec = diPackage.pubspecFile;
          final package = '${projectName}_${_platform.name}_home_page';
          diPackagePubspec.setDependency(package);
          diPackage.injectionFile.addPackage(package);
          diUpdatePackageProgress.complete();

          final melosCleanProgress = _logger.progress(
            'Running "melos clean" in . ',
          );
          await _melosClean();
          melosCleanProgress.complete();
          final melosBootstrapProgress = _logger.progress(
            'Running "melos bootstrap" in . ',
          );
          await _melosBootstrap();
          melosBootstrapProgress.complete();

          final diPubGetProgress = _logger
              .progress('Running "flutter pub get" in ${diPackage.path} ');
          await _flutterPubGetCommand(cwd: diPackage.path);
          diPubGetProgress.complete();
          final diBuildProgress = _logger.progress(
              'Running "flutter pub run build_runner build --delete-conflicting-outputs" in ${diPackage.path} ');
          await _flutterPubRunBuildRunnerBuildDeleteConflictingOutputs(
            cwd: diPackage.path,
          );
          diBuildProgress.complete();

          final flutterFormatFixProgress = _logger.progress(
            'Running "flutter format . --fix" in . ',
          );
          await _flutterFormatFix();
          flutterFormatFixProgress.complete();

          _logger.info('${lightYellow.wrap(_platform.prettyName)} activated!');

          return ExitCode.success.code;
        }
      });
}
