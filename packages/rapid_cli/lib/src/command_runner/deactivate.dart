import '../project/platform.dart';
import 'base.dart';
import 'deactivate/platform.dart';

/// {@template deactivate_command}
/// `rapid deactivate` removes support for a platform from a Rapid project.
/// {@endtemplate}
class DeactivateCommand extends RapidBranchCommand {
  /// {@macro deactivate_command}
  DeactivateCommand(super.project) {
    addSubcommand(
      DeactivatePlatformCommand(project, platform: Platform.android),
    );
    addSubcommand(
      DeactivatePlatformCommand(project, platform: Platform.ios),
    );
    addSubcommand(
      DeactivatePlatformCommand(project, platform: Platform.linux),
    );
    addSubcommand(
      DeactivatePlatformCommand(project, platform: Platform.macos),
    );
    addSubcommand(
      DeactivatePlatformCommand(project, platform: Platform.mobile),
    );
    addSubcommand(
      DeactivatePlatformCommand(project, platform: Platform.web),
    );
    addSubcommand(
      DeactivatePlatformCommand(project, platform: Platform.windows),
    );
  }

  @override
  String get name => 'deactivate';

  @override
  String get description =>
      'Remove support for a platform from a Rapid project.';

  @override
  String get invocation => 'rapid deactivate <platform>';
}
