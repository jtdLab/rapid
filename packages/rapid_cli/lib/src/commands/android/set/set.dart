import 'package:mason/mason.dart';
import 'package:rapid_cli/src/commands/android/set/default_language/default_language.dart';
import 'package:rapid_cli/src/commands/core/platform/set/set.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/project/project.dart';

/// {@template android_set_command}
/// `rapid android set` command sets properties of features from the Android part of an existing Rapid project.
/// {@endtemplate}
class AndroidSetCommand extends PlatformSetCommand {
  /// {@macro android_set_command}
  AndroidSetCommand({
    Logger? logger,
    Project? project,
  }) : super(
          platform: Platform.android,
          defaultLanguageCommand: AndroidSetDefaultLanguageCommand(
            logger: logger,
            project: project,
          ),
        );
}
