import 'package:mason/mason.dart';
import 'package:rapid_cli/src/commands/ios/remove/feature/feature.dart';
import 'package:rapid_cli/src/commands/ios/remove/language/language.dart';
import 'package:rapid_cli/src/commands/core/platform/remove/remove.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/project/project.dart';

/// {@template android_remove_command}
/// `rapid ios remove` command removes features or languages from the iOS part of an existing Rapid project.
/// {@endtemplate}
class AndroidRemoveCommand extends PlatformRemoveCommand {
  /// {@macro android_remove_command}
  AndroidRemoveCommand({
    Logger? logger,
    required Project project,
  }) : super(
          platform: Platform.ios,
          featureCommand:
              AndroidRemoveFeatureCommand(logger: logger, project: project),
          languageCommand:
              AndroidRemoveLanguageCommand(logger: logger, project: project),
        );
}
