import '../project/platform.dart';
import 'base.dart';
import 'deactivate/platform.dart';

/// {@template deactivate_command}
/// `rapid deactivate` removes support for a platform from a Rapid project.
/// {@endtemplate}
class DeactivateCommand extends RapidBranchCommand {
  /// {@macro deactivate_command}
  DeactivateCommand(super.project) {
    addSubcommand(DeactivatePlatformCommand(Platform.android, project));
    addSubcommand(DeactivatePlatformCommand(Platform.ios, project));
    addSubcommand(DeactivatePlatformCommand(Platform.linux, project));
    addSubcommand(DeactivatePlatformCommand(Platform.macos, project));
    addSubcommand(DeactivatePlatformCommand(Platform.mobile, project));
    addSubcommand(DeactivatePlatformCommand(Platform.web, project));
    addSubcommand(DeactivatePlatformCommand(Platform.windows, project));
  }

  @override
  String get name => 'deactivate';

  @override
  String get description =>
      'Remove support for a platform from a Rapid project.';

  @override
  String get invocation => 'rapid deactivate <platform>';
}
