import 'package:args/command_runner.dart';
import 'package:mason/mason.dart';
import 'package:rapid_cli/src/cli/cli.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/core/project.dart';

/// {@template deactivate_ios_command}
/// `rapid deactivate ios` command removes support for iOS from an existing Rapid project.
/// {@endtemplate}
class IosCommand extends Command<int> {
  IosCommand({
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
  String get description => 'Removes support for iOS from this project.';

  @override
  String get invocation => 'rapid deactivate ios';

  @override
  String get name => 'ios';

  @override
  List<String> get aliases => ['i'];

  @override
  Future<int> run() async {
    final platformIsActivated = _project.isActivated(Platform.ios);

    if (platformIsActivated) {
      final appPackage = _project.appPackage;
      final appPackagePubspec = appPackage.pubspecFile;
      appPackagePubspec.removeDependencyByPattern('ios');
      for (final mainFile in appPackage.mainFiles) {
        mainFile.removePlatform(Platform.ios);
      }

      final diPackage = _project.diPackage;
      final diPackagePubspec = diPackage.pubspecFile;
      diPackagePubspec.removeDependencyByPattern('ios');
      final packages =
          diPackage.injectionFile.getPackagesByPlatform(Platform.ios);
      for (final package in packages) {
        diPackage.injectionFile.removePackage(package);
      }
      await _flutterPubRunBuildRunnerBuildDeleteConflictingOutputs(
        cwd: diPackage.path,
      );

      final platformDir = _project.platformDir(Platform.ios);
      platformDir.delete();

      final platformUiPackage = _project.platformUiPackage(Platform.ios);
      platformUiPackage.delete();

      _logger.success('iOS is now deactivated.');

      return ExitCode.success.code;
    } else {
      _logger.err('iOS already deactivated.');

      return ExitCode.config.code;
    }
  }
}
