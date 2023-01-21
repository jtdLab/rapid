import 'package:args/command_runner.dart';
import 'package:mason/mason.dart';
import 'package:rapid_cli/src/commands/ui/android/android.dart';
import 'package:rapid_cli/src/commands/ui/ios/ios.dart';
import 'package:rapid_cli/src/commands/ui/linux/linux.dart';
import 'package:rapid_cli/src/commands/ui/macos/macos.dart';
import 'package:rapid_cli/src/commands/ui/web/web.dart';
import 'package:rapid_cli/src/commands/ui/windows/windows.dart';
import 'package:rapid_cli/src2/project/project.dart';

/// {@template ui_command}
/// `rapid ui` command work with the UI part of an existing Rapid project.
/// {@endtemplate}
class UiCommand extends Command<int> {
  /// {@macro ui_command}
  UiCommand({
    Logger? logger,
    required Project project,
  }) {
    addSubcommand(UiAndroidCommand(logger: logger, project: project));
    addSubcommand(UiIosCommand(logger: logger, project: project));
    addSubcommand(UiLinuxCommand(logger: logger, project: project));
    addSubcommand(UiMacosCommand(logger: logger, project: project));
    addSubcommand(UiWebCommand(logger: logger, project: project));
    addSubcommand(UiWindowsCommand(logger: logger, project: project));
  }

  @override
  String get name => 'ui';

  @override
  String get invocation => 'rapid ui <subcommand>';

  @override
  String get description =>
      'Work with the UI part of an existing Rapid project.';
}
