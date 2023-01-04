import 'package:args/command_runner.dart';
import 'package:mason/mason.dart';
import 'package:rapid_cli/src/project/project.dart';

import 'android/android.dart';
import 'ios/ios.dart';
import 'linux/linux.dart';
import 'macos/macos.dart';
import 'web/web.dart';
import 'windows/windows.dart';

// TODO think about a flag that allows to pick wheter to remove the platforms ui package or not

/// {@template deactivate_command}
/// `rapid deactivate` command removes support for a platform from an existing Rapid project.
/// {@endtemplate}
class DeactivateCommand extends Command<int> {
  /// {@macro deactivate_command}
  DeactivateCommand({
    Logger? logger,
    required Project project,
  }) {
    addSubcommand(AndroidCommand(logger: logger, project: project));
    addSubcommand(IosCommand(logger: logger, project: project));
    addSubcommand(LinuxCommand(logger: logger, project: project));
    addSubcommand(MacosCommand(logger: logger, project: project));
    addSubcommand(WebCommand(logger: logger, project: project));
    addSubcommand(WindowsCommand(logger: logger, project: project));
  }

  @override
  String get name => 'deactivate';

  @override
  String get description =>
      'Removes support for a platform from an existing Rapid project.';

  @override
  String get invocation => 'rapid deactivate <platform>';
}
