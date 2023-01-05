import 'package:mason/mason.dart';
import 'package:rapid_cli/src/commands/android/add/add.dart';
import 'package:rapid_cli/src/commands/android/feature/feature.dart';
import 'package:rapid_cli/src/commands/android/remove/remove.dart';
import 'package:rapid_cli/src/commands/core/platform/platform.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/project/project.dart';

/// {@template android_command}
/// `rapid android` command work with the Android part of an existing Rapid project.
/// {@endtemplate}
class AndroidCommand extends PlatformCommand {
  /// {@macro android_command}
  AndroidCommand({
    Logger? logger,
    required Project project,
  }) : super(
          platform: Platform.android,
          logger: logger ?? Logger(),
          project: project,
          addCommand: AndroidAddCommand(project: project),
          featureCommand: AndroidFeatureCommand(project: project),
          removeCommand: AndroidRemoveCommand(project: project),
        );
}
