import 'package:rapid_cli/src/commands/core/platform/add/language/language.dart';
import 'package:rapid_cli/src/core/platform.dart';

/// {@template windows_add_language_command}
/// `rapid windows add language` command adds a language to the Windows part of an existing Rapid project.
/// {@endtemplate}
class WindowsAddLanguageCommand extends PlatformAddLanguageCommand {
  /// {@macro windows_add_language_command}
  WindowsAddLanguageCommand({
    super.logger,
    required super.project,
    super.flutterGenl10n,
    super.generator,
  }) : super(
          platform: Platform.windows,
        );
}
