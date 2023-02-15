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

/// {@template activate_android_command}
/// `rapid activate android` command adds support for Android to an existing Rapid project.
/// {@endtemplate}
class ActivateAndroidCommand extends ActivatePlatformCommand
    with OrgNameGetter, LanguageGetter {
  /// {@macro activate_android_command}
  ActivateAndroidCommand({
    Logger? logger,
    Project? project,
    FlutterConfigEnablePlatformCommand? flutterConfigEnableAndroid,
  })  : _logger = logger ?? Logger(),
        _project = project ?? Project(),
        _flutterConfigEnableAndroid =
            flutterConfigEnableAndroid ?? Flutter.configEnableAndroid,
        super(platform: Platform.android) {
    argParser
      ..addOrgNameOption(
        help: 'The organization for the native Android project.',
      )
      ..addLanguageOption(
        help: 'The default language for Android',
      );
  }

  final Logger _logger;
  final Project _project;
  final FlutterConfigEnablePlatformCommand _flutterConfigEnableAndroid;

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

          await _flutterConfigEnableAndroid(logger: _logger);

          _logger
            ..info('')
            ..success('${platform.prettyName} activated!');

          return ExitCode.success.code;
        },
      );
}
