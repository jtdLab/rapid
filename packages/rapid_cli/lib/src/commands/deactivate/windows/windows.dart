import 'package:args/command_runner.dart';
import 'package:mason/mason.dart';
import 'package:rapid_cli/src/cli/cli.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/core/project.dart';

/// {@template deactivate_windows_command}
/// `rapid deactivate windows` command removes support for Windows from an existing Rapid project.
/// {@endtemplate}
class WindowsCommand extends Command<int> {
  WindowsCommand({
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
  String get description => 'Removes support for Windows from this project.';

  @override
  String get invocation => 'rapid deactivate windows';

  @override
  String get name => 'windows';

  @override
  List<String> get aliases => ['win'];

  @override
  Future<int> run() async {
    final platformIsActivated = _project.isActivated(Platform.windows);

    if (platformIsActivated) {
      final appPackage = _project.appPackage;
      final appPackagePubspec = appPackage.pubspecFile;
      appPackagePubspec.removeDependencyByPattern('windows');
      for (final mainFile in appPackage.mainFiles) {
        mainFile.removePlatform(Platform.windows);
      }

      final diPackage = _project.diPackage;
      final diPackagePubspec = diPackage.pubspecFile;
      diPackagePubspec.removeDependencyByPattern('windows');
      final packages =
          diPackage.injectionFile.getPackagesByPlatform(Platform.windows);
      for (final package in packages) {
        diPackage.injectionFile.removePackage(package);
      }
      await _flutterPubRunBuildRunnerBuildDeleteConflictingOutputs(
        cwd: diPackage.path,
      );

      final platformDir = _project.platformDir(Platform.windows);
      platformDir.delete();

      final platformUiPackage = _project.platformUiPackage(Platform.windows);
      platformUiPackage.delete();

      _logger.success('Windows is now deactivated.');

      return ExitCode.success.code;
    } else {
      _logger.err('Windows already deactivated.');

      return ExitCode.config.code;
    }
  }
}
