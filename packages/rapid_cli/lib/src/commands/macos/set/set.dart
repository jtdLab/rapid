import 'package:mason/mason.dart';
import 'package:rapid_cli/src/commands/core/platform/set/set.dart';
import 'package:rapid_cli/src/commands/macos/set/default_language/default_language.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/project/project.dart';

/// {@template macos_set_command}
/// `rapid macos set` command sets properties of features from the macOS part of an existing Rapid project.
/// {@endtemplate}
class MacosSetCommand extends PlatformSetCommand {
  /// {@macro macos_set_command}
  MacosSetCommand({
    Logger? logger,
    required Project project,
  }) : super(
          platform: Platform.macos,
          defaultLanguageCommand: MacosSetDefaultLanguageCommand(
            logger: logger,
            project: project,
          ),
        );
}
