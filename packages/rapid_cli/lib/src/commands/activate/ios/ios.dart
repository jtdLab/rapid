import 'package:rapid_cli/src/cli/cli.dart';
import 'package:rapid_cli/src/commands/activate/core/platform.dart';
import 'package:rapid_cli/src/commands/core/language_option.dart';
import 'package:rapid_cli/src/commands/core/org_name_option.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/project/platform_directory/platform_directory.dart';
import 'package:rapid_cli/src/project/project.dart';

/// {@template activate_ios_command}
/// `rapid activate ios` command adds support for iOS to an existing Rapid project.
/// {@endtemplate}
class ActivateIosCommand extends ActivatePlatformCommand
    with OrgNameGetter, LanguageGetter {
  /// {@macro activate_ios_command}
  ActivateIosCommand({
    super.logger,
    super.project,
    super.melosBootstrap,
    super.flutterPubGet,
    super.flutterPubRunBuildRunnerBuildDeleteConflictingOutputs,
    super.flutterGenl10n,
    super.dartFormatFix,
    FlutterConfigEnablePlatformCommand? flutterConfigEnableIos,
  }) : super(
          platform: Platform.ios,
          flutterConfigEnablePlatforms: [
            flutterConfigEnableIos ?? Flutter.configEnableIos,
          ],
        ) {
    argParser
      ..addOrgNameOption(
        help: 'The organization for the native iOS project.',
      )
      ..addLanguageOption(
        help: 'The default language for iOS',
      );
  }

  @override
  Future<PlatformDirectory> createPlatformDirectory({
    required Project project,
  }) async {
    final orgName = super.orgName;
    final language = super.language;

    final platformDirectory =
        project.platformDirectory<IosDirectory>(platform: platform);
    await platformDirectory.create(
      orgName: orgName,
      language: language,
    );

    return platformDirectory;
  }
}
