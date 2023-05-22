import 'package:rapid_cli/src/commands/core/platform/set/default_language/default_language.dart';
import 'package:rapid_cli/src/core/platform.dart';

/// {@template mobile_set_default_language_command}
/// `rapid mobile set default_language` command sets the default language of the Mobile part of an existing Rapid project.
/// {@endtemplate}
class MobileSetDefaultLanguageCommand extends PlatformSetDefaultLanguageCommand {
  /// {@macro mobile_set_default_language_command}
  MobileSetDefaultLanguageCommand({
    super.logger,
    super.project,
    super.flutterGenl10n,
    super.dartFormatFix,
  }) : super(
          platform: Platform.mobile,
        );
}
