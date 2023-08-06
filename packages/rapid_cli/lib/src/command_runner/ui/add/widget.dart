import '../../../command_runner/base.dart';
import '../../util/class_name_rest.dart';

const _defaultTheme = true;

/// {@template ui_add_widget_command}
/// `rapid ui add widget` add a widget to the platform independent UI part of a Rapid project.
/// {@endtemplate}
class UiAddWidgetCommand extends RapidLeafCommand with ClassNameGetter {
  /// {@macro ui_add_widget_command}
  UiAddWidgetCommand(super.project) {
    argParser.addFlag(
      'theme',
      help: 'Whether the new widget has its own theme.',
      defaultsTo: _defaultTheme,
    );
  }

  @override
  String get name => 'widget';

  @override
  String get invocation => 'rapid ui add widget <name> [arguments]';

  @override
  String get description =>
      'Add a widget to the platform independent UI part of a Rapid project.';

  @override
  Future<void> run() {
    final name = super.className;
    final theme = argResults['theme'] as bool? ?? _defaultTheme;

    return rapid.uiAddWidget(name: name, theme: theme);
  }
}
