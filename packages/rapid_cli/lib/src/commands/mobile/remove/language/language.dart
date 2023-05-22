import 'package:rapid_cli/src/commands/core/platform/remove/language/language.dart';
import 'package:rapid_cli/src/core/platform.dart';

/// {@template mobile_remove_language_command}
/// `rapid mobile remove language` command removes a language from the Mobile part of an existing Rapid project.
/// {@endtemplate}
class MobileRemoveLanguageCommand extends PlatformRemoveLanguageCommand {
  /// {@macro mobile_remove_language_command}
  MobileRemoveLanguageCommand({
    super.logger,
    super.project,
    super.flutterGenl10n,
    super.dartFormatFix,
  }) : super(
          platform: Platform.mobile,
        );
}
