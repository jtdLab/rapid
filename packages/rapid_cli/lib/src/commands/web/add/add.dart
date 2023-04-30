import 'package:mason/mason.dart';
import 'package:rapid_cli/src/commands/core/platform/add/add.dart';
import 'package:rapid_cli/src/commands/web/add/feature/feature.dart';
import 'package:rapid_cli/src/commands/web/add/language/language.dart';
import 'package:rapid_cli/src/commands/web/add/navigator/navigator.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/project/project.dart';

/// {@template web_add_command}
/// `rapid web add` command work with the Web part of an existing Rapid project.
/// {@endtemplate}
class WebAddCommand extends PlatformAddCommand {
  /// {@macro web_add_command}
  WebAddCommand({
    Logger? logger,
    Project? project,
  }) : super(
          platform: Platform.web,
          featureCommand:
              WebAddFeatureCommand(logger: logger, project: project),
          languageCommand:
              WebAddLanguageCommand(logger: logger, project: project),
          navigatorCommand:
              WebAddNavigatorCommand(logger: logger, project: project),
        );
}
