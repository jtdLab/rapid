import 'package:rapid_cli/src/commands/core/platform/add/language/language.dart';
import 'package:rapid_cli/src/core/platform.dart';

/// {@template android_add_language_command}
/// `rapid ios add language` command adds a language to the iOS part of an existing Rapid project.
/// {@endtemplate}
class AndroidAddLanguageCommand extends PlatformAddLanguageCommand {
  /// {@macro android_add_language_command}
  AndroidAddLanguageCommand({
    super.logger,
    required super.project,
    super.flutterGenl10n,
    super.generator,
  }) : super(
          platform: Platform.ios,
        );
}
