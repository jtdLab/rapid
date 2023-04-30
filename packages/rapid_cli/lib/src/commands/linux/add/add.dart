import 'package:mason/mason.dart';
import 'package:rapid_cli/src/commands/core/platform/add/add.dart';
import 'package:rapid_cli/src/commands/linux/add/feature/feature.dart';
import 'package:rapid_cli/src/commands/linux/add/language/language.dart';
import 'package:rapid_cli/src/commands/linux/add/navigator/navigator.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/project/project.dart';

/// {@template linux_add_command}
/// `rapid linux add` command work with the Linux part of an existing Rapid project.
/// {@endtemplate}
class LinuxAddCommand extends PlatformAddCommand {
  /// {@macro linux_add_command}
  LinuxAddCommand({
    Logger? logger,
    Project? project,
  }) : super(
          platform: Platform.linux,
          featureCommand:
              LinuxAddFeatureCommand(logger: logger, project: project),
          languageCommand:
              LinuxAddLanguageCommand(logger: logger, project: project),
          navigatorCommand:
              LinuxAddNavigatorCommand(logger: logger, project: project),
        );
}
