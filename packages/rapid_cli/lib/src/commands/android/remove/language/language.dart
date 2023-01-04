import 'package:mason/mason.dart';
import 'package:rapid_cli/src/cli/cli.dart';
import 'package:rapid_cli/src/commands/core/platform/remove/language/language.dart';
import 'package:rapid_cli/src/core/platform.dart';

/// {@template android_remove_language_command}
/// `rapid android remove language` command removes a language from the Android part of an existing Rapid project.
/// {@endtemplate}
class LanguageCommand extends PlatformRemoveLanguageCommand {
  /// {@macro android_remove_language_command}
  LanguageCommand({
    Logger? logger,
    required super.project,
    FlutterGenl10nCommand? flutterGenl10n,
  }) : super(
          platform: Platform.android,
          logger: logger ?? Logger(),
          flutterGenl10n: flutterGenl10n ?? Flutter.genl10n,
        );
}
