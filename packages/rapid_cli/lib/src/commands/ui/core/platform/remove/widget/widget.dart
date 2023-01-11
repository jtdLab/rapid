import 'package:args/command_runner.dart';
import 'package:mason/mason.dart';
import 'package:rapid_cli/src/commands/core/generator_builder.dart';
import 'package:rapid_cli/src/commands/core/overridable_arg_results.dart';
import 'package:rapid_cli/src/commands/core/run_when_cwd_has_melos.dart';
import 'package:rapid_cli/src/commands/core/validate_dart_package_name.dart';
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
    with OverridableArgResults {
  /// {@macro ui_platform_remove_widget_command}
  UiPlatformRemoveWidgetCommand({
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
      'rapid ui ${_platform.name} remove widget <name> [arguments]';

  @override
  String get description =>
      'Removes a widget from the ${_platform.prettyName} UI part of an existing Rapid project.';

  @override
  Future<int> run() => runWhenCwdHasMelos(_project, _logger, () async {
        throw UnimplementedError();
/*         // TODO remove a application layer to the feature template

        final platformIsActivated = _project.isActivated(_platform);

        if (platformIsActivated) {
          final projectName = _project.melosFile.name();
          final name = _name;
          final description = _description;

          // TODO check if feature exists

          final generateProgress = _logger.progress('Generating files');
          final generator = await _generator(featureBundle);
          final files = await generator.generate(
            DirectoryGeneratorTarget(Directory('.')),
            vars: <String, dynamic>{
              'project_name': projectName,
              'name': name,
              'description': description,
              'platform': _platform.name,
              _platform.name: true
            },
            logger: _logger,
          );
          generateProgress.complete('Generated ${files.length} file(s)');

          // TODO HIGH PRIO remove the localizations delegate of this feature to the app feature

          final melosCleanProgress = _logger.progress(
            'Running "melos clean" in . ',
          );
          await _melosClean();
          melosCleanProgress.complete();
          final melosBootstrapProgress = _logger.progress(
            'Running "melos bootstrap" in . ',
          );
          await _melosBootstrap();
          melosBootstrapProgress.complete();

          _logger.success(
            'Removeed ${_platform.prettyName} feature $name.',
          );

          // TODO maybe remove hint how to register a page in the routing feature

          return ExitCode.success.code;
        } else {
          _logger.err('${_platform.prettyName} is not activated.');

          return ExitCode.config.code;
        } */
      });

  String get _name => _validateNameArg(argResults.rest);

  /// Validates whether [args] contains valid widget name.
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
    final isValid = isValidPackageName(name);
    if (!isValid) {
      throw UsageException(
        '"$name" is not a valid package name.\n\n'
        'See https://dart.dev/tools/pub/pubspec#name for more information.',
        usage,
      );
    }

    return name;
  }
}
