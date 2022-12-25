import 'package:args/command_runner.dart';
import 'package:mason/mason.dart';
import 'package:rapid_cli/src/cli/cli.dart';
import 'package:rapid_cli/src/commands/activate/web/web_bundle.dart';
import 'package:rapid_cli/src/commands/core/generator_builder.dart';
import 'package:rapid_cli/src/commands/core/overridable_arg_results.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/core/project.dart';

/// {@template activate_web_command}
/// `rapid activate web` command adds support for Web to an existing Rapid project.
/// {@endtemplate}
class WebCommand extends Command<int> with OverridableArgResults {
  WebCommand({
    Logger? logger,
    required Project project,
    FlutterConfigEnablePlatformCommand? flutterConfigEnableWeb,
    FlutterPubGetCommand? flutterPubGetCommand,
    FlutterPubRunBuildRunnerBuildDeleteConflictingOutputsCommand?
        flutterPubRunBuildRunnerBuildDeleteConflictingOutputs,
    MelosBootstrapCommand? melosBootstrap,
    MelosCleanCommand? melosClean,
    GeneratorBuilder? generator,
  })  : _logger = logger ?? Logger(),
        _project = project,
        _flutterConfigEnableWeb =
            flutterConfigEnableWeb ?? Flutter.configEnableWeb,
        _flutterPubGetCommand = flutterPubGetCommand ?? Flutter.pubGet,
        _flutterPubRunBuildRunnerBuildDeleteConflictingOutputs =
            flutterPubRunBuildRunnerBuildDeleteConflictingOutputs ??
                Flutter.pubRunBuildRunnerBuildDeleteConflictingOutputs,
        _melosBootstrap = melosBootstrap ?? Melos.bootstrap,
        _melosClean = melosClean ?? Melos.clean,
        _generator = generator ?? MasonGenerator.fromBundle;

  final Logger _logger;
  final Project _project;
  final FlutterConfigEnablePlatformCommand _flutterConfigEnableWeb;
  final FlutterPubGetCommand _flutterPubGetCommand;
  final FlutterPubRunBuildRunnerBuildDeleteConflictingOutputsCommand
      _flutterPubRunBuildRunnerBuildDeleteConflictingOutputs;
  final MelosBootstrapCommand _melosBootstrap;
  final MelosCleanCommand _melosClean;
  final GeneratorBuilder _generator;

  @override
  String get description => 'Adds support for Web to this project.';

  @override
  String get invocation => 'rapid activate web';

  @override
  String get name => 'web';

  @override
  Future<int> run() async {
    final platformIsActivated = _project.isActivated(Platform.web);

    if (platformIsActivated) {
      _logger.err('Web is already activated.');

      return ExitCode.config.code;
    } else {
      _logger.info('Activating ${lightYellow.wrap('Web')} ...');

      final enableMacosProgress = _logger.progress(
        'Running "flutter config --enable-web"',
      );
      await _flutterConfigEnableWeb();
      enableMacosProgress.complete();

      final projectName = _project.melosFile.name;

      final generateProgress = _logger.progress('Generating Web files');
      final generator = await _generator(webBundle);
      final files = await generator.generate(
        DirectoryGeneratorTarget(_project.rootDir.directory),
        vars: {
          'project_name': projectName,
        },
        logger: _logger,
      );
      generateProgress.complete('Generated ${files.length} Web file(s)');

      final appPackage = _project.appPackage;
      final appUpdatePackageProgress =
          _logger.progress('Updating package ${appPackage.path} ');
      final appPackagePubspec = appPackage.pubspecFile;
      appPackagePubspec.addDependency('${projectName}_web_app');
      for (final mainFile in appPackage.mainFiles) {
        mainFile.addPlatform(Platform.web);
      }
      appUpdatePackageProgress.complete();

      final diPackage = _project.diPackage;
      final diUpdatePackageProgress =
          _logger.progress('Updating package ${diPackage.path} ');
      final diPackagePubspec = diPackage.pubspecFile;
      final package = '${projectName}_web_home_page';
      diPackagePubspec.addDependency(package);
      diPackage.injectionFile.addPackage(package);
      diUpdatePackageProgress.complete();

      final melosCleanProgress = _logger.progress(
        'Running "melos clean" in ${_project.rootDir.path} ',
      );
      await _melosClean(cwd: _project.rootDir.path);
      melosCleanProgress.complete();
      final melosBootstrapProgress = _logger.progress(
        'Running "melos bootstrap" in ${_project.rootDir.path} ',
      );
      await _melosBootstrap(cwd: _project.rootDir.path);
      melosBootstrapProgress.complete();

      final diPubGetProgress =
          _logger.progress('Running "flutter pub get" in ${diPackage.path} ');
      await _flutterPubGetCommand(cwd: diPackage.path);
      diPubGetProgress.complete();
      final diBuildProgress = _logger.progress(
          'Running "flutter pub run build_runner build --delete-conflicting-outputs" in ${diPackage.path} ');
      await _flutterPubRunBuildRunnerBuildDeleteConflictingOutputs(
        cwd: diPackage.path,
      );
      diBuildProgress.complete();

      _logger.info('${lightYellow.wrap('Web')} activated!');

      return ExitCode.success.code;
    }
  }
}
