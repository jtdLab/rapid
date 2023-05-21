import 'package:rapid_cli/src/cli/cli.dart';
import 'package:rapid_cli/src/commands/activate/core/platform.dart';
import 'package:rapid_cli/src/commands/core/language_option.dart';
import 'package:rapid_cli/src/commands/core/org_name_option.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/project/platform_directory/platform_directory.dart';
import 'package:rapid_cli/src/project/project.dart';

/// {@template activate_linux_command}
/// `rapid activate linux` command adds support for Linux to an existing Rapid project.
/// {@endtemplate}
class ActivateLinuxCommand extends ActivatePlatformCommand
    with OrgNameGetter, LanguageGetter {
  /// {@macro activate_linux_command}
  ActivateLinuxCommand({
    super.logger,
    super.project,
    super.melosBootstrap,
    super.flutterPubGet,
    super.flutterPubRunBuildRunnerBuildDeleteConflictingOutputs,
    super.flutterGenl10n,
    super.dartFormatFix,
    FlutterConfigEnablePlatformCommand? flutterConfigEnableLinux,
  }) : super(
          platform: Platform.linux,
          flutterConfigEnablePlatforms: [
            flutterConfigEnableLinux ?? Flutter.configEnableLinux,
          ],
        ) {
    argParser
      ..addOrgNameOption(
        help: 'The organization for the native Linux project.',
      )
      ..addLanguageOption(
        help: 'The default language for Linux',
      );
  }

  @override
  Future<PlatformDirectory> createPlatformDirectory({
    required Project project,
  }) async {
    final orgName = super.orgName;
    final language = super.language;

    final platformDirectory =
        project.platformDirectory<NoneIosDirectory>(platform: platform);
    await platformDirectory.create(
      orgName: orgName,
      language: language,
    );

    return platformDirectory;
  }
}
