import 'package:rapid_cli/src/commands/core/platform/set/default_language/default_language.dart';
import 'package:rapid_cli/src/core/platform.dart';

/// {@template web_set_default_language_command}
/// `rapid web set default_language` command sets the default language of the Web part of an existing Rapid project.
/// {@endtemplate}
class WebSetDefaultLanguageCommand extends PlatformSetDefaultLanguageCommand {
  /// {@macro web_set_default_language_command}
  WebSetDefaultLanguageCommand({
    super.logger,
    required super.project,
    super.flutterGenl10n,
    super.dartFormatFix,
  }) : super(
          platform: Platform.web,
        );
}
