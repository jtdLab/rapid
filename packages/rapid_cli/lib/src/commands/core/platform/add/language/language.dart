import 'package:args/command_runner.dart';
import 'package:mason/mason.dart';
import 'package:rapid_cli/src/commands/core/run_when_cwd_has_melos.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/project/project.dart';

/// {@template platform_add_language_command}
/// Base class for TODO
/// {@endtemplate}
abstract class PlatformAddLanguageCommand extends Command<int> {
  /// {@macro platform_add_language_command}
  PlatformAddLanguageCommand({
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
      'Adds a language to the ${_platform.prettyName} part of an existing Rapid project.';

  @override
  List<String> get aliases => ['lang'];

  @override
  Future<int> run() => runWhenCwdHasMelos(_project, _logger, () async {
        final platformIsActivated = _project.isActivated(_platform);

        if (platformIsActivated) {
          // TODO impl
          // for every feature except app / routing
          // check if langague does not exist
          // if true:
          // Add files + run flutter gen-l10n
          // lib/src/presentation/l10n

          // TODO add hint how to work with localization
          return ExitCode.success.code;
        } else {
          _logger.err('${_platform.prettyName} is not activated.');

          return ExitCode.config.code;
        }
      });
}
