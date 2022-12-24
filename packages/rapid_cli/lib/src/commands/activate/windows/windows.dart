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
    FlutterPubRunBuildRunnerBuildDeleteConflictingOutputsCommand?
        flutterPubRunBuildRunnerBuildDeleteConflictingOutputs,
    MelosBootstrapCommand? melosBootstrap,
    MelosCleanCommand? melosClean,
    GeneratorBuilder? generator,
  })  : _logger = logger ?? Logger(),
        _project = project,
        _flutterConfigEnableWindows =
            flutterConfigEnableWindows ?? Flutter.configEnableWindows,
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
      final runProgress = _logger.progress(
        'Activating ${lightYellow.wrap('Windows')}',
      );

      await _flutterConfigEnableWindows();

      final projectName = _project.melosFile.name;

      final generator = await _generator(windowsBundle);
      await generator.generate(
        DirectoryGeneratorTarget(_project.rootDir.directory),
        vars: {
          'project_name': projectName,
          'org_name': orgName,
        },
        logger: _logger,
      );

      final appPackage = _project.appPackage;
      final appPackagePubspec = appPackage.pubspecFile;
      appPackagePubspec.addDependency('${projectName}_windows_app');
      for (final mainFile in appPackage.mainFiles) {
        mainFile.addPlatform(Platform.windows);
      }

      final diPackage = _project.diPackage;
      final diPackagePubspec = diPackage.pubspecFile;
      final package = '${projectName}_windows_home_page';
      diPackagePubspec.addDependency(package);
      diPackage.injectionFile.addPackage(package);
      await _flutterPubRunBuildRunnerBuildDeleteConflictingOutputs(
        cwd: diPackage.path,
      );

      await _melosClean(cwd: _project.rootDir.path);
      await _melosBootstrap(cwd: _project.rootDir.path);

      runProgress.complete(
        'Activated ${lightYellow.wrap('Windows')}',
      );

      return ExitCode.success.code;
    }
  }
}
