import '../../../command_runner/base.dart';
import '../../util/class_name_rest.dart';

/// {@template ui_remove_widget_command}
/// `rapid ui remove widget` remove a widget from the platform independent UI
/// part of a Rapid project.
/// {@endtemplate}
class UiRemoveWidgetCommand extends RapidLeafCommand with ClassNameGetter {
  /// {@macro ui_remove_widget_command}
  UiRemoveWidgetCommand(super.project);

  @override
  String get name => 'widget';

  @override
  String get invocation => 'rapid ui remove widget <name> [arguments]';

  @override
  String get description =>
      'Remove a widget from the platform independent UI part of a Rapid '
      'project.';

  @override
  Future<void> run() {
    final name = super.className;

    return rapid.uiRemoveWidget(name: name);
  }
}
