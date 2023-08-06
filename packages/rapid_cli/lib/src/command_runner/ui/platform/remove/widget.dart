import '../../../../project/platform.dart';
import '../../../../utils.dart';
import '../../../base.dart';
import '../../../util/class_name_rest.dart';

/// {@template ui_platform_remove_widget_command}
/// `rapid ui <platform> remove widget` remove a widget from the platform UI part of a Rapid project.
/// {@endtemplate}
class UiPlatformRemoveWidgetCommand extends RapidLeafCommand
    with ClassNameGetter {
  /// {@macro ui_platform_remove_widget_command}
  UiPlatformRemoveWidgetCommand(this.platform, super.project);

  final Platform platform;

  @override
  String get name => 'widget';

  @override
  String get invocation =>
      'rapid ui ${platform.name} remove widget <name> [arguments]';

  @override
  String get description =>
      'Remove a widget from the ${platform.prettyName} UI part of a Rapid project.';

  @override
  Future<void> run() {
    final name = super.className;

    return rapid.uiPlatformRemoveWidget(platform, name: name);
  }
}
