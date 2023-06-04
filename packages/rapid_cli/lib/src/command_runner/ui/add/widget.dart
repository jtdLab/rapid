import '../../../command_runner/base.dart';
import '../../util/class_name_rest.dart';

/// {@template ui_add_widget_command}
/// `rapid ui add widget` command adds a widget to the platform independent UI part of an existing Rapid project.
/// {@endtemplate}
class UiAddWidgetCommand extends RapidLeafCommand with ClassNameGetter {
  /// {@macro ui_add_widget_command}
  UiAddWidgetCommand(super.project);

  @override
  String get name => 'widget';

  @override
  String get invocation => 'rapid ui add widget <name> [arguments]';

  @override
  String get description =>
      'Add a widget to the platform independent UI part of an existing Rapid project.';

  @override
  Future<void> run() {
    final name = super.className;

    return rapid.uiAddWidget(name: name);
  }
}