import 'package:mason/mason.dart';
import 'package:rapid_cli/src/commands/core/platform/set/set.dart';
import 'package:rapid_cli/src/commands/linux/set/default_language/default_language.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/project/project.dart';

/// {@template linux_set_command}
/// `rapid linux set` command sets properties of features from the Linux part of an existing Rapid project.
/// {@endtemplate}
class LinuxSetCommand extends PlatformSetCommand {
  /// {@macro linux_set_command}
  LinuxSetCommand({
    Logger? logger,
    required Project project,
  }) : super(
          platform: Platform.linux,
          defaultLanguageCommand: LinuxSetDefaultLanguageCommand(
            logger: logger,
            project: project,
          ),
        );
}
