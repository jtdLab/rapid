import 'package:mason/mason.dart';
import 'package:rapid_cli/src/commands/core/platform/set/set.dart';
import 'package:rapid_cli/src/commands/windows/set/default_language/default_language.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/project/project.dart';

/// {@template windows_set_command}
/// `rapid windows set` command sets properties of features from the Windows part of an existing Rapid project.
/// {@endtemplate}
class WindowsSetCommand extends PlatformSetCommand {
  /// {@macro windows_set_command}
  WindowsSetCommand({
    Logger? logger,
    required Project project,
  }) : super(
          platform: Platform.windows,
          defaultLanguageCommand: WindowsSetDefaultLanguageCommand(
            logger: logger,
            project: project,
          ),
        );
}
