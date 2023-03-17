import 'package:rapid_cli/src/commands/core/platform/set/default_language/default_language.dart';
import 'package:rapid_cli/src/core/platform.dart';

/// {@template macos_set_default_language_command}
/// `rapid macos set default_language` command sets the default language of the macOS part of an existing Rapid project.
/// {@endtemplate}
class MacosSetDefaultLanguageCommand extends PlatformSetDefaultLanguageCommand {
  /// {@macro macos_set_default_language_command}
  MacosSetDefaultLanguageCommand({
    super.logger,
    required super.project,
    super.flutterGenl10n,
    super.dartFormatFix,
  }) : super(
          platform: Platform.macos,
        );
}
