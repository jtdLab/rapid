import 'package:mason/mason.dart';
import 'package:rapid_cli/src/commands/linux/remove/feature/feature.dart';
import 'package:rapid_cli/src/commands/linux/remove/language/language.dart';
import 'package:rapid_cli/src/commands/core/platform/remove/remove.dart';
import 'package:rapid_cli/src2/core/platform.dart';
import 'package:rapid_cli/src2/project/project.dart';

/// {@template linux_remove_command}
/// `rapid linux remove` command removes features or languages from the Linux part of an existing Rapid project.
/// {@endtemplate}
class LinuxRemoveCommand extends PlatformRemoveCommand {
  /// {@macro linux_remove_command}
  LinuxRemoveCommand({
    Logger? logger,
    required Project project,
  }) : super(
          platform: Platform.linux,
          featureCommand:
              LinuxRemoveFeatureCommand(logger: logger, project: project),
          languageCommand:
              LinuxRemoveLanguageCommand(logger: logger, project: project),
        );
}
