import 'package:mason/mason.dart';
import 'package:rapid_cli/src/cli/cli.dart';
import 'package:rapid_cli/src/commands/activate/core/platform.dart';
import 'package:rapid_cli/src/commands/activate/core/platform_is_deactivated.dart';
import 'package:rapid_cli/src/commands/core/org_name_option.dart';
import 'package:rapid_cli/src/commands/core/run_when.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/project/project.dart';

/// {@template activate_ios_command}
/// `rapid activate ios` command adds support for iOS to an existing Rapid project.
/// {@endtemplate}
class ActivateIosCommand extends ActivatePlatformCommand with OrgNameGetter {
  /// {@macro activate_ios_command}
  ActivateIosCommand({
    Logger? logger,
    Project? project,
    FlutterConfigEnablePlatformCommand? flutterConfigEnableIos,
  })  : _logger = logger ?? Logger(),
        _project = project ?? Project(),
        _flutterConfigEnableIos =
            flutterConfigEnableIos ?? Flutter.configEnableIos,
        super(platform: Platform.ios) {
    argParser.addOrgNameOption(
      help: 'The organization for the native iOS project.',
    );
  }

  final Logger _logger;
  final Project _project;
  final FlutterConfigEnablePlatformCommand _flutterConfigEnableIos;

  @override
  Future<int> run() => runWhen(
        [
          projectExists(_project),
          platformIsDeactivated(platform, _project),
        ],
        _logger,
        () async {
          final orgName = this.orgName;

          await _project.addPlatform(
            platform,
            orgName: orgName,
            logger: _logger,
          );

          await _flutterConfigEnableIos(logger: _logger);

          _logger
            ..info('')
            ..success('${platform.prettyName} activated!');

          return ExitCode.success.code;
        },
      );
}
