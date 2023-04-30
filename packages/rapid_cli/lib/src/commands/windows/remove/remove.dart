import 'package:mason/mason.dart';
import 'package:rapid_cli/src/commands/core/platform/remove/remove.dart';
import 'package:rapid_cli/src/commands/windows/remove/feature/feature.dart';
import 'package:rapid_cli/src/commands/windows/remove/language/language.dart';
import 'package:rapid_cli/src/commands/windows/remove/navigator/navigator.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/project/project.dart';

/// {@template windows_remove_command}
/// `rapid windows remove` command removes features or languages from the Windows part of an existing Rapid project.
/// {@endtemplate}
class WindowsRemoveCommand extends PlatformRemoveCommand {
  /// {@macro windows_remove_command}
  WindowsRemoveCommand({
    Logger? logger,
    Project? project,
  }) : super(
          platform: Platform.windows,
          featureCommand:
              WindowsRemoveFeatureCommand(logger: logger, project: project),
          languageCommand:
              WindowsRemoveLanguageCommand(logger: logger, project: project),
          navigatorCommand:
              WindowsRemoveNavigatorCommand(logger: logger, project: project),
        );
}
