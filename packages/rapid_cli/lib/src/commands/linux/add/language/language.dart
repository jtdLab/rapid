import 'package:rapid_cli/src/commands/core/platform/add/language/language.dart';
import 'package:rapid_cli/src/core/platform.dart';

/// {@template linux_add_language_command}
/// `rapid linux add language` command adds a language to the Linux part of an existing Rapid project.
/// {@endtemplate}
class LinuxAddLanguageCommand extends PlatformAddLanguageCommand {
  /// {@macro linux_add_language_command}
  LinuxAddLanguageCommand({
    super.logger,
    super.project,
    super.flutterGenl10n,
    super.dartFormatFix,
  }) : super(
          platform: Platform.linux,
        );
}
