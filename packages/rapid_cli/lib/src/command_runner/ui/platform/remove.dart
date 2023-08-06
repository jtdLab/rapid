import '../../../project/platform.dart';
import '../../base.dart';
import '../../util/platform_x.dart';
import 'remove/widget.dart';

class UiPlatformRemoveCommand extends RapidBranchCommand {
  UiPlatformRemoveCommand(this.platform, super.project) {
    addSubcommand(UiPlatformRemoveWidgetCommand(platform, project));
  }

  final Platform platform;

  @override
  String get name => 'remove';

  @override
  String get invocation => 'rapid ui ${platform.name} remove <subcommand>';

  @override
  String get description =>
      'Remove components from the ${platform.prettyName} UI part of an existing Rapid project.';
}
