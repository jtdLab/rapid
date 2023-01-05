import 'package:rapid_cli/src/commands/core/platform/remove/language/language.dart';
import 'package:rapid_cli/src/core/platform.dart';

/// {@template windows_remove_language_command}
/// `rapid windows remove language` command removes a language from the Windows part of an existing Rapid project.
/// {@endtemplate}
class WindowsRemoveLanguageCommand extends PlatformRemoveLanguageCommand {
  /// {@macro windows_remove_language_command}
  WindowsRemoveLanguageCommand({
    super.logger,
    required super.project,
    super.flutterGenl10n,
  }) : super(
          platform: Platform.windows,
        );
}
