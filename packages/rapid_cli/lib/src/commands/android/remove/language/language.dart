import 'package:rapid_cli/src/commands/core/platform/remove/language/language.dart';
import 'package:rapid_cli/src2/core/platform.dart';

/// {@template android_remove_language_command}
/// `rapid android remove language` command removes a language from the Android part of an existing Rapid project.
/// {@endtemplate}
class AndroidRemoveLanguageCommand extends PlatformRemoveLanguageCommand {
  /// {@macro android_remove_language_command}
  AndroidRemoveLanguageCommand({
    super.logger,
    required super.project,
    super.flutterGenl10n,
  }) : super(
          platform: Platform.android,
        );
}
