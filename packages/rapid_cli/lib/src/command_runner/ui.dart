import '../project/platform.dart';
import 'base.dart';
import 'ui/add.dart';
import 'ui/platform.dart';
import 'ui/remove.dart';

/// {@template ui_command}
/// `rapid ui` work with the UI part of a Rapid project.
/// {@endtemplate}
class UiCommand extends RapidBranchCommand {
  /// {@macro ui_command}
  UiCommand(super.project) {
    addSubcommand(UiAddCommand(project));
    addSubcommand(UiPlatformCommand(project, platform: Platform.android));
    addSubcommand(UiPlatformCommand(project, platform: Platform.ios));
    addSubcommand(UiPlatformCommand(project, platform: Platform.linux));
    addSubcommand(UiPlatformCommand(project, platform: Platform.macos));
    addSubcommand(UiPlatformCommand(project, platform: Platform.mobile));
    addSubcommand(UiRemoveCommand(project));
    addSubcommand(UiPlatformCommand(project, platform: Platform.web));
    addSubcommand(UiPlatformCommand(project, platform: Platform.windows));
  }

  @override
  String get name => 'ui';

  @override
  String get invocation => 'rapid ui <subcommand>';

  @override
  String get description => 'Work with the UI part of a Rapid project.';
}
