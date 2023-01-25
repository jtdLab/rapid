import 'package:mason/mason.dart';
import 'package:rapid_cli/src/cli/cli.dart';
import 'package:rapid_cli/src/commands/activate/core/platform.dart';
import 'package:rapid_cli/src/commands/activate/core/platform_is_deactivated.dart';
import 'package:rapid_cli/src/commands/core/org_name_option.dart';
import 'package:rapid_cli/src/commands/core/run_when.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/project/project.dart';

/// The default description.
const _defaultDescription = 'A Rapid app.';

/// {@template activate_web_command}
/// `rapid activate web` command adds support for Web to an existing Rapid project.
/// {@endtemplate}
class ActivateWebCommand extends ActivatePlatformCommand with OrgNameGetter {
  /// {@macro activate_web_command}
  ActivateWebCommand({
    Logger? logger,
    Project? project,
    FlutterConfigEnablePlatformCommand? flutterConfigEnableWeb,
  })  : _logger = logger ?? Logger(),
        _project = project ?? Project(),
        _flutterConfigEnableWeb =
            flutterConfigEnableWeb ?? Flutter.configEnableWeb,
        super(platform: Platform.web) {
    argParser.addOrgNameOption(
      help: 'The organization for the native Web project.',
    );
  }

  final Logger _logger;
  final Project _project;
  final FlutterConfigEnablePlatformCommand _flutterConfigEnableWeb;

  @override
  Future<int> run() => runWhen(
        [
          projectExists(_project),
          platformIsDeactivated(platform, _project),
        ],
        _logger,
        () async {
          final description = _description;

          await _project.addPlatform(
            platform,
            description: description,
            logger: _logger,
          );

          await _flutterConfigEnableWeb(logger: _logger);

          _logger
            ..info('')
            ..success('${platform.prettyName} activated!');

          return ExitCode.success.code;
        },
      );

  /// Gets the description for the project specified by the user.
  String get _description => argResults['desc'] ?? _defaultDescription;
}
