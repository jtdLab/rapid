import '../../project/platform.dart';
import '../../utils.dart';
import '../base.dart';
import 'platform/add.dart';
import 'platform/remove.dart';

class UiPlatformCommand extends RapidBranchCommand {
  UiPlatformCommand(this.platform, super.project) {
    addSubcommand(UiPlatformAddCommand(platform, project));
    addSubcommand(UiPlatformRemoveCommand(platform, project));
  }

  final Platform platform;

  @override
  String get name => platform.name;

  @override
  List<String> get aliases => platform.aliases;

  @override
  String get invocation => 'rapid ui ${platform.name} <subcommand>';

  @override
  String get description =>
      'Work with the ${platform.prettyName} UI part of an existing Rapid project.';
}
