import 'package:rapid_cli/src/command_runner/util/platform_x.dart';
import 'package:rapid_cli/src/core/platform.dart';

import '../../base.dart';
import 'feature/custom.dart';
import 'feature/flow.dart';
import 'feature/page.dart';
import 'feature/widget.dart';

class PlatformAddFeatureCommand extends RapidBranchCommand {
  PlatformAddFeatureCommand(this.platform, super.project) {
    addSubcommand(PlatformAddFeatureCustomCommand(platform, project));
    addSubcommand(PlatformAddFeatureFlowCommand(platform, project));
    addSubcommand(PlatformAddFeaturePageCommand(platform, project));
    addSubcommand(PlatformAddFeatureWidgetCommand(platform, project));
  }

  final Platform platform;

  @override
  String get name => 'feature';

  @override
  String get invocation => 'rapid ${platform.name} add feature <type>';

  @override
  String get description =>
      'Add features to the ${platform.prettyName} part of an existing Rapid project.';
}
