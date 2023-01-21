import 'package:rapid_cli/src/commands/core/platform/add/language/language.dart';
import 'package:rapid_cli/src/core/platform.dart';

/// {@template web_add_language_command}
/// `rapid web add language` command adds a language to the Web part of an existing Rapid project.
/// {@endtemplate}
class WebAddLanguageCommand extends PlatformAddLanguageCommand {
  /// {@macro web_add_language_command}
  WebAddLanguageCommand({
    super.logger,
    required super.project,
    super.flutterFormatFix,
  }) : super(
          platform: Platform.web,
        );
}
