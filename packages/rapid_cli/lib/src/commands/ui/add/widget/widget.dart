import 'package:mason/mason.dart';
import 'package:rapid_cli/src/cli/cli.dart';
import 'package:rapid_cli/src/commands/core/class_name_rest.dart';
import 'package:rapid_cli/src/commands/core/command.dart';
import 'package:rapid_cli/src/commands/core/run_when.dart';
import 'package:rapid_cli/src/project/project.dart';

/// {@template ui_add_widget_command}
/// `rapid ui add widget` command adds a widget to the platform independent UI part of an existing Rapid project.
/// {@endtemplate}
class UiAddWidgetCommand extends RapidRootCommand with ClassNameGetter {
  /// {@macro ui_add_widget_command}
  UiAddWidgetCommand({
    Logger? logger,
    Project? project,
    DartFormatFixCommand? dartFormatFix,
  })  : _logger = logger ?? Logger(),
        _project = project ?? Project(),
        _dartFormatFix = dartFormatFix ?? Dart.formatFix;

  final Logger _logger;
  final Project _project;
  final DartFormatFixCommand _dartFormatFix;

  @override
  String get name => 'widget';

  @override
  String get invocation => 'rapid ui add widget <name> [arguments]';

  @override
  String get description =>
      'Add a widget to the platform independent UI part of an existing Rapid project.';

  @override
  Future<int> run() => runWhen(
        [
          projectExistsAll(_project),
        ],
        _logger,
        () async {
          final name = super.className;

          _logger.info('Adding Widget ...');

          final uiPackage = _project.uiPackage;
          // TODO remove dir completly ?
          final widget = uiPackage.widget(name: name, dir: '.');
          if (!widget.existsAny()) {
            await widget.create();

            final themeExtensionsFile = uiPackage.themeExtensionsFile;
            themeExtensionsFile.addThemeExtension(name);

            final barrelFile = uiPackage.barrelFile;
            barrelFile.addExport('src/${name.snakeCase}.dart');
            barrelFile.addExport('src/${name.snakeCase}_theme.dart');

            await _dartFormatFix(cwd: uiPackage.path, logger: _logger);

            _logger
              ..info('')
              ..success('Added Widget $name.');

            return ExitCode.success.code;
          } else {
            // TODO maybe log which files
            _logger
              ..info('')
              ..err('Widget $name already exists.');

            return ExitCode.config.code;
          }
        },
      );
}
