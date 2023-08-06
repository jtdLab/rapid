import '../../../project/platform.dart';
import '../../base.dart';
import '../../util/platform_x.dart';
import 'add/widget.dart';

class UiPlatformAddCommand extends RapidBranchCommand {
  UiPlatformAddCommand(this.platform, super.project) {
    addSubcommand(UiPlatformAddWidgetCommand(platform, super.project));
  }

  final Platform platform;

  @override
  String get name => 'add';

  @override
  String get invocation => 'rapid ui ${platform.name} add <subcommand>';

  @override
  String get description =>
      'Add components to the ${platform.prettyName} UI part of an existing Rapid project.';
}
