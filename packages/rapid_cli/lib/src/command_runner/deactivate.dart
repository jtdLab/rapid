import 'package:rapid_cli/src/project/platform.dart';

import 'base.dart';
import 'deactivate/platform.dart';

// TODO: think about a flag that allows to pick whether to remove the platforms ui package or not

/// {@template deactivate_command}
/// `rapid deactivate` command removes support for a platform from an existing Rapid project.
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
      'Remove support for a platform from an existing Rapid project.';

  @override
  String get invocation => 'rapid deactivate <platform>';
}
