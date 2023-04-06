import 'package:rapid_cli/src/commands/core/platform/set/default_language/default_language.dart';
import 'package:rapid_cli/src/core/platform.dart';

/// {@template linux_set_default_language_command}
/// `rapid linux set default_language` command sets the default language of the Linux part of an existing Rapid project.
/// {@endtemplate}
class LinuxSetDefaultLanguageCommand extends PlatformSetDefaultLanguageCommand {
  /// {@macro linux_set_default_language_command}
  LinuxSetDefaultLanguageCommand({
    super.logger,
    super.project,
    super.flutterGenl10n,
    super.dartFormatFix,
  }) : super(
          platform: Platform.linux,
        );
}
