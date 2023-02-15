import 'package:mason/mason.dart';
import 'package:rapid_cli/src/cli/cli.dart';
import 'package:rapid_cli/src/commands/activate/core/platform.dart';
import 'package:rapid_cli/src/commands/activate/core/platform_is_deactivated.dart';
import 'package:rapid_cli/src/commands/core/language_option.dart';
import 'package:rapid_cli/src/commands/core/org_name_option.dart';
import 'package:rapid_cli/src/commands/core/platform_x.dart';
import 'package:rapid_cli/src/commands/core/run_when.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/project/project.dart';

/// {@template activate_macos_command}
/// `rapid activate macos` command adds support for macOS to an existing Rapid project.
/// {@endtemplate}
class ActivateMacosCommand extends ActivatePlatformCommand
    with OrgNameGetter, LanguageGetter {
  /// {@macro activate_macos_command}
  ActivateMacosCommand({
    Logger? logger,
    Project? project,
    FlutterConfigEnablePlatformCommand? flutterConfigEnableMacos,
  })  : _logger = logger ?? Logger(),
        _project = project ?? Project(),
        _flutterConfigEnableMacos =
            flutterConfigEnableMacos ?? Flutter.configEnableMacos,
        super(platform: Platform.macos) {
    argParser
      ..addOrgNameOption(
        help: 'The organization for the native macOS project.',
      )
      ..addLanguageOption(
        help: 'The default language for macOS',
      );
  }

  final Logger _logger;
  final Project _project;
  final FlutterConfigEnablePlatformCommand _flutterConfigEnableMacos;

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

          await _flutterConfigEnableMacos(logger: _logger);

          _logger
            ..info('')
            ..success('${platform.prettyName} activated!');

          return ExitCode.success.code;
        },
      );
}
