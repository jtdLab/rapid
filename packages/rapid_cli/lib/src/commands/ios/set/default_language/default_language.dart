import 'package:rapid_cli/src/commands/core/platform/set/default_language/default_language.dart';
import 'package:rapid_cli/src/core/platform.dart';

/// {@template ios_set_default_language_command}
/// `rapid ios set default_language` command sets the default language of the iOS part of an existing Rapid project.
/// {@endtemplate}
class IosSetDefaultLanguageCommand extends PlatformSetDefaultLanguageCommand {
  /// {@macro ios_set_default_language_command}
  IosSetDefaultLanguageCommand({
    super.logger,
    required super.project,
    super.flutterGenl10n,
    super.dartFormatFix,
  }) : super(
          platform: Platform.ios,
        );
}
