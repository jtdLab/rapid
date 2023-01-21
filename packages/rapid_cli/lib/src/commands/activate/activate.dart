import 'package:args/command_runner.dart';
import 'package:mason/mason.dart';
import 'package:rapid_cli/src2/project/project.dart';

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
    addSubcommand(ActivateAndroidCommand(logger: logger, project: project));
    addSubcommand(ActivateIosCommand(logger: logger, project: project));
    addSubcommand(ActivateWebCommand(logger: logger, project: project));
    addSubcommand(ActivateLinuxCommand(logger: logger, project: project));
    addSubcommand(ActivateMacosCommand(logger: logger, project: project));
    addSubcommand(ActivateWindowsCommand(logger: logger, project: project));
  }

  @override
  String get name => 'activate';

  @override
  String get invocation => 'rapid activate <platform>';

  @override
  String get description =>
      'Add support for a platform to an existing Rapid project.';
}
