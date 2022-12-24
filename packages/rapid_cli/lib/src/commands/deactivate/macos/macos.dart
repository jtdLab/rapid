import 'package:args/command_runner.dart';
import 'package:mason/mason.dart';
import 'package:rapid_cli/src/cli/cli.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/core/project.dart';

/// {@template deactivate_macos_command}
/// `rapid deactivate macos` command removes support for macOS from an existing Rapid project.
/// {@endtemplate}
class MacosCommand extends Command<int> {
  MacosCommand({
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
  String get description => 'Removes support for macOS from this project.';

  @override
  String get invocation => 'rapid deactivate macos';

  @override
  String get name => 'macos';

  @override
  List<String> get aliases => ['mac', 'm'];

  @override
  Future<int> run() async {
    final platformIsActivated = _project.isActivated(Platform.macos);

    if (platformIsActivated) {
      final appPackage = _project.appPackage;
      final appPackagePubspec = appPackage.pubspecFile;
      appPackagePubspec.removeDependencyByPattern('macos');
      for (final mainFile in appPackage.mainFiles) {
        mainFile.removePlatform(Platform.macos);
      }

      final diPackage = _project.diPackage;
      final diPackagePubspec = diPackage.pubspecFile;
      diPackagePubspec.removeDependencyByPattern('macos');
      final packages =
          diPackage.injectionFile.getPackagesByPlatform(Platform.macos);
      for (final package in packages) {
        diPackage.injectionFile.removePackage(package);
      }
      await _flutterPubRunBuildRunnerBuildDeleteConflictingOutputs(
        cwd: diPackage.path,
      );

      final platformDir = _project.platformDir(Platform.macos);
      platformDir.delete();

      final platformUiPackage = _project.platformUiPackage(Platform.macos);
      platformUiPackage.delete();

      _logger.success('macOS is now deactivated.');

      return ExitCode.success.code;
    } else {
      _logger.err('macOS already deactivated.');

      return ExitCode.config.code;
    }
  }
}
