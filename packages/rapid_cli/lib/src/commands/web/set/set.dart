import 'package:mason/mason.dart';
import 'package:rapid_cli/src/commands/core/platform/set/set.dart';
import 'package:rapid_cli/src/commands/web/set/default_language/default_language.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/project/project.dart';

/// {@template web_set_command}
/// `rapid web set` command sets properties of features from the Web part of an existing Rapid project.
/// {@endtemplate}
class WebSetCommand extends PlatformSetCommand {
  /// {@macro web_set_command}
  WebSetCommand({
    Logger? logger,
    required Project project,
  }) : super(
          platform: Platform.web,
          defaultLanguageCommand: WebSetDefaultLanguageCommand(
            logger: logger,
            project: project,
          ),
        );
}
