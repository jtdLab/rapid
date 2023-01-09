import 'package:args/command_runner.dart';
import 'package:mason/mason.dart';
import 'package:rapid_cli/src/cli/cli.dart';
import 'package:rapid_cli/src/commands/core/overridable_arg_results.dart';
import 'package:rapid_cli/src/commands/core/run_when_cwd_has_melos.dart';
import 'package:rapid_cli/src/commands/deactivate/android/android.dart';
import 'package:rapid_cli/src/commands/deactivate/ios/ios.dart';
import 'package:rapid_cli/src/commands/deactivate/linux/linux.dart';
import 'package:rapid_cli/src/commands/deactivate/macos/macos.dart';
import 'package:rapid_cli/src/commands/deactivate/web/web.dart';
import 'package:rapid_cli/src/commands/deactivate/windows/windows.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/project/project.dart';

/// {@template deactivate_platform_command}
/// Base class for:
///
///  * [DeactivateAndroidCommand]
///
///  * [DeactivateIosCommand]
///
///  * [DeactivateLinuxCommand]
///
///  * [DeactivateMacosCommand]
///
///  * [DeactivateWebCommand]
///
///  * [DeactivateWindowsCommand]
/// {@endtemplate}
abstract class DeactivatePlatformCommand extends Command<int>
    with OverridableArgResults {
  /// {@macro deactivate_platform_command}
  DeactivatePlatformCommand({
    required Platform platform,
    Logger? logger,
    required Project project,
    FlutterPubGetCommand? flutterPubGet,
    FlutterPubRunBuildRunnerBuildDeleteConflictingOutputsCommand?
        flutterPubRunBuildRunnerBuildDeleteConflictingOutputs,
  })  : _platform = platform,
        _logger = logger ?? Logger(),
        _project = project,
        _flutterPubGet = flutterPubGet ?? Flutter.pubGet,
        _flutterPubRunBuildRunnerBuildDeleteConflictingOutputs =
            flutterPubRunBuildRunnerBuildDeleteConflictingOutputs ??
                Flutter.pubRunBuildRunnerBuildDeleteConflictingOutputs;

  final Platform _platform;
  final Logger _logger;
  final Project _project;
  final FlutterPubGetCommand _flutterPubGet;
  final FlutterPubRunBuildRunnerBuildDeleteConflictingOutputsCommand
      _flutterPubRunBuildRunnerBuildDeleteConflictingOutputs;

  @override
  String get name => _platform.name;

  @override
  List<String> get aliases => _platform.aliases;

  @override
  String get invocation => 'rapid deactivate ${_platform.name}';

  @override
  String get description =>
      'Removes support for ${_platform.prettyName} from this project.';

  @override
  Future<int> run() => runWhenCwdHasMelos(_project, _logger, () async {
        final platformIsActivated = _project.isActivated(_platform);

        if (platformIsActivated) {
          _logger.info(
            'Deactivating ${lightYellow.wrap(_platform.prettyName)} ...',
          );

          final appPackage = _project.appPackage;
          final appUpdatePackageProgress =
              _logger.progress('Updating package ${appPackage.path} ');
          final appPackagePubspec = appPackage.pubspecFile;
          appPackagePubspec.removeDependencyByPattern(_platform.name);
          for (final mainFile in appPackage.mainFiles) {
            mainFile.removeSetupForPlatform(_platform);
          }
          await _flutterPubGet(cwd: appPackage.path);
          appPackage.platformDirectory(_platform).deleteSync(recursive: true);
          appUpdatePackageProgress.complete();

          final diPackage = _project.diPackage;
          final diUpdatePackageProgress =
              _logger.progress('Updating package ${diPackage.path} ');
          final diPackagePubspec = diPackage.pubspecFile;
          diPackagePubspec.removeDependencyByPattern(_platform.name);
          diPackage.injectionFile.removePackagesByPlatform(_platform);
          await _flutterPubGet(cwd: diPackage.path);
          await _flutterPubRunBuildRunnerBuildDeleteConflictingOutputs(
            cwd: diPackage.path,
          );
          diUpdatePackageProgress.complete();

          final platformDirectory = _project.platformDirectory(_platform);
          platformDirectory.delete();

          final platformUiPackage = _project.platformUiPackage(_platform);
          platformUiPackage.delete();

          _logger.success('${_platform.prettyName} is now deactivated.');

          return ExitCode.success.code;
        } else {
          _logger.err('${_platform.prettyName} already deactivated.');

          return ExitCode.config.code;
        }
      });
}
