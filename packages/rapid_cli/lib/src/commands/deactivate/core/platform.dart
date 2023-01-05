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
    FlutterPubRunBuildRunnerBuildDeleteConflictingOutputsCommand?
        flutterPubRunBuildRunnerBuildDeleteConflictingOutputs,
  })  : _platform = platform,
        _logger = logger ?? Logger(),
        _project = project,
        _flutterPubRunBuildRunnerBuildDeleteConflictingOutputs =
            flutterPubRunBuildRunnerBuildDeleteConflictingOutputs ??
                Flutter.pubRunBuildRunnerBuildDeleteConflictingOutputs;

  final Platform _platform;
  final Logger _logger;
  final Project _project;
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
          final appPackage = _project.appPackage;
          final appPackagePubspec = appPackage.pubspecFile;
          appPackagePubspec.removeDependencyByPattern(_platform.name);
          for (final mainFile in appPackage.mainFiles) {
            mainFile.removeSetupCodeForPlatform(_platform);
          }

          final diPackage = _project.diPackage;
          final diPackagePubspec = diPackage.pubspecFile;
          diPackagePubspec.removeDependencyByPattern(_platform.name);
          diPackage.injectionFile.removePackagesByPlatform(_platform);
          await _flutterPubRunBuildRunnerBuildDeleteConflictingOutputs(
            cwd: diPackage.path,
          );

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
