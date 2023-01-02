import 'package:mason/mason.dart';
import 'package:rapid_cli/src/commands/android/remove/feature/feature.dart';
import 'package:rapid_cli/src/commands/android/remove/language/language.dart';
import 'package:rapid_cli/src/commands/core/platform/remove/remove.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/project/project.dart';

/// {@template android_remove_command}
/// `rapid android remove` command removes features or languages from the Android part of an existing Rapid project.
/// {@endtemplate}
class RemoveCommand extends PlatformRemoveCommand {
  /// {@macro android_remove_command}
  RemoveCommand({
    Logger? logger,
    required Project project,
  }) : super(
          platform: Platform.android,
          featureCommand: FeatureCommand(logger: logger, project: project),
          languageCommand: LanguageCommand(logger: logger, project: project),
        );
}
