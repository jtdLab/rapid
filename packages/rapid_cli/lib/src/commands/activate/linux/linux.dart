import 'package:mason/mason.dart';
import 'package:rapid_cli/src/cli/cli.dart';
import 'package:rapid_cli/src/commands/activate/core/platform.dart';
import 'package:rapid_cli/src/commands/activate/core/platform_is_deactivated.dart';
import 'package:rapid_cli/src/commands/core/org_name_option.dart';
import 'package:rapid_cli/src/commands/core/run_when.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/project/project.dart';

/// {@template activate_linux_command}
/// `rapid activate linux` command adds support for Linux to an existing Rapid project.
/// {@endtemplate}
class ActivateLinuxCommand extends ActivatePlatformCommand with OrgNameGetter {
  /// {@macro activate_linux_command}
  ActivateLinuxCommand({
    Logger? logger,
    Project? project,
    FlutterConfigEnablePlatformCommand? flutterConfigEnableLinux,
  })  : _logger = logger ?? Logger(),
        _project = project ?? Project(),
        _flutterConfigEnableLinux =
            flutterConfigEnableLinux ?? Flutter.configEnableLinux,
        super(platform: Platform.linux) {
    argParser.addOrgNameOption(
      help: 'The organization for the native Linux project.',
    );
  }

  final Logger _logger;
  final Project _project;
  final FlutterConfigEnablePlatformCommand _flutterConfigEnableLinux;

  @override
  Future<int> run() => runWhen(
        [
          projectExists(_project),
          platformIsDeactivated(platform, _project),
        ],
        _logger,
        () async {
          final orgName = this.orgName;

          _logger.info('Activating ${platform.prettyName} ...');

          await _project.addPlatform(
            platform,
            orgName: orgName,
            logger: _logger,
          );

          await _flutterConfigEnableLinux(logger: _logger);

          _logger
            ..info('')
            ..success('${platform.prettyName} activated!');

          return ExitCode.success.code;
        },
      );
}
