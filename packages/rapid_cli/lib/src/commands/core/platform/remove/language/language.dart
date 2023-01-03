import 'package:args/command_runner.dart';
import 'package:mason/mason.dart';
import 'package:rapid_cli/src/commands/core/run_when_cwd_has_melos.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/project/project.dart';

/// {@template platform_remove_language_command}
/// Base class for // TODO
/// {@endtemplate}
abstract class PlatformRemoveLanguageCommand extends Command<int> {
  /// {@macro platform_remove_language_command}
  PlatformRemoveLanguageCommand({
    required Platform platform,
    required Logger logger,
    required Project project,
  })  : _platform = platform,
        _logger = logger,
        _project = project;

  final Logger _logger;
  final Platform _platform;
  final Project _project;

  @override
  String get name => 'language';

  @override
  String get description =>
      'Removes a language from the ${_platform.prettyName} part of an existing Rapid project.';

  @override
  String get invocation => 'rapid ${_platform.name} remove language <language>';

  @override
  List<String> get aliases => ['lang'];

  @override
  Future<int> run() => runWhenCwdHasMelos(_project, _logger, () async {
        final platformIsActivated = _project.isActivated(_platform);

        if (platformIsActivated) {
          // TODO impl
          // for every feature except app / routing
          // check if langague does exist
          // if true:
          // Remove files + run flutter gen-l10n
          // lib/src/presentation/l10n

          return ExitCode.success.code;
        } else {
          _logger.err('${_platform.prettyName} is not activated.');

          return ExitCode.config.code;
        }
      });
}
