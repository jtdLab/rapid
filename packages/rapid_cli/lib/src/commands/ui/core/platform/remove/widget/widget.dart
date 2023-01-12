import 'package:args/command_runner.dart';
import 'package:mason/mason.dart';
import 'package:rapid_cli/src/commands/core/class_name_arg.dart';
import 'package:rapid_cli/src/commands/core/dir_option.dart';
import 'package:rapid_cli/src/commands/core/overridable_arg_results.dart';
import 'package:rapid_cli/src/commands/core/run_when_cwd_has_melos.dart';
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
    with OverridableArgResults, ClassNameGetter, DirGetter {
  /// {@macro ui_platform_remove_widget_command}
  UiPlatformRemoveWidgetCommand({
    required Platform platform,
    Logger? logger,
    required Project project,
  })  : _platform = platform,
        _logger = logger ?? Logger(),
        _project = project {
    argParser
      ..addSeparator('')
      ..addDirOption(
        help: 'The directory relative to <platform_ui_package>/lib/ .',
      );
  }

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
  Future<int> run() => runWhenCwdHasMelos(_project, _logger, () async {
        final platformIsActivated = _project.isActivated(_platform);

        if (platformIsActivated) {
          final name = super.className;
          final dir = super.dir;

          final platformUiPackage = _project.platformUiPackage(_platform);

          // TODO remove the source and test files

          // TODO check if feature exists

          _logger.success('Removed ${_platform.prettyName} Widget $name.');

          return ExitCode.success.code;
        } else {
          _logger.err('${_platform.prettyName} is not activated.');

          return ExitCode.config.code;
        }
      });
}
