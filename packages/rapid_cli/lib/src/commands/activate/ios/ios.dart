import 'package:args/command_runner.dart';
import 'package:mason/mason.dart';
import 'package:rapid_cli/src/cli/cli.dart';
import 'package:rapid_cli/src/commands/activate/ios/ios_bundle.dart';
import 'package:rapid_cli/src/commands/core/generator_builder.dart';
import 'package:rapid_cli/src/commands/core/org_name_option.dart';
import 'package:rapid_cli/src/commands/core/overridable_arg_results.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/core/project.dart';

/// {@template activate_ios_command}
/// `rapid activate ios` command adds support for iOS to an existing Rapid project.
/// {@endtemplate}
class IosCommand extends Command<int>
    with OverridableArgResults, OrgNameGetters {
  IosCommand({
    Logger? logger,
    required Project project,
    FlutterConfigEnablePlatformCommand? flutterConfigEnableIos,
    FlutterPubGetCommand? flutterPubGetCommand,
    FlutterPubRunBuildRunnerBuildDeleteConflictingOutputsCommand?
        flutterPubRunBuildRunnerBuildDeleteConflictingOutputs,
    MelosBootstrapCommand? melosBootstrap,
    MelosCleanCommand? melosClean,
    GeneratorBuilder? generator,
  })  : _logger = logger ?? Logger(),
        _project = project,
        _flutterConfigEnableIos =
            flutterConfigEnableIos ?? Flutter.configEnableIos,
        _flutterPubGetCommand = flutterPubGetCommand ?? Flutter.pubGet,
        _flutterPubRunBuildRunnerBuildDeleteConflictingOutputs =
            flutterPubRunBuildRunnerBuildDeleteConflictingOutputs ??
                Flutter.pubRunBuildRunnerBuildDeleteConflictingOutputs,
        _melosBootstrap = melosBootstrap ?? Melos.bootstrap,
        _melosClean = melosClean ?? Melos.clean,
        _generator = generator ?? MasonGenerator.fromBundle {
    argParser.addOrgNameOption(
      help: 'The organization for the native iOS project.',
    );
  }

  final Logger _logger;
  final Project _project;
  final FlutterConfigEnablePlatformCommand _flutterConfigEnableIos;
  final FlutterPubGetCommand _flutterPubGetCommand;
  final FlutterPubRunBuildRunnerBuildDeleteConflictingOutputsCommand
      _flutterPubRunBuildRunnerBuildDeleteConflictingOutputs;
  final MelosBootstrapCommand _melosBootstrap;
  final MelosCleanCommand _melosClean;
  final GeneratorBuilder _generator;

  @override
  String get description => 'Adds support for iOS to this project.';

  @override
  String get invocation => 'rapid activate ios';

  @override
  String get name => 'ios';

  @override
  List<String> get aliases => ['i'];

  @override
  Future<int> run() async {
    final platformIsActivated = _project.isActivated(Platform.ios);

    if (platformIsActivated) {
      _logger.err('iOS is already activated.');

      return ExitCode.config.code;
    } else {
      _logger.info('Activating ${lightYellow.wrap('iOS')} ...');

      final enableIosProgress = _logger.progress(
        'Running "flutter config --enable-ios"',
      );
      await _flutterConfigEnableIos();
      enableIosProgress.complete();

      final projectName = _project.melosFile.name;

      final generateProgress = _logger.progress('Generating iOS files');
      final generator = await _generator(iosBundle);
      final files = await generator.generate(
        DirectoryGeneratorTarget(_project.rootDir.directory),
        vars: {
          'project_name': projectName,
          'org_name': orgName,
        },
        logger: _logger,
      );
      generateProgress.complete('Generated ${files.length} iOS file(s)');

      final appPackage = _project.appPackage;
      final appUpdatePackageProgress =
          _logger.progress('Updating package ${appPackage.path} ');
      final appPackagePubspec = appPackage.pubspecFile;
      appPackagePubspec.addDependency('${projectName}_ios_app');
      for (final mainFile in appPackage.mainFiles) {
        mainFile.addPlatform(Platform.ios);
      }
      appUpdatePackageProgress.complete();

      final diPackage = _project.diPackage;
      final diUpdatePackageProgress =
          _logger.progress('Updating package ${diPackage.path} ');
      final diPackagePubspec = diPackage.pubspecFile;
      final package = '${projectName}_ios_home_page';
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

      _logger.info('${lightYellow.wrap('iOS')} activated!');

      return ExitCode.success.code;
    }
  }
}
