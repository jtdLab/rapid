import 'package:mason/mason.dart';
import 'package:rapid_cli/src/commands/web/remove/feature/feature.dart';
import 'package:rapid_cli/src/commands/web/remove/language/language.dart';
import 'package:rapid_cli/src/commands/core/platform/remove/remove.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/project/project.dart';

/// {@template web_remove_command}
/// `rapid web remove` command removes features or languages from the Web part of an existing Rapid project.
/// {@endtemplate}
class WebRemoveCommand extends PlatformRemoveCommand {
  /// {@macro web_remove_command}
  WebRemoveCommand({
    Logger? logger,
    Project? project,
  }) : super(
          platform: Platform.web,
          featureCommand:
              WebRemoveFeatureCommand(logger: logger, project: project),
          languageCommand:
              WebRemoveLanguageCommand(logger: logger, project: project),
        );
}
