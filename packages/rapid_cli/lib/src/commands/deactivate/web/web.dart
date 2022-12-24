import 'package:args/command_runner.dart';
import 'package:mason/mason.dart';
import 'package:rapid_cli/src/cli/cli.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/core/project.dart';

/// {@template deactivate_web_command}
/// `rapid deactivate web` command removes support for Web from an existing Rapid project.
/// {@endtemplate}
class WebCommand extends Command<int> {
  WebCommand({
    Logger? logger,
    required Project project,
    FlutterPubRunBuildRunnerBuildDeleteConflictingOutputsCommand?
        flutterPubRunBuildRunnerBuildDeleteConflictingOutputs,
  })  : _logger = logger ?? Logger(),
        _project = project,
        _flutterPubRunBuildRunnerBuildDeleteConflictingOutputs =
            flutterPubRunBuildRunnerBuildDeleteConflictingOutputs ??
                Flutter.pubRunBuildRunnerBuildDeleteConflictingOutputs;

  final Logger _logger;
  final Project _project;
  final FlutterPubRunBuildRunnerBuildDeleteConflictingOutputsCommand
      _flutterPubRunBuildRunnerBuildDeleteConflictingOutputs;

  @override
  String get description => 'Removes support for Web from this project.';

  @override
  String get invocation => 'rapid deactivate web';

  @override
  String get name => 'web';

  @override
  Future<int> run() async {
    final platformIsActivated = _project.isActivated(Platform.web);

    if (platformIsActivated) {
      final appPackage = _project.appPackage;
      final appPackagePubspec = appPackage.pubspecFile;
      appPackagePubspec.removeDependencyByPattern('web');
      for (final mainFile in appPackage.mainFiles) {
        mainFile.removePlatform(Platform.web);
      }

      final diPackage = _project.diPackage;
      final diPackagePubspec = diPackage.pubspecFile;
      diPackagePubspec.removeDependencyByPattern('web');
      final packages =
          diPackage.injectionFile.getPackagesByPlatform(Platform.web);
      for (final package in packages) {
        diPackage.injectionFile.removePackage(package);
      }
      await _flutterPubRunBuildRunnerBuildDeleteConflictingOutputs(
        cwd: diPackage.path,
      );

      final platformDir = _project.platformDir(Platform.web);
      platformDir.delete();

      final platformUiPackage = _project.platformUiPackage(Platform.web);
      platformUiPackage.delete();

      _logger.success('Web is now deactivated.');

      return ExitCode.success.code;
    } else {
      _logger.err('Web already deactivated.');

      return ExitCode.config.code;
    }
  }
}
