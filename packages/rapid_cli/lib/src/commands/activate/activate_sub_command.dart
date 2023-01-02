import 'package:args/command_runner.dart';
import 'package:mason/mason.dart';
import 'package:rapid_cli/src/cli/cli.dart';
import 'package:rapid_cli/src/commands/activate/activate.dart';
import 'package:rapid_cli/src/commands/core/overridable_arg_results.dart';
import 'package:rapid_cli/src/commands/core/run_when_cwd_has_melos.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/project/project.dart';

// TODO sort vars and methods alphabetically

/// Base class for all subcommands of [ActivateCommand].
abstract class ActivateSubCommand extends Command<int>
    with OverridableArgResults {
  ActivateSubCommand({
    required Platform platform,
    required Logger logger,
    required Project project,
    required FlutterConfigEnablePlatformCommand flutterConfigEnablePlatform,
    required FlutterPubGetCommand flutterPubGetCommand,
    required FlutterPubRunBuildRunnerBuildDeleteConflictingOutputsCommand
        flutterPubRunBuildRunnerBuildDeleteConflictingOutputs,
    required MelosBootstrapCommand melosBootstrap,
    required MelosCleanCommand melosClean,
  })  : _platform = platform,
        _logger = logger,
        _project = project,
        _flutterConfigEnablePlatform = flutterConfigEnablePlatform,
        _flutterPubGetCommand = flutterPubGetCommand,
        _flutterPubRunBuildRunnerBuildDeleteConflictingOutputs =
            flutterPubRunBuildRunnerBuildDeleteConflictingOutputs,
        _melosBootstrap = melosBootstrap,
        _melosClean = melosClean;

  final Platform _platform;
  final Logger _logger;
  final Project _project;
  final FlutterConfigEnablePlatformCommand _flutterConfigEnablePlatform;
  final FlutterPubGetCommand _flutterPubGetCommand;
  final FlutterPubRunBuildRunnerBuildDeleteConflictingOutputsCommand
      _flutterPubRunBuildRunnerBuildDeleteConflictingOutputs;
  final MelosBootstrapCommand _melosBootstrap;
  final MelosCleanCommand _melosClean;

  @override
  String get description =>
      'Adds support for ${_platform.prettyName} to this project.';

  @override
  String get invocation => 'rapid activate ${_platform.name}';

  @override
  String get name => _platform.name;

  @override
  List<String> get aliases => _platform.aliases;

  /// Generates the files needed in the process of activating a platform.
  Future<List<GeneratedFile>> generate({
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
          final files = await generate(logger: _logger, project: _project);
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

          _logger.info('${lightYellow.wrap(_platform.prettyName)} activated!');

          return ExitCode.success.code;
        }
      });
}
