import 'package:rapid_cli/src/commands/core/platform/set/default_language/default_language.dart';
import 'package:rapid_cli/src/core/platform.dart';

/// {@template android_set_default_language_command}
/// `rapid android set default_language` command sets the default language of the Android part of an existing Rapid project.
/// {@endtemplate}
class AndroidSetDefaultLanguageCommand
    extends PlatformSetDefaultLanguageCommand {
  /// {@macro android_set_default_language_command}
  AndroidSetDefaultLanguageCommand({
    super.logger,
    required super.project,
    super.flutterGenl10n,
    super.dartFormatFix,
  }) : super(
          platform: Platform.android,
        );
}
