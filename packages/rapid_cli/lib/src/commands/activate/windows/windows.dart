import 'package:args/command_runner.dart';
import 'package:mason/mason.dart';
import 'package:rapid_cli/src/cli/cli.dart';
import 'package:rapid_cli/src/commands/activate/windows/windows_bundle.dart';
import 'package:rapid_cli/src/commands/core/generator_builder.dart';
import 'package:rapid_cli/src/commands/core/org_name_option.dart';
import 'package:rapid_cli/src/commands/core/overridable_arg_results.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/core/project.dart';

/// {@template activate_windows_command}
/// `rapid activate windows` command adds support for Windows to an existing Rapid project.
/// {@endtemplate}
class WindowsCommand extends Command<int>
    with OverridableArgResults, OrgNameGetters {
  WindowsCommand({
    Logger? logger,
    required Project project,
    FlutterConfigEnablePlatformCommand? flutterConfigEnableWindows,
    FlutterPubGetCommand? flutterPubGetCommand,
    FlutterPubRunBuildRunnerBuildDeleteConflictingOutputsCommand?
        flutterPubRunBuildRunnerBuildDeleteConflictingOutputs,
    MelosBootstrapCommand? melosBootstrap,
    MelosCleanCommand? melosClean,
    GeneratorBuilder? generator,
  })  : _logger = logger ?? Logger(),
        _project = project,
        _flutterConfigEnableWindows =
            flutterConfigEnableWindows ?? Flutter.configEnableWindows,
        _flutterPubGetCommand = flutterPubGetCommand ?? Flutter.pubGet,
        _flutterPubRunBuildRunnerBuildDeleteConflictingOutputs =
            flutterPubRunBuildRunnerBuildDeleteConflictingOutputs ??
                Flutter.pubRunBuildRunnerBuildDeleteConflictingOutputs,
        _melosBootstrap = melosBootstrap ?? Melos.bootstrap,
        _melosClean = melosClean ?? Melos.clean,
        _generator = generator ?? MasonGenerator.fromBundle {
    argParser.addOrgNameOption(
      help: 'The organization for the native Windows project.',
    );
  }

  final Logger _logger;
  final Project _project;
  final FlutterConfigEnablePlatformCommand _flutterConfigEnableWindows;
  final FlutterPubGetCommand _flutterPubGetCommand;
  final FlutterPubRunBuildRunnerBuildDeleteConflictingOutputsCommand
      _flutterPubRunBuildRunnerBuildDeleteConflictingOutputs;
  final MelosBootstrapCommand _melosBootstrap;
  final MelosCleanCommand _melosClean;
  final GeneratorBuilder _generator;

  @override
  String get description => 'Adds support for Windows to this project.';

  @override
  String get invocation => 'rapid activate windows';

  @override
  String get name => 'windows';

  @override
  List<String> get aliases => ['win'];

  @override
  Future<int> run() async {
    final platformIsActivated = _project.isActivated(Platform.windows);

    if (platformIsActivated) {
      _logger.err('Windows is already activated.');

      return ExitCode.config.code;
    } else {
      _logger.info('Activating ${lightYellow.wrap('Windows')} ...');

      final enableMacosProgress = _logger.progress(
        'Running "flutter config --enable-windows-desktop"',
      );
      await _flutterConfigEnableWindows();
      enableMacosProgress.complete();

      final projectName = _project.melosFile.name;

      final generateProgress = _logger.progress('Generating Windows files');
      final generator = await _generator(windowsBundle);
      final files = await generator.generate(
        DirectoryGeneratorTarget(_project.rootDir.directory),
        vars: {
          'project_name': projectName,
          'org_name': orgName,
        },
        logger: _logger,
      );
      generateProgress.complete('Generated ${files.length} Windows file(s)');

      final appPackage = _project.appPackage;
      final appUpdatePackageProgress =
          _logger.progress('Updating package ${appPackage.path} ');
      final appPackagePubspec = appPackage.pubspecFile;
      appPackagePubspec.addDependency('${projectName}_windows_app');
      for (final mainFile in appPackage.mainFiles) {
        mainFile.addPlatform(Platform.windows);
      }
      appUpdatePackageProgress.complete();

      final diPackage = _project.diPackage;
      final diUpdatePackageProgress =
          _logger.progress('Updating package ${diPackage.path} ');
      final diPackagePubspec = diPackage.pubspecFile;
      final package = '${projectName}_windows_home_page';
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

      _logger.info('${lightYellow.wrap('Windows')} activated!');

      return ExitCode.success.code;
    }
  }
}
