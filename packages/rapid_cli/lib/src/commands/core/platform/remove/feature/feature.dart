import 'package:args/command_runner.dart';
import 'package:mason/mason.dart';
import 'package:rapid_cli/src/cli/cli.dart';
import 'package:rapid_cli/src/commands/core/overridable_arg_results.dart';
import 'package:rapid_cli/src/commands/core/run_when_cwd_has_melos.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/project/project.dart';

/// {@template platform_remove_feature_command}
/// Base class for // TODO
/// {@endtemplate}
abstract class PlatformRemoveFeatureCommand extends Command<int>
    with OverridableArgResults {
  /// {@macro platform_remove_feature_command}
  PlatformRemoveFeatureCommand({
    required Platform platform,
    required Logger logger,
    required Project project,
    required MelosBootstrapCommand melosBootstrap,
    required MelosCleanCommand melosClean,
  })  : _platform = platform,
        _logger = logger,
        _project = project,
        _melosBootstrap = melosBootstrap,
        _melosClean = melosClean;

  final Logger _logger;
  final MelosBootstrapCommand _melosBootstrap;
  final MelosCleanCommand _melosClean;
  final Platform _platform;
  final Project _project;

  @override
  String get name => 'feature';

  @override
  String get description =>
      'Removes a feature from the ${_platform.prettyName} part of an existing Rapid project.';

  @override
  String get invocation => 'rapid android remove feature <name>';

  @override
  List<String> get aliases => ['feat'];

  @override
  Future<int> run() => runWhenCwdHasMelos(_project, _logger, () async {
        final platformIsActivated = _project.isActivated(_platform);

        if (platformIsActivated) {
          final name = _name;

          final platformDirectory = _project.platformDirectory(_platform);

          if (platformDirectory.featureExists(name)) {
            final featurePackage = platformDirectory.findFeature(name);
            featurePackage.delete();

            // TODO HIGH PRIO think about remove from pubspec of other packages that depend on it
            // TODO think about remove the localizations delegate of this feature from the app feature
            // TODO think about remove the feature from routing feature and regenerate it

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
              'Removed ${_platform.prettyName} feature $name.',
            );

            return ExitCode.success.code;
          } else {
            _logger.err(
              'The feature "$name" does not exist on ${_platform.prettyName}.',
            );

            return ExitCode.config.code;
          }
        } else {
          _logger.err('${_platform.prettyName} is not activated.');

          return ExitCode.config.code;
        }
      });

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
