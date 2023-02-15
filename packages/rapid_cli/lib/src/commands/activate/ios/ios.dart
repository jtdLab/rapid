import 'package:mason/mason.dart';
import 'package:rapid_cli/src/cli/cli.dart';
import 'package:rapid_cli/src/commands/activate/core/platform.dart';
import 'package:rapid_cli/src/commands/activate/core/platform_is_deactivated.dart';
import 'package:rapid_cli/src/commands/core/language_option.dart';
import 'package:rapid_cli/src/commands/core/org_name_option.dart';
import 'package:rapid_cli/src/commands/core/run_when.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/project/project.dart';
import 'package:rapid_cli/src/commands/core/platform_x.dart';

/// {@template activate_ios_command}
/// `rapid activate ios` command adds support for iOS to an existing Rapid project.
/// {@endtemplate}
class ActivateIosCommand extends ActivatePlatformCommand
    with OrgNameGetter, LanguageGetter {
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
    argParser
      ..addOrgNameOption(
        help: 'The organization for the native iOS project.',
      )
      ..addLanguageOption(
        help: 'The default language for iOS',
      );
  }

  final Logger _logger;
  final Project _project;
  final FlutterConfigEnablePlatformCommand _flutterConfigEnableIos;

  @override
  Future<int> run() => runWhen(
        [
          projectExistsAll(_project),
          platformIsDeactivated(platform, _project),
        ],
        _logger,
        () async {
          final orgName = super.orgName;
          final language = super.language;

          _logger.info('Activating ${platform.prettyName} ...');

          await _project.addPlatform(
            platform,
            orgName: orgName,
            language: language,
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
