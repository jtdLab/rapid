import 'package:rapid_cli/src/commands/core/platform/remove/language/language.dart';
import 'package:rapid_cli/src/core/platform.dart';

/// {@template linux_remove_language_command}
/// `rapid linux remove language` command removes a language from the Linux part of an existing Rapid project.
/// {@endtemplate}
class LinuxRemoveLanguageCommand extends PlatformRemoveLanguageCommand {
  /// {@macro linux_remove_language_command}
  LinuxRemoveLanguageCommand({
    super.logger,
    super.project,
    super.flutterGenl10n,
    super.dartFormatFix,
  }) : super(
          platform: Platform.linux,
        );
}
