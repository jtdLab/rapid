import 'package:rapid_cli/src/commands/core/platform/remove/language/language.dart';
import 'package:rapid_cli/src2/core/platform.dart';

/// {@template ios_remove_language_command}
/// `rapid ios remove language` command removes a language from the iOS part of an existing Rapid project.
/// {@endtemplate}
class IosRemoveLanguageCommand extends PlatformRemoveLanguageCommand {
  /// {@macro ios_remove_language_command}
  IosRemoveLanguageCommand({
    super.logger,
    required super.project,
    super.flutterGenl10n,
  }) : super(
          platform: Platform.ios,
        );
}
