import 'package:args/command_runner.dart';
import 'package:mason/mason.dart';
import 'package:rapid_cli/src/commands/core/generator_builder.dart';
import 'package:rapid_cli/src/commands/core/overridable_arg_results.dart';
import 'package:rapid_cli/src/commands/core/run_when_cwd_has_melos.dart';
import 'package:rapid_cli/src/commands/core/validate_class_name.dart';
import 'package:rapid_cli/src/commands/ui/android/add/widget/widget.dart';
import 'package:rapid_cli/src/commands/ui/core/platform/add/widget/widget_bundle.dart';
import 'package:rapid_cli/src/commands/ui/ios/add/widget/widget.dart';
import 'package:rapid_cli/src/commands/ui/linux/add/widget/widget.dart';
import 'package:rapid_cli/src/commands/ui/macos/add/widget/widget.dart';
import 'package:rapid_cli/src/commands/ui/web/add/widget/widget.dart';
import 'package:rapid_cli/src/commands/ui/windows/add/widget/widget.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/project/project.dart';
import 'package:universal_io/io.dart';

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
    with OverridableArgResults {
  /// {@macro ui_platform_add_widget_command}
  UiPlatformAddWidgetCommand({
    required Platform platform,
    Logger? logger,
    required Project project,
    GeneratorBuilder? generator,
  })  : _platform = platform,
        _logger = logger ?? Logger(),
        _project = project,
        _generator = generator ?? MasonGenerator.fromBundle;

  final Platform _platform;
  final Logger _logger;
  final Project _project;

  final GeneratorBuilder _generator;

  @override
  String get name => 'widget';

  @override
  String get invocation =>
      'rapid ui ${_platform.name} add widget <name> [arguments]';

  @override
  String get description =>
      'Adds a widget to the ${_platform.prettyName} UI part of an existing Rapid project.';

  @override
  Future<int> run() => runWhenCwdHasMelos(_project, _logger, () async {
        final platformIsActivated = _project.isActivated(_platform);

        if (platformIsActivated) {
          final projectName = _project.melosFile.name();
          final name = _name;
          final outputDir = '.'; // TODO

          // TODO check if widget already exists

          final generateProgress = _logger.progress('Generating files');
          final generator = await _generator(widgetBundle);
          final files = await generator.generate(
            DirectoryGeneratorTarget(
              Directory(_project.platformUiPackage(_platform).path),
            ),
            vars: <String, dynamic>{
              'project_name': projectName,
              'name': name,
              'output_dir': outputDir,
            },
            logger: _logger,
          );
          generateProgress.complete('Generated ${files.length} file(s)');

          _logger.success(
            'Added ${_platform.prettyName} widget $name.',
          );

          return ExitCode.success.code;
        } else {
          _logger.err('${_platform.prettyName} is not activated.');

          return ExitCode.config.code;
        }
      });

  String get _name => _validateNameArg(argResults.rest);

  /// Validates whether [args] is valid widget name.
  ///
  /// Returns the name when valid.
  String _validateNameArg(List<String> args) {
    if (args.isEmpty) {
      throw UsageException(
        'No option specified for the name.',
        usage,
      );
    }

    if (args.length > 1) {
      throw UsageException('Multiple names specified.', usage);
    }

    final name = args.first;
    final isValid = isValidClassName(name);
    if (!isValid) {
      throw UsageException(
        '"$name" is not a valid dart class name.',
        usage,
      );
    }

    return name;
  }
}
