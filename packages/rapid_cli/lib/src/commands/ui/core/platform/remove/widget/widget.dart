import 'package:args/command_runner.dart';
import 'package:mason/mason.dart';
import 'package:rapid_cli/src/commands/core/class_name_rest.dart';
import 'package:rapid_cli/src/commands/core/overridable_arg_results.dart';
import 'package:rapid_cli/src/commands/core/platform_x.dart';
import 'package:rapid_cli/src/commands/core/run_when.dart';
import 'package:rapid_cli/src/commands/ui/android/remove/widget/widget.dart';
import 'package:rapid_cli/src/commands/ui/ios/remove/widget/widget.dart';
import 'package:rapid_cli/src/commands/ui/linux/remove/widget/widget.dart';
import 'package:rapid_cli/src/commands/ui/macos/remove/widget/widget.dart';
import 'package:rapid_cli/src/commands/ui/web/remove/widget/widget.dart';
import 'package:rapid_cli/src/commands/ui/windows/remove/widget/widget.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/project/project.dart';

/// {@template ui_platform_remove_widget_command}
/// Base class for:
///
///  * [UiAndroidRemoveWidgetCommand]
///
///  * [UiIosRemoveWidgetCommand]
///
///  * [UiLinuxRemoveWidgetCommand]
///
///  * [UiMacosRemoveWidgetCommand]
///
///  * [UiWebRemoveWidgetCommand]
///
///  * [UiWindowsRemoveWidgetCommand]
/// {@endtemplate}
abstract class UiPlatformRemoveWidgetCommand extends Command<int>
    with OverridableArgResults, ClassNameGetter {
  /// {@macro ui_platform_remove_widget_command}
  UiPlatformRemoveWidgetCommand({
    required Platform platform,
    Logger? logger,
    Project? project,
  })  : _platform = platform,
        _logger = logger ?? Logger(),
        _project = project ?? Project();

  final Platform _platform;
  final Logger _logger;
  final Project _project;

  @override
  String get name => 'widget';

  @override
  String get invocation =>
      'rapid ui ${_platform.name} remove widget <name> [arguments]';

  @override
  String get description =>
      'Remove a widget from the ${_platform.prettyName} UI part of an existing Rapid project.';

  @override
  Future<int> run() => runWhen(
        [
          projectExistsAll(_project),
          platformIsActivated(
            _platform,
            _project,
            '${_platform.prettyName} is not activated.',
          ) // TODO good ?
        ],
        _logger,
        () async {
          final name = super.className;

          _logger.info('Removing ${_platform.prettyName} Widget ...');

          final platformUiPackage =
              _project.platformUiPackage(platform: _platform);
          // TODO remove dir completly ?
          final widget = platformUiPackage.widget(name: name, dir: '.');

          if (widget.existsAny()) {
            widget.delete();

            final themeExtensionsFile = platformUiPackage.themeExtensionsFile;
            themeExtensionsFile.removeThemeExtension(name);

            final barrelFile = platformUiPackage.barrelFile;
            barrelFile.removeExport('src/${name.snakeCase}.dart');
            barrelFile.removeExport('src/${name.snakeCase}_theme.dart');

            _logger
              ..info('')
              ..success('Removed ${_platform.prettyName} Widget $name.');

            return ExitCode.success.code;
          } else {
            _logger
              ..info('')
              ..err('${_platform.prettyName} Widget $name not found.');

            return ExitCode.config.code;
          }
        },
      );
}
