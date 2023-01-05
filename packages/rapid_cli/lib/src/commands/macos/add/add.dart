import 'package:mason/mason.dart';
import 'package:rapid_cli/src/commands/macos/add/feature/feature.dart';
import 'package:rapid_cli/src/commands/macos/add/language/language.dart';
import 'package:rapid_cli/src/commands/core/platform/add/add.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/project/project.dart';

/// {@template macos_add_command}
/// `rapid macos add` command work with the macOS part of an existing Rapid project.
/// {@endtemplate}
class MacosAddCommand extends PlatformAddCommand {
  /// {@macro macos_add_command}
  MacosAddCommand({
    Logger? logger,
    required Project project,
  }) : super(
          platform: Platform.macos,
          featureCommand:
              MacosAddFeatureCommand(logger: logger, project: project),
          languageCommand:
              MacosAddLanguageCommand(logger: logger, project: project),
        );
}
