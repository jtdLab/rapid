import '../../../../utils.dart';
import '../../../base.dart';
import '../../../util/class_name_rest.dart';

const _defaultTheme = true;

/// {@template ui_platform_add_widget_command}
/// `rapid ui <platform> add` add a widget to the platform UI part of a
/// Rapid project.
/// {@endtemplate}
class UiPlatformAddWidgetCommand extends RapidPlatformLeafCommand
    with ClassNameGetter {
  /// {@macro ui_platform_add_widget_command}
  UiPlatformAddWidgetCommand(super.project, {required super.platform}) {
    argParser.addFlag(
      'theme',
      help: 'Whether the new widget has its own theme.',
      defaultsTo: _defaultTheme,
    );
  }

  @override
  String get name => 'widget';

  @override
  String get invocation =>
      'rapid ui ${platform.name} add widget <name> [arguments]';

  @override
  String get description =>
      'Add a widget to the ${platform.prettyName} UI part of a Rapid project.';

  @override
  Future<void> run() {
    final name = super.className;
    final theme = argResults['theme'] as bool? ?? _defaultTheme;

    return rapid.uiPlatformAddWidget(platform, name: name, theme: theme);
  }
}
