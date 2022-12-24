import 'package:args/command_runner.dart';
import 'package:mason/mason.dart';
import 'package:rapid_cli/src/cli/cli.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/core/project.dart';

/// {@template deactivate_linux_command}
/// `rapid deactivate linux` command removes support for Linux from an existing Rapid project.
/// {@endtemplate}
class LinuxCommand extends Command<int> {
  LinuxCommand({
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
  String get description => 'Removes support for Linux from this project.';

  @override
  String get invocation => 'rapid deactivate linux';

  @override
  String get name => 'linux';

  @override
  List<String> get aliases => ['lin', 'l'];

  @override
  Future<int> run() async {
    final platformIsActivated = _project.isActivated(Platform.linux);

    if (platformIsActivated) {
      final appPackage = _project.appPackage;
      final appPackagePubspec = appPackage.pubspecFile;
      appPackagePubspec.removeDependencyByPattern('linux');
      for (final mainFile in appPackage.mainFiles) {
        mainFile.removePlatform(Platform.linux);
      }

      final diPackage = _project.diPackage;
      final diPackagePubspec = diPackage.pubspecFile;
      diPackagePubspec.removeDependencyByPattern('linux');
      final packages =
          diPackage.injectionFile.getPackagesByPlatform(Platform.linux);
      for (final package in packages) {
        diPackage.injectionFile.removePackage(package);
      }
      await _flutterPubRunBuildRunnerBuildDeleteConflictingOutputs(
        cwd: diPackage.path,
      );

      final platformDir = _project.platformDir(Platform.linux);
      platformDir.delete();

      final platformUiPackage = _project.platformUiPackage(Platform.linux);
      platformUiPackage.delete();

      _logger.success('Linux is now deactivated.');

      return ExitCode.success.code;
    } else {
      _logger.err('Linux already deactivated.');

      return ExitCode.config.code;
    }
  }
}
