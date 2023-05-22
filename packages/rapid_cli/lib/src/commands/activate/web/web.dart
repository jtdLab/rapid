import 'package:rapid_cli/src/cli/cli.dart';
import 'package:rapid_cli/src/commands/activate/core/platform.dart';
import 'package:rapid_cli/src/commands/core/language_option.dart';
import 'package:rapid_cli/src/commands/core/org_name_option.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/project/platform_directory/platform_directory.dart';
import 'package:rapid_cli/src/project/project.dart';

/// The default description.
const _defaultDescription = 'A Rapid app.';

/// {@template activate_web_command}
/// `rapid activate web` command adds support for Web to an existing Rapid project.
/// {@endtemplate}
class ActivateWebCommand extends ActivatePlatformCommand
    with OrgNameGetter, LanguageGetter {
  /// {@macro activate_web_command}
  ActivateWebCommand({
    super.logger,
    super.project,
    super.melosBootstrap,
    super.flutterPubGet,
    super.flutterPubRunBuildRunnerBuildDeleteConflictingOutputs,
    super.flutterGenl10n,
    super.dartFormatFix,
    FlutterConfigEnablePlatformCommand? flutterConfigEnableWeb,
  }) : super(
          platform: Platform.web,
          flutterConfigEnablePlatforms: [
            flutterConfigEnableWeb ?? Flutter.configEnableWeb,
          ],
        ) {
    argParser
      ..addOption(
        'desc',
        help: 'The description for the native Web project.',
        defaultsTo: _defaultDescription,
      )
      ..addLanguageOption(
        help: 'The default language for Web',
      );
  }

  @override
  Future<PlatformDirectory> createPlatformDirectory({
    required Project project,
  }) async {
    final description = _description;
    final language = super.language;

    final platformDirectory =
        project.platformDirectory<NoneIosDirectory>(platform: platform);
    await platformDirectory.create(
      description: description,
      language: language,
    );

    return platformDirectory;
  }

  /// Gets the description for the project specified by the user.
  String get _description => argResults['desc'] ?? _defaultDescription;
}
