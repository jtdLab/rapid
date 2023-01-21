import 'package:args/command_runner.dart';
import 'package:mason/mason.dart';
import 'package:rapid_cli/src/commands/core/class_name_arg.dart';
import 'package:rapid_cli/src/commands/core/output_dir_option.dart';
import 'package:rapid_cli/src/commands/core/overridable_arg_results.dart';
import 'package:rapid_cli/src/commands/core/run_when.dart';
import 'package:rapid_cli/src/commands/ui/android/add/widget/widget.dart';
import 'package:rapid_cli/src/commands/ui/ios/add/widget/widget.dart';
import 'package:rapid_cli/src/commands/ui/linux/add/widget/widget.dart';
import 'package:rapid_cli/src/commands/ui/macos/add/widget/widget.dart';
import 'package:rapid_cli/src/commands/ui/web/add/widget/widget.dart';
import 'package:rapid_cli/src/commands/ui/windows/add/widget/widget.dart';
import 'package:rapid_cli/src2/core/platform.dart';
import 'package:rapid_cli/src2/project/project.dart';

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
abstract class UiPlatformAddWidgetCommand extends Command<int>
    with OverridableArgResults, ClassNameGetter, OutputDirGetter {
  /// {@macro ui_platform_add_widget_command}
  UiPlatformAddWidgetCommand({
    required Platform platform,
    Logger? logger,
    required Project project,
  })  : _platform = platform,
        _logger = logger ?? Logger(),
        _project = project {
    argParser
      ..addSeparator('')
      ..addOutputDirOption(
        help: 'The output directory relative to <platform_ui_package>/lib/ .',
      );
  }

  final Platform _platform;
  final Logger _logger;
  final Project _project;

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
          isProjectRoot(_project),
          platformIsActivated(_platform, _project),
        ],
        _logger,
        () async {
          final name = super.className;
          final outputDir = super.outputDir;

          final platformUiPackage =
              _project.platformUiPackage(platform: _platform);
          final widget = platformUiPackage.widget(name: name, dir: outputDir);
          if (!widget.exists()) {
            await widget.create(logger: _logger);

            _logger.success('Added ${_platform.prettyName} Widget $name.');

            return ExitCode.success.code;
          } else {
            _logger.err('${_platform.prettyName} Widget $name already exists.');

            return ExitCode.config.code;
          }
        },
      );
}
