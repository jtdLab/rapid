import 'package:rapid_cli/src/commands/core/platform/add/language/language.dart';
import 'package:rapid_cli/src2/core/platform.dart';

/// {@template macos_add_language_command}
/// `rapid macos add language` command adds a language to the macOS part of an existing Rapid project.
/// {@endtemplate}
class MacosAddLanguageCommand extends PlatformAddLanguageCommand {
  /// {@macro macos_add_language_command}
  MacosAddLanguageCommand({
    super.logger,
    required super.project,
    super.flutterFormatFix,
  }) : super(
          platform: Platform.macos,
        );
}
