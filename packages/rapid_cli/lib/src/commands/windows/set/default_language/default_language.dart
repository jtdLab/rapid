import 'package:rapid_cli/src/commands/core/platform/set/default_language/default_language.dart';
import 'package:rapid_cli/src/core/platform.dart';

/// {@template windows_set_default_language_command}
/// `rapid windows set default_language` command sets the default language of the Windows part of an existing Rapid project.
/// {@endtemplate}
class WindowsSetDefaultLanguageCommand
    extends PlatformSetDefaultLanguageCommand {
  /// {@macro windows_set_default_language_command}
  WindowsSetDefaultLanguageCommand({
    super.logger,
    super.project,
    super.flutterGenl10n,
    super.dartFormatFix,
  }) : super(
          platform: Platform.windows,
        );
}
