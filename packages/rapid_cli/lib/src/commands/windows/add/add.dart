import 'package:mason/mason.dart';
import 'package:rapid_cli/src/commands/windows/add/feature/feature.dart';
import 'package:rapid_cli/src/commands/windows/add/language/language.dart';
import 'package:rapid_cli/src/commands/core/platform/add/add.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/project/project.dart';

/// {@template windows_add_command}
/// `rapid windows add` command work with the Windows part of an existing Rapid project.
/// {@endtemplate}
class WindowsAddCommand extends PlatformAddCommand {
  /// {@macro windows_add_command}
  WindowsAddCommand({
    Logger? logger,
    Project? project,
  }) : super(
          platform: Platform.windows,
          featureCommand:
              WindowsAddFeatureCommand(logger: logger, project: project),
          languageCommand:
              WindowsAddLanguageCommand(logger: logger, project: project),
        );
}
