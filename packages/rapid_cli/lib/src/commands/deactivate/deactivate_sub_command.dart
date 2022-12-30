import 'package:args/command_runner.dart';
import 'package:mason/mason.dart';
import 'package:rapid_cli/src/cli/cli.dart';
import 'package:rapid_cli/src/commands/core/overridable_arg_results.dart';
import 'package:rapid_cli/src/commands/deactivate/deactivate.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/project/project.dart';

// TODO sort vars and methods alphabetically

/// Base class for all subcommands of [DeactivateCommand].
abstract class DeactivateSubCommand extends Command<int>
    with OverridableArgResults {
  DeactivateSubCommand({
    required Platform platform,
    required Logger logger,
    required Project project,
    required FlutterPubRunBuildRunnerBuildDeleteConflictingOutputsCommand
        flutterPubRunBuildRunnerBuildDeleteConflictingOutputs,
  })  : _platform = platform,
        _logger = logger,
        _project = project,
        _flutterPubRunBuildRunnerBuildDeleteConflictingOutputs =
            flutterPubRunBuildRunnerBuildDeleteConflictingOutputs;

  final Platform _platform;
  final Logger _logger;
  final Project _project;
  final FlutterPubRunBuildRunnerBuildDeleteConflictingOutputsCommand
      _flutterPubRunBuildRunnerBuildDeleteConflictingOutputs;

  @override
  String get description =>
      'Removes support for ${_platform.prettyName} from this project.';

  @override
  String get invocation => 'rapid deactivate ${_platform.name}';

  @override
  String get name => _platform.name;

  @override
  List<String> get aliases => _platform.aliases;

  @override
  Future<int> run() async {
    final platformIsActivated = _project.isActivated(_platform);

    if (platformIsActivated) {
      final appPackage = _project.appPackage;
      final appPackagePubspec = appPackage.pubspecFile;
      appPackagePubspec.removeDependencyByPattern(_platform.name);
      for (final mainFile in appPackage.mainFiles) {
        mainFile.removePlatform(_platform);
      }

      final diPackage = _project.diPackage;
      final diPackagePubspec = diPackage.pubspecFile;
      diPackagePubspec.removeDependencyByPattern(_platform.name);
      diPackage.injectionFile.removePlatform(_platform);
      await _flutterPubRunBuildRunnerBuildDeleteConflictingOutputs(
        cwd: diPackage.path,
      );

      final platformDirectory = _project.platformDirectory(_platform);
      platformDirectory.deleteSync(recursive: true);

      final platformUiPackage = _project.platformUiPackage(_platform);
      platformUiPackage.delete();

      _logger.success('${_platform.prettyName} is now deactivated.');

      return ExitCode.success.code;
    } else {
      _logger.err('${_platform.prettyName} already deactivated.');

      return ExitCode.config.code;
    }
  }
}
