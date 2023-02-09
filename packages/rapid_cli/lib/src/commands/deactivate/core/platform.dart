import 'package:args/command_runner.dart';
import 'package:mason/mason.dart';
import 'package:rapid_cli/src/commands/core/overridable_arg_results.dart';
import 'package:rapid_cli/src/commands/core/platform_x.dart';
import 'package:rapid_cli/src/commands/core/run_when.dart';
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
    Project? project,
  })  : _platform = platform,
        _logger = logger ?? Logger(),
        _project = project ?? Project();

  final Platform _platform;
  final Logger _logger;
  final Project _project;

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
  Future<int> run() => runWhen(
        [
          projectExists(_project),
          platformIsActivated(
            _platform,
            _project,
            '${_platform.prettyName} is already deactivated.',
          ),
        ],
        _logger,
        () async {
          _logger.info('Deactivating ${_platform.prettyName} ...');

          await _project.removePlatform(_platform, logger: _logger);

          _logger
            ..info('')
            ..success('${_platform.prettyName} is now deactivated.');

          return ExitCode.success.code;
        },
      );
}
