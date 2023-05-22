import 'package:rapid_cli/src/cli/cli.dart';
import 'package:rapid_cli/src/commands/activate/core/platform.dart';
import 'package:rapid_cli/src/commands/core/language_option.dart';
import 'package:rapid_cli/src/commands/core/org_name_option.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/project/platform_directory/platform_directory.dart';
import 'package:rapid_cli/src/project/project.dart';

/// {@template activate_windows_command}
/// `rapid activate windows` command adds support for Windows to an existing Rapid project.
/// {@endtemplate}
class ActivateWindowsCommand extends ActivatePlatformCommand
    with OrgNameGetter, LanguageGetter {
  /// {@macro activate_windows_command}
  ActivateWindowsCommand({
    super.logger,
    super.project,
    super.melosBootstrap,
    super.flutterPubGet,
    super.flutterPubRunBuildRunnerBuildDeleteConflictingOutputs,
    super.flutterGenl10n,
    super.dartFormatFix,
    FlutterConfigEnablePlatformCommand? flutterConfigEnableWindows,
  }) : super(
          platform: Platform.windows,
          flutterConfigEnablePlatforms: [
            flutterConfigEnableWindows ?? Flutter.configEnableWindows,
          ],
        ) {
    argParser
      ..addOrgNameOption(
        help: 'The organization for the native Windows project.',
      )
      ..addLanguageOption(
        help: 'The default language for Windows',
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
