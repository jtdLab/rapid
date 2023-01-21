import 'package:rapid_cli/src/commands/core/platform/add/language/language.dart';
import 'package:rapid_cli/src2/core/platform.dart';

/// {@template linux_add_language_command}
/// `rapid linux add language` command adds a language to the Linux part of an existing Rapid project.
/// {@endtemplate}
class LinuxAddLanguageCommand extends PlatformAddLanguageCommand {
  /// {@macro linux_add_language_command}
  LinuxAddLanguageCommand({
    super.logger,
    required super.project,
    super.flutterGenl10n,
    super.flutterFormatFix,
    super.generator,
  }) : super(
          platform: Platform.linux,
        );
}
