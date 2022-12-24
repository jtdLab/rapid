import 'package:args/command_runner.dart';
import 'package:mason/mason.dart';
import 'package:rapid_cli/src/cli/cli.dart';
import 'package:rapid_cli/src/commands/activate/android/android_bundle.dart';
import 'package:rapid_cli/src/commands/core/generator_builder.dart';
import 'package:rapid_cli/src/commands/core/org_name_option.dart';
import 'package:rapid_cli/src/commands/core/overridable_arg_results.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/core/project.dart';

/// {@template activate_android_command}
/// `rapid activate android` command adds support for Android to an existing Rapid project.
/// {@endtemplate}
class AndroidCommand extends Command<int>
    with OverridableArgResults, OrgNameGetters {
  AndroidCommand({
    Logger? logger,
    required Project project,
    FlutterConfigEnablePlatformCommand? flutterConfigEnableAndroid,
    FlutterPubRunBuildRunnerBuildDeleteConflictingOutputsCommand?
        flutterPubRunBuildRunnerBuildDeleteConflictingOutputs,
    MelosBootstrapCommand? melosBootstrap,
    MelosCleanCommand? melosClean,
    GeneratorBuilder? generator,
  })  : _logger = logger ?? Logger(),
        _project = project,
        _flutterConfigEnableAndroid =
            flutterConfigEnableAndroid ?? Flutter.configEnableAndroid,
        _flutterPubRunBuildRunnerBuildDeleteConflictingOutputs =
            flutterPubRunBuildRunnerBuildDeleteConflictingOutputs ??
                Flutter.pubRunBuildRunnerBuildDeleteConflictingOutputs,
        _melosBootstrap = melosBootstrap ?? Melos.bootstrap,
        _melosClean = melosClean ?? Melos.clean,
        _generator = generator ?? MasonGenerator.fromBundle {
    argParser.addOrgNameOption(
      help: 'The organization for the native Android project.',
    );
  }

  final Logger _logger;
  final Project _project;
  final FlutterConfigEnablePlatformCommand _flutterConfigEnableAndroid;
  final FlutterPubRunBuildRunnerBuildDeleteConflictingOutputsCommand
      _flutterPubRunBuildRunnerBuildDeleteConflictingOutputs;
  final MelosBootstrapCommand _melosBootstrap;
  final MelosCleanCommand _melosClean;
  final GeneratorBuilder _generator;

  @override
  String get description => 'Adds support for Android to this project.';

  @override
  String get invocation => 'rapid activate android';

  @override
  String get name => 'android';

  @override
  List<String> get aliases => ['a'];

  @override
  Future<int> run() async {
    final platformIsActivated = _project.isActivated(Platform.android);

    if (platformIsActivated) {
      _logger.err('Android is already activated.');

      return ExitCode.config.code;
    } else {
      final runProgress = _logger.progress(
        'Activating ${lightYellow.wrap('Android')}',
      );

      await _flutterConfigEnableAndroid();

      final projectName = _project.melosFile.name;

      final generator = await _generator(androidBundle);
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
      appPackagePubspec.addDependency('${projectName}_android_app');
      for (final mainFile in appPackage.mainFiles) {
        mainFile.addPlatform(Platform.android);
      }

      final diPackage = _project.diPackage;
      final diPackagePubspec = diPackage.pubspecFile;
      final package = '${projectName}_android_home_page';
      diPackagePubspec.addDependency(package);
      diPackage.injectionFile.addPackage(package);
      await _flutterPubRunBuildRunnerBuildDeleteConflictingOutputs(
        cwd: diPackage.path,
      );

      await _melosClean(cwd: _project.rootDir.path);
      await _melosBootstrap(cwd: _project.rootDir.path);

      runProgress.complete(
        'Activated ${lightYellow.wrap('Android')}',
      );

      return ExitCode.success.code;
    }
  }
}
