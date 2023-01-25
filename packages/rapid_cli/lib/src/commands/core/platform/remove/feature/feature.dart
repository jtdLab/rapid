import 'package:args/command_runner.dart';
import 'package:mason/mason.dart';
import 'package:rapid_cli/src/cli/cli.dart';
import 'package:rapid_cli/src/commands/android/remove/feature/feature.dart';
import 'package:rapid_cli/src/commands/core/overridable_arg_results.dart';
import 'package:rapid_cli/src/commands/core/run_when.dart';
import 'package:rapid_cli/src/commands/ios/remove/feature/feature.dart';
import 'package:rapid_cli/src/commands/linux/remove/feature/feature.dart';
import 'package:rapid_cli/src/commands/macos/remove/feature/feature.dart';
import 'package:rapid_cli/src/commands/web/remove/feature/feature.dart';
import 'package:rapid_cli/src/commands/windows/remove/feature/feature.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/project/project.dart';

/// {@template platform_remove_feature_command}
/// Base class for:
///
///  * [AndroidRemoveFeatureCommand]
///
///  * [IosRemoveFeatureCommand]
///
///  * [LinuxRemoveFeatureCommand]
///
///  * [MacosRemoveFeatureCommand]
///
///  * [WebRemoveFeatureCommand]
///
///  * [WindowsRemoveFeatureCommand]
/// {@endtemplate}
abstract class PlatformRemoveFeatureCommand extends Command<int>
    with OverridableArgResults {
  /// {@macro platform_remove_feature_command}
  PlatformRemoveFeatureCommand({
    required Platform platform,
    Logger? logger,
    required Project project,
    MelosBootstrapCommand? melosBootstrap,
    MelosCleanCommand? melosClean,
  })  : _platform = platform,
        _logger = logger ?? Logger(),
        _project = project,
        _melosBootstrap = melosBootstrap ?? Melos.bootstrap,
        _melosClean = melosClean ?? Melos.clean;

  final Platform _platform;
  final Logger _logger;
  final Project _project;
  final MelosBootstrapCommand _melosBootstrap;
  final MelosCleanCommand _melosClean;

  @override
  String get name => 'feature';

  @override
  List<String> get aliases => ['feat'];

  @override
  String get invocation => 'rapid ${_platform.name} remove feature <name>';

  @override
  String get description =>
      'Removes a feature from the ${_platform.prettyName} part of an existing Rapid project.';

  @override
  Future<int> run() => runWhen(
        [
          projectExists(_project),
          platformIsActivated(_platform, _project),
        ],
        _logger,
        () async {
          final name = _name;

          try {
            await _project.removeFeature(
              name: name,
              platform: _platform,
              logger: _logger,
            );

            _logger
              ..info('')
              ..success('Removed ${_platform.prettyName} feature $name.');

            return ExitCode.success.code;
          } on FeatureDoesNotExist {
            _logger
              ..info('')
              ..err(
                'The feature "$name" does not exist on ${_platform.prettyName}.',
              );

            return ExitCode.config.code;
          }
        },
      );

  String get _name => _validateNameArg(argResults.rest);

  /// Validates whether [name] is valid feature name.
  ///
  /// Returns [name] when valid.
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

    return args.first;
  }
}
