import 'package:args/command_runner.dart';
import 'package:mason/mason.dart';
import 'package:rapid_cli/src/cli/cli.dart';
import 'package:rapid_cli/src/commands/core/overridable_arg_results.dart';
import 'package:rapid_cli/src/commands/core/run_when_cwd_has_melos.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/project/project.dart';
import 'package:recase/recase.dart';

/// {@template platform_remove_feature_command}
/// Base class for // TODO
/// {@endtemplate}
abstract class PlatformRemoveFeatureCommand extends Command<int>
    with OverridableArgResults {
  /// {@macro platform_remove_feature_command}
  PlatformRemoveFeatureCommand({
    required Platform platform,
    Logger? logger,
    required Project project,
    required MelosBootstrapCommand melosBootstrap,
    required MelosCleanCommand melosClean,
  })  : _platform = platform,
        _logger = logger ?? Logger(),
        _project = project,
        _melosBootstrap = melosBootstrap,
        _melosClean = melosClean {
    argParser
      ..addSeparator('')
      ..addOption(
        'name',
        help: 'The name of the feature to remove.',
      );
  }

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
          } else {
            _logger.err(
              'The feature "$_name" does no exist on ${_platform.prettyName}.',
            );

            return ExitCode.config.code;
          }

          // TODO HIGH PRO think about remove from pubspec of other packages that depend on it
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
            'Removed ${_platform.prettyName} feature ${name.pascalCase}.',
          );

          return ExitCode.success.code;
        } else {
          _logger.err('${_platform.prettyName} is not activated.');

          return ExitCode.config.code;
        }
      });

  /// The name of the feature to remove.
  String get _name => argResults.rest.first;
}
