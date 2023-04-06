import 'package:mason/mason.dart';
import 'package:rapid_cli/src/commands/macos/remove/feature/feature.dart';
import 'package:rapid_cli/src/commands/macos/remove/language/language.dart';
import 'package:rapid_cli/src/commands/core/platform/remove/remove.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/project/project.dart';

/// {@template macos_remove_command}
/// `rapid macos remove` command removes features or languages from the macOS part of an existing Rapid project.
/// {@endtemplate}
class MacosRemoveCommand extends PlatformRemoveCommand {
  /// {@macro macos_remove_command}
  MacosRemoveCommand({
    Logger? logger,
    Project? project,
  }) : super(
          platform: Platform.macos,
          featureCommand:
              MacosRemoveFeatureCommand(logger: logger, project: project),
          languageCommand:
              MacosRemoveLanguageCommand(logger: logger, project: project),
        );
}
