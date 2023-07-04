import 'package:rapid_cli/src/command_runner/util/platform_x.dart';
import 'package:rapid_cli/src/project/platform.dart';

import '../../../base.dart';
import '../../../util/class_name_rest.dart';

class UiPlatformRemoveWidgetCommand extends RapidLeafCommand
    with ClassNameGetter {
  UiPlatformRemoveWidgetCommand(this.platform, super.project);

  final Platform platform;

  @override
  String get name => 'widget';

  @override
  String get invocation =>
      'rapid ui ${platform.name} remove widget <name> [arguments]';

  @override
  String get description =>
      'Remove a widget from the ${platform.prettyName} UI part of an existing Rapid project.';

  @override
  Future<void> run() {
    final name = super.className;

    return rapid.uiPlatformRemoveWidget(platform, name: name);
  }
}
