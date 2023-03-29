import 'package:rapid_cli/src/commands/core/platform/remove/language/language.dart';
import 'package:rapid_cli/src/core/platform.dart';

/// {@template web_remove_language_command}
/// `rapid web remove language` command removes a language from the Web part of an existing Rapid project.
/// {@endtemplate}
class WebRemoveLanguageCommand extends PlatformRemoveLanguageCommand {
  /// {@macro web_remove_language_command}
  WebRemoveLanguageCommand({
    super.logger,
    required super.project,
    super.flutterGenl10n,
    super.dartFormatFix,
  }) : super(
          platform: Platform.web,
        );
}
