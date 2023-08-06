import 'activate/android.dart';
import 'activate/ios.dart';
import 'activate/linux.dart';
import 'activate/macos.dart';
import 'activate/mobile.dart';
import 'activate/web.dart';
import 'activate/windows.dart';
import 'base.dart';

/// {@template activate_command}
/// `rapid activate` adds support for a platform to a Rapid project.
/// {@endtemplate}
class ActivateCommand extends RapidBranchCommand {
  /// {@macro activate_command}
  ActivateCommand(super.project) {
    addSubcommand(ActivateAndroidCommand(project));
    addSubcommand(ActivateIosCommand(project));
    addSubcommand(ActivateLinuxCommand(project));
    addSubcommand(ActivateMacosCommand(project));
    addSubcommand(ActivateMobileCommand(project));
    addSubcommand(ActivateWebCommand(project));
    addSubcommand(ActivateWindowsCommand(project));
  }

  @override
  String get name => 'activate';

  @override
  String get invocation => 'rapid activate <platform>';

  @override
  String get description => 'Add support for a platform to a Rapid project.';
}
