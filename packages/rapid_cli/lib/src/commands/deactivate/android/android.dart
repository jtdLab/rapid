import 'package:args/command_runner.dart';
import 'package:mason/mason.dart';
import 'package:rapid_cli/src/cli/cli.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/core/project.dart';

/// {@template deactivate_android_command}
/// `rapid deactivate android` command removes support for Android from an existing Rapid project.
/// {@endtemplate}
class AndroidCommand extends Command<int> {
  AndroidCommand({
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
  String get description => 'Removes support for Android from this project.';

  @override
  String get invocation => 'rapid deactivate android';

  @override
  String get name => 'android';

  @override
  List<String> get aliases => ['a'];

  @override
  Future<int> run() async {
    // TODO needs pub get run after the pubspec are added and before other cmd run in the package
    // TODO remove native platform folder from appPackage

    final platformIsActivated = _project.isActivated(Platform.android);

    if (platformIsActivated) {
      final appPackage = _project.appPackage;
      final appPackagePubspec = appPackage.pubspecFile;
      appPackagePubspec.removeDependencyByPattern('android');
      for (final mainFile in appPackage.mainFiles) {
        mainFile.removePlatform(Platform.android);
      }

      final diPackage = _project.diPackage;
      final diPackagePubspec = diPackage.pubspecFile;
      diPackagePubspec.removeDependencyByPattern('android');
      final packages =
          diPackage.injectionFile.getPackagesByPlatform(Platform.android);
      for (final package in packages) {
        diPackage.injectionFile.removePackage(package);
      }
      await _flutterPubRunBuildRunnerBuildDeleteConflictingOutputs(
        cwd: diPackage.path,
      );

      final platformDir = _project.platformDir(Platform.android);
      platformDir.delete();

      final platformUiPackage = _project.platformUiPackage(Platform.android);
      platformUiPackage.delete();

      _logger.success('Android is now deactivated.');

      return ExitCode.success.code;
    } else {
      _logger.err('Android already deactivated.');

      return ExitCode.config.code;
    }
  }
}
