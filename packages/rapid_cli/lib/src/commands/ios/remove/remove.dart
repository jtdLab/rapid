import 'package:mason/mason.dart';
import 'package:rapid_cli/src/commands/ios/remove/feature/feature.dart';
import 'package:rapid_cli/src/commands/ios/remove/language/language.dart';
import 'package:rapid_cli/src/commands/core/platform/remove/remove.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/project/project.dart';

/// {@template ios_remove_command}
/// `rapid ios remove` command removes features or languages from the iOS part of an existing Rapid project.
/// {@endtemplate}
class IosRemoveCommand extends PlatformRemoveCommand {
  /// {@macro ios_remove_command}
  IosRemoveCommand({
    Logger? logger,
    Project? project,
  }) : super(
          platform: Platform.ios,
          featureCommand:
              IosRemoveFeatureCommand(logger: logger, project: project),
          languageCommand:
              IosRemoveLanguageCommand(logger: logger, project: project),
        );
}
