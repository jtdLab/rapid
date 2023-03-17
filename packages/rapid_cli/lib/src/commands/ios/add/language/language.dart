import 'package:rapid_cli/src/commands/core/platform/add/language/language.dart';
import 'package:rapid_cli/src/core/platform.dart';

/// {@template ios_add_language_command}
/// `rapid ios add language` command adds a language to the iOS part of an existing Rapid project.
/// {@endtemplate}
class IosAddLanguageCommand extends PlatformAddLanguageCommand {
  /// {@macro ios_add_language_command}
  IosAddLanguageCommand({
    super.logger,
    required super.project,
    super.flutterGenl10n,
    super.dartFormatFix,
  }) : super(
          platform: Platform.ios,
        );
}
