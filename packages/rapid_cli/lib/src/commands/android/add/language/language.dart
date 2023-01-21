import 'package:rapid_cli/src/commands/core/platform/add/language/language.dart';
import 'package:rapid_cli/src2/core/platform.dart';

/// {@template android_add_language_command}
/// `rapid android add language` command adds a language to the Android part of an existing Rapid project.
/// {@endtemplate}
class AndroidAddLanguageCommand extends PlatformAddLanguageCommand {
  /// {@macro android_add_language_command}
  AndroidAddLanguageCommand({
    super.logger,
    required super.project,
    super.flutterGenl10n,
    super.flutterFormatFix,
    super.generator,
  }) : super(
          platform: Platform.android,
        );
}
