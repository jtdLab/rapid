import 'package:rapid_cli/src/command_runner/util/platform_x.dart';
import 'package:rapid_cli/src/core/platform.dart';

import '../../base.dart';
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
