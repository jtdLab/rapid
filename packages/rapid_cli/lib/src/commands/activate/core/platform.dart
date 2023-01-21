import 'package:args/command_runner.dart';
import 'package:mason/mason.dart';
import 'package:rapid_cli/src/cli/cli.dart';
import 'package:rapid_cli/src/commands/activate/android/android.dart';
import 'package:rapid_cli/src/commands/activate/ios/ios.dart';
import 'package:rapid_cli/src/commands/activate/linux/linux.dart';
import 'package:rapid_cli/src/commands/activate/macos/macos.dart';
import 'package:rapid_cli/src/commands/activate/web/web.dart';
import 'package:rapid_cli/src/commands/activate/windows/windows.dart';
import 'package:rapid_cli/src/commands/core/overridable_arg_results.dart';
import 'package:rapid_cli/src/commands/core/run_when.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/project/project.dart';

/// {@template activate_platform_command}
/// Base class for:
///
///  * [ActivateAndroidCommand]
///
///  * [ActivateIosCommand]
///
///  * [ActivateLinuxCommand]
///
///  * [ActivateMacosCommand]
///
///  * [ActivateWebCommand]
///
///  * [ActivateWindowsCommand]
/// {@endtemplate}
abstract class ActivatePlatformCommand extends Command<int>
    with OverridableArgResults {
  /// {@macro activate_platform_command}
  ActivatePlatformCommand({
    required Platform platform,
    Logger? logger,
    required Project project,
    FlutterConfigEnablePlatformCommand? flutterConfigEnablePlatform,
    MelosBootstrapCommand? melosBootstrap,
    MelosCleanCommand? melosClean,
    FlutterFormatFixCommand? flutterFormatFix,
  })  : _platform = platform,
        _logger = logger ?? Logger(),
        _project = project,
        _flutterConfigEnablePlatform =
            flutterConfigEnablePlatform ?? Flutter.configEnableAndroid,
        _melosBootstrap = melosBootstrap ?? Melos.bootstrap,
        _melosClean = melosClean ?? Melos.clean,
        _flutterFormatFix = flutterFormatFix ?? Flutter.formatFix;

  final Platform _platform;
  final Logger _logger;
  final Project _project;
  final FlutterConfigEnablePlatformCommand _flutterConfigEnablePlatform;
  final MelosBootstrapCommand _melosBootstrap;
  final MelosCleanCommand _melosClean;
  final FlutterFormatFixCommand _flutterFormatFix;

  @override
  String get name => _platform.name;

  @override
  List<String> get aliases => _platform.aliases;

  @override
  String get invocation => 'rapid activate ${_platform.name}';

  @override
  String get description =>
      'Adds support for ${_platform.prettyName} to this project.';

  Future<void> activatePlatform(
    Platform platform, {
    required Project project,
    required Logger logger,
  });

  @override
  Future<int> run() => runWhen(
        [
          isProjectRoot(_project),
          _platformIsDeactivated(_platform, _project),
        ],
        _logger,
        () async {
          await _flutterConfigEnablePlatform(logger: _logger);

          _logger.info(
            'Activating ${lightYellow.wrap(_platform.prettyName)} ...',
          );

          await activatePlatform(_platform, project: _project, logger: _logger);

          // TODO can melos bs and clean made scoped or must be here?
          //await _melosClean(logger: _logger);

          //await _melosBootstrap(logger: _logger);

          //await _flutterFormatFix(logger: _logger);

          _logger.info('${lightYellow.wrap(_platform.prettyName)} activated!');

          return ExitCode.success.code;
        },
      );

  /// Completes when [platform] is deactivated in [project].
  Future<void> _platformIsDeactivated(
      Platform platform, Project project) async {
    final platformIsActivated = project.platformIsActivated(platform);

    if (platformIsActivated) {
      throw EnvironmentException(
        ExitCode.config.code,
        '${platform.prettyName} is already activated.',
      );
    }
  }
}
