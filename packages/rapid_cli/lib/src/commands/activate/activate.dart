import 'package:args/command_runner.dart';
import 'package:mason/mason.dart';
import 'package:rapid_cli/src/core/project.dart';

import 'android/android.dart';
import 'ios/ios.dart';
import 'linux/linux.dart';
import 'macos/macos.dart';
import 'web/web.dart';
import 'windows/windows.dart';

/// {@template activate_command}
/// `rapid activate` command adds support for a platform to an existing Rapid project.
/// {@endtemplate}
class ActivateCommand extends Command<int> {
  /// {@macro activate_command}
  ActivateCommand({
    Logger? logger,
    required Project project,
  }) {
    addSubcommand(AndroidCommand(logger: logger, project: project));
    addSubcommand(IosCommand(logger: logger, project: project));
    addSubcommand(WebCommand(logger: logger, project: project));
    addSubcommand(LinuxCommand(logger: logger, project: project));
    addSubcommand(MacosCommand(logger: logger, project: project));
    addSubcommand(WindowsCommand(logger: logger, project: project));
  }

  @override
  String get name => 'activate';

  @override
  String get description =>
      'Adds support for a platform to an existing Rapid project.';

  @override
  String get invocation => 'rapid activate <platform>';
}
