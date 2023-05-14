import 'package:mason/mason.dart';
import 'package:rapid_cli/src/cli/cli.dart';
import 'package:rapid_cli/src/commands/core/class_name_rest.dart';
import 'package:rapid_cli/src/commands/core/command.dart';
import 'package:rapid_cli/src/commands/core/logger_x.dart';
import 'package:rapid_cli/src/commands/core/platform_x.dart';
import 'package:rapid_cli/src/commands/core/run_when.dart';
import 'package:rapid_cli/src/commands/ui/android/add/widget/widget.dart';
import 'package:rapid_cli/src/commands/ui/ios/add/widget/widget.dart';
import 'package:rapid_cli/src/commands/ui/linux/add/widget/widget.dart';
import 'package:rapid_cli/src/commands/ui/macos/add/widget/widget.dart';
import 'package:rapid_cli/src/commands/ui/web/add/widget/widget.dart';
import 'package:rapid_cli/src/commands/ui/windows/add/widget/widget.dart';
import 'package:rapid_cli/src/core/platform.dart';

// TODO add platform specific stuff to the tempalte

/// {@template ui_platform_add_widget_command}
/// Base class for:
///
///  * [UiAndroidAddWidgetCommand]
///
///  * [UiIosAddWidgetCommand]
///
///  * [UiLinuxAddWidgetCommand]
///
///  * [UiMacosAddWidgetCommand]
///
///  * [UiWebAddWidgetCommand]
///
///  * [UiWindowsAddWidgetCommand]
/// {@endtemplate}
abstract class UiPlatformAddWidgetCommand extends RapidRootCommand
    with GroupableMixin, ClassNameGetter {
  /// {@macro ui_platform_add_widget_command}
  UiPlatformAddWidgetCommand({
    required Platform platform,
    super.logger,
    super.project,
    DartFormatFixCommand? dartFormatFix,
  })  : _platform = platform,
        _dartFormatFix = dartFormatFix ?? Dart.formatFix;

  final Platform _platform;
  final DartFormatFixCommand _dartFormatFix;

  @override
  String get name => 'widget';

  @override
  String get invocation =>
      'rapid ui ${_platform.name} add widget <name> [arguments]';

  @override
  String get description =>
      'Add a widget to the ${_platform.prettyName} UI part of an existing Rapid project.';

  @override
  Future<int> run() => runWhen(
        [
          projectExistsAll(project),
          platformIsActivated(
            _platform,
            project,
            '${_platform.prettyName} is not activated.', // TODO good ?
          ),
        ],
        logger,
        () async {
          final name = super.className;

          logger.commandTitle(
            'Adding Widget "$name" (${_platform.prettyName}) ...',
          );

          final platformUiPackage =
              project.platformUiPackage(platform: _platform);
          // TODO remove dir completly ?
          final widget = platformUiPackage.widget(name: name, dir: '.');
          if (!widget.existsAny()) {
            await widget.create();

            final themeExtensionsFile = platformUiPackage.themeExtensionsFile;
            themeExtensionsFile.addThemeExtension(name);

            final barrelFile = platformUiPackage.barrelFile;
            barrelFile.addExport('src/${name.snakeCase}.dart');
            barrelFile.addExport('src/${name.snakeCase}_theme.dart');

            await _dartFormatFix(cwd: platformUiPackage.path, logger: logger);

            logger.commandSuccess();

            return ExitCode.success.code;
          } else {
            // TODO maybe log which files
            logger.commandError(
              '${_platform.prettyName} Widget $name already exists.',
            );

            return ExitCode.config.code;
          }
        },
      );
}
