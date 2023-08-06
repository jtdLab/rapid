import '../../../../project/platform.dart';
import '../../../base.dart';
import '../../../util/class_name_rest.dart';
import '../../../util/platform_x.dart';

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
