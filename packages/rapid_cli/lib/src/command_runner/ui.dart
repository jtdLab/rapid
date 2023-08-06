import '../project/platform.dart';
import 'base.dart';
import 'ui/add.dart';
import 'ui/platform.dart';
import 'ui/remove.dart';

/// {@template ui_command}
/// `rapid ui` command work with the UI part of an existing Rapid project.
/// {@endtemplate}
class UiCommand extends RapidBranchCommand {
  /// {@macro ui_command}
  UiCommand(super.project) {
    addSubcommand(UiAddCommand(project));
    addSubcommand(UiPlatformCommand(Platform.android, project));
    addSubcommand(UiPlatformCommand(Platform.ios, project));
    addSubcommand(UiPlatformCommand(Platform.linux, project));
    addSubcommand(UiPlatformCommand(Platform.macos, project));
    addSubcommand(UiPlatformCommand(Platform.mobile, project));
    addSubcommand(UiRemoveCommand(project));
    addSubcommand(UiPlatformCommand(Platform.web, project));
    addSubcommand(UiPlatformCommand(Platform.windows, project));
  }

  @override
  String get name => 'ui';

  @override
  String get invocation => 'rapid ui <subcommand>';

  @override
  String get description =>
      'Work with the UI part of an existing Rapid project.';
}
