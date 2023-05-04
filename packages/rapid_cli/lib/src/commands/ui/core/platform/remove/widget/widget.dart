import 'package:mason/mason.dart';
import 'package:rapid_cli/src/commands/core/class_name_rest.dart';
import 'package:rapid_cli/src/commands/core/command.dart';
import 'package:rapid_cli/src/commands/core/platform_x.dart';
import 'package:rapid_cli/src/commands/core/run_when.dart';
import 'package:rapid_cli/src/commands/ui/android/remove/widget/widget.dart';
import 'package:rapid_cli/src/commands/ui/ios/remove/widget/widget.dart';
import 'package:rapid_cli/src/commands/ui/linux/remove/widget/widget.dart';
import 'package:rapid_cli/src/commands/ui/macos/remove/widget/widget.dart';
import 'package:rapid_cli/src/commands/ui/web/remove/widget/widget.dart';
import 'package:rapid_cli/src/commands/ui/windows/remove/widget/widget.dart';
import 'package:rapid_cli/src/core/platform.dart';

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
abstract class UiPlatformRemoveWidgetCommand extends RapidRootCommand
    with GroupableMixin, ClassNameGetter {
  /// {@macro ui_platform_remove_widget_command}
  UiPlatformRemoveWidgetCommand({
    required Platform platform,
    super.logger,
    super.project,
  }) : _platform = platform;

  final Platform _platform;

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
          projectExistsAll(project),
          platformIsActivated(
            _platform,
            project,
            '${_platform.prettyName} is not activated.',
          ) // TODO good ?
        ],
        logger,
        () async {
          final name = super.className;

          logger.info('Removing ${_platform.prettyName} Widget ...');

          final platformUiPackage =
              project.platformUiPackage(platform: _platform);
          // TODO remove dir completly ?
          final widget = platformUiPackage.widget(name: name, dir: '.');

          if (widget.existsAny()) {
            widget.delete();

            final themeExtensionsFile = platformUiPackage.themeExtensionsFile;
            themeExtensionsFile.removeThemeExtension(name);

            final barrelFile = platformUiPackage.barrelFile;
            barrelFile.removeExport('src/${name.snakeCase}.dart');
            barrelFile.removeExport('src/${name.snakeCase}_theme.dart');

            logger
              ..info('')
              ..success('Removed ${_platform.prettyName} Widget $name.');

            return ExitCode.success.code;
          } else {
            logger
              ..info('')
              ..err('${_platform.prettyName} Widget $name not found.');

            return ExitCode.config.code;
          }
        },
      );
}
