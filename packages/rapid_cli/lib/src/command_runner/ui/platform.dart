import '../../utils.dart';
import '../base.dart';
import 'platform/add.dart';
import 'platform/remove.dart';

/// {@template ui_platform_command}
/// `rapid ui <platform>` work with the platform UI part of a Rapid project.
/// {@endtemplate}
class UiPlatformCommand extends RapidPlatformBranchCommand {
  /// {@macro ui_platform_command}
  UiPlatformCommand(super.project, {required super.platform}) {
    addSubcommand(UiPlatformAddCommand(project, platform: platform));
    addSubcommand(UiPlatformRemoveCommand(project, platform: platform));
  }

  @override
  String get name => platform.name;

  @override
  List<String> get aliases => platform.aliases;

  @override
  String get invocation => 'rapid ui ${platform.name} <subcommand>';

  @override
  String get description =>
      'Work with the ${platform.prettyName} UI part of a Rapid project.';
}
