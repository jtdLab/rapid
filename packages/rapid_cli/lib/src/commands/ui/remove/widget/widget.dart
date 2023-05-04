import 'package:mason/mason.dart';
import 'package:rapid_cli/src/commands/core/class_name_rest.dart';
import 'package:rapid_cli/src/commands/core/command.dart';
import 'package:rapid_cli/src/commands/core/run_when.dart';

/// {@template ui_remove_widget_command}
/// `rapid ui remove widget` command removes a widget to the platform independent UI part of an existing Rapid project.
/// {@endtemplate}
class UiRemoveWidgetCommand extends RapidRootCommand with ClassNameGetter {
  /// {@macro ui_remove_widget_command}
  UiRemoveWidgetCommand({
    super.logger,
    super.project,
  });

  @override
  String get name => 'widget';

  @override
  String get invocation => 'rapid ui remove widget <name> [arguments]';

  @override
  String get description =>
      'Remove a widget to the platform independent UI part of an existing Rapid project.';

  @override
  Future<int> run() => runWhen(
        [
          projectExistsAll(project),
        ],
        logger,
        () async {
          final name = super.className;

          logger.info('Removing Widget ...');

          final uiPackage = project.uiPackage;
          // TODO remove dir completly ?
          final widget = uiPackage.widget(name: name, dir: '.');

          if (widget.existsAny()) {
            widget.delete();

            final themeExtensionsFile = uiPackage.themeExtensionsFile;
            themeExtensionsFile.removeThemeExtension(name);

            final barrelFile = uiPackage.barrelFile;
            barrelFile.removeExport('src/${name.snakeCase}.dart');
            barrelFile.removeExport('src/${name.snakeCase}_theme.dart');

            logger
              ..info('')
              ..success('Removed Widget $name.');

            return ExitCode.success.code;
          } else {
            logger
              ..info('')
              ..err('Widget $name not found.');

            return ExitCode.config.code;
          }
        },
      );
}
