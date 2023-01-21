import 'package:rapid_cli/src/commands/core/platform/remove/language/language.dart';
import 'package:rapid_cli/src/core/platform.dart';

/// {@template macos_remove_language_command}
/// `rapid macos remove language` command removes a language from the macOS part of an existing Rapid project.
/// {@endtemplate}
class MacosRemoveLanguageCommand extends PlatformRemoveLanguageCommand {
  /// {@macro macos_remove_language_command}
  MacosRemoveLanguageCommand({
    super.logger,
    required super.project,
  }) : super(
          platform: Platform.macos,
        );
}
