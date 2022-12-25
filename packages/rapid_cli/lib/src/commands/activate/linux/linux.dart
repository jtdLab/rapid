import 'package:args/command_runner.dart';
import 'package:mason/mason.dart';
import 'package:rapid_cli/src/cli/cli.dart';
import 'package:rapid_cli/src/commands/activate/linux/linux_bundle.dart';
import 'package:rapid_cli/src/commands/core/generator_builder.dart';
import 'package:rapid_cli/src/commands/core/org_name_option.dart';
import 'package:rapid_cli/src/commands/core/overridable_arg_results.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/core/project.dart';

/// {@template activate_linux_command}
/// `rapid activate linux` command adds support for Linux to an existing Rapid project.
/// {@endtemplate}
class LinuxCommand extends Command<int>
    with OverridableArgResults, OrgNameGetters {
  LinuxCommand({
    Logger? logger,
    required Project project,
    FlutterConfigEnablePlatformCommand? flutterConfigEnableLinux,
    FlutterPubGetCommand? flutterPubGetCommand,
    FlutterPubRunBuildRunnerBuildDeleteConflictingOutputsCommand?
        flutterPubRunBuildRunnerBuildDeleteConflictingOutputs,
    MelosBootstrapCommand? melosBootstrap,
    MelosCleanCommand? melosClean,
    GeneratorBuilder? generator,
  })  : _logger = logger ?? Logger(),
        _project = project,
        _flutterConfigEnableLinux =
            flutterConfigEnableLinux ?? Flutter.configEnableLinux,
        _flutterPubGetCommand = flutterPubGetCommand ?? Flutter.pubGet,
        _flutterPubRunBuildRunnerBuildDeleteConflictingOutputs =
            flutterPubRunBuildRunnerBuildDeleteConflictingOutputs ??
                Flutter.pubRunBuildRunnerBuildDeleteConflictingOutputs,
        _melosBootstrap = melosBootstrap ?? Melos.bootstrap,
        _melosClean = melosClean ?? Melos.clean,
        _generator = generator ?? MasonGenerator.fromBundle {
    argParser.addOrgNameOption(
      help: 'The organization for the native Linux project.',
    );
  }

  final Logger _logger;
  final Project _project;
  final FlutterConfigEnablePlatformCommand _flutterConfigEnableLinux;
  final FlutterPubGetCommand _flutterPubGetCommand;
  final FlutterPubRunBuildRunnerBuildDeleteConflictingOutputsCommand
      _flutterPubRunBuildRunnerBuildDeleteConflictingOutputs;
  final MelosBootstrapCommand _melosBootstrap;
  final MelosCleanCommand _melosClean;
  final GeneratorBuilder _generator;

  @override
  String get description => 'Adds support for Linux to this project.';

  @override
  String get invocation => 'rapid activate linux';

  @override
  String get name => 'linux';

  @override
  List<String> get aliases => ['lin', 'l'];

  @override
  Future<int> run() async {
    final platformIsActivated = _project.isActivated(Platform.linux);

    if (platformIsActivated) {
      _logger.err('Linux is already activated.');

      return ExitCode.config.code;
    } else {
      _logger.info('Activating ${lightYellow.wrap('Linux')} ...');

      final enableLinuxProgress = _logger.progress(
        'Running "flutter config --enable-linux-desktop"',
      );
      await _flutterConfigEnableLinux();
      enableLinuxProgress.complete();

      final projectName = _project.melosFile.name;

      final generateProgress = _logger.progress('Generating Linux files');
      final generator = await _generator(linuxBundle);
      final files = await generator.generate(
        DirectoryGeneratorTarget(_project.rootDir.directory),
        vars: {
          'project_name': projectName,
          'org_name': orgName,
        },
        logger: _logger,
      );
      generateProgress.complete('Generated ${files.length} Linux file(s)');

      final appPackage = _project.appPackage;
      final appUpdatePackageProgress =
          _logger.progress('Updating package ${appPackage.path} ');
      final appPackagePubspec = appPackage.pubspecFile;
      appPackagePubspec.addDependency('${projectName}_linux_app');
      for (final mainFile in appPackage.mainFiles) {
        mainFile.addPlatform(Platform.linux);
      }
      appUpdatePackageProgress.complete();

      final diPackage = _project.diPackage;
      final diUpdatePackageProgress =
          _logger.progress('Updating package ${diPackage.path} ');
      final diPackagePubspec = diPackage.pubspecFile;
      final package = '${projectName}_linux_home_page';
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

      _logger.info('${lightYellow.wrap('Linux')} activated!');

      return ExitCode.success.code;
    }
  }
}
