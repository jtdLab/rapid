import 'package:mason/mason.dart';
import 'package:rapid_cli/src/commands/core/platform/remove/remove.dart';
import 'package:rapid_cli/src/commands/mobile/remove/feature/feature.dart';
import 'package:rapid_cli/src/commands/mobile/remove/language/language.dart';
import 'package:rapid_cli/src/commands/mobile/remove/navigator/navigator.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/project/project.dart';

/// {@template mobile_remove_command}
/// `rapid mobile remove` command removes features or languages from the Mobile part of an existing Rapid project.
/// {@endtemplate}
class MobileRemoveCommand extends PlatformRemoveCommand {
  /// {@macro mobile_remove_command}
  MobileRemoveCommand({
    Logger? logger,
    Project? project,
  }) : super(
          platform: Platform.mobile,
          featureCommand:
              MobileRemoveFeatureCommand(logger: logger, project: project),
          languageCommand:
              MobileRemoveLanguageCommand(logger: logger, project: project),
          navigatorCommand:
              MobileRemoveNavigatorCommand(logger: logger, project: project),
        );
}
