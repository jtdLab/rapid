import 'package:rapid_cli/src/cli/cli.dart';
import 'package:rapid_cli/src/commands/activate/core/platform.dart';
import 'package:rapid_cli/src/commands/core/language_option.dart';
import 'package:rapid_cli/src/commands/core/org_name_option.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/project/platform_directory/platform_directory.dart';
import 'package:rapid_cli/src/project/project.dart';

/// {@template activate_mobile_command}
/// `rapid activate mobile` command adds support for Mobile to an existing Rapid project.
/// {@endtemplate}
class ActivateMobileCommand extends ActivatePlatformCommand
    with OrgNameGetter, LanguageGetter {
  /// {@macro activate_mobile_command}
  ActivateMobileCommand({
    super.logger,
    super.project,
    super.melosBootstrap,
    super.flutterPubGet,
    super.flutterPubRunBuildRunnerBuildDeleteConflictingOutputs,
    super.flutterGenl10n,
    super.dartFormatFix,
    FlutterConfigEnablePlatformCommand? flutterConfigEnableAndroid,
    FlutterConfigEnablePlatformCommand? flutterConfigEnableIos,
  }) : super(
          platform: Platform.mobile,
          flutterConfigEnablePlatforms: [
            flutterConfigEnableAndroid ?? Flutter.configEnableAndroid,
            flutterConfigEnableIos ?? Flutter.configEnableIos,
          ],
        ) {
    argParser
      ..addOrgNameOption(
        help: 'The organization for the native Mobile project.',
      )
      ..addLanguageOption(
        help: 'The default language for Mobile',
      );
  }

  @override
  Future<PlatformDirectory> createPlatformDirectory({
    required Project project,
  }) async {
    final orgName = super.orgName;
    final language = super.language;

    final platformDirectory =
        project.platformDirectory<MobileDirectory>(platform: platform);
    await platformDirectory.create(
      orgName: orgName,
      language: language,
      // TODO maybe pass a description ?
    );

    return platformDirectory;
  }
}
