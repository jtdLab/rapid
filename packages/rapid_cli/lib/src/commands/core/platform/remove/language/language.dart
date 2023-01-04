import 'package:args/command_runner.dart';
import 'package:mason/mason.dart';
import 'package:rapid_cli/src/cli/cli.dart';
import 'package:rapid_cli/src/commands/core/overridable_arg_results.dart';
import 'package:rapid_cli/src/commands/core/run_when_cwd_has_melos.dart';
import 'package:rapid_cli/src/commands/core/validate_language.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/project/project.dart';

/// {@template platform_remove_language_command}
/// Base class for // TODO
/// {@endtemplate}
abstract class PlatformRemoveLanguageCommand extends Command<int>
    with OverridableArgResults {
  /// {@macro platform_remove_language_command}
  PlatformRemoveLanguageCommand({
    required Platform platform,
    required Logger logger,
    required Project project,
    required FlutterGenl10nCommand flutterGenl10n,
  })  : _platform = platform,
        _logger = logger,
        _project = project,
        _flutterGenl10n = flutterGenl10n;

  final Logger _logger;
  final Platform _platform;
  final Project _project;
  final FlutterGenl10nCommand _flutterGenl10n;

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
          final language = _language;
          final platformDirectory = _project.platformDirectory(_platform);
          final features =
              platformDirectory.getFeatures(exclude: {'app', 'routing'});

          for (final feature in features) {
            if (feature.supportsLanguage(language)) {
              if (language != feature.defaultLanguage()) {
                final arbFile = feature.findArbFileByLanguage(language);
                arbFile.delete();

                await _flutterGenl10n(cwd: feature.path);
              } else {
                // TODO dont return but collect the failed features
                // TODO hint that the user has to first chanage the default language of the platform

                return ExitCode.config.code;
              }
            } else {
              // TODO dont return but collect the failed features
              // TODO hint the user that the language is not present on the platform
              return ExitCode.config.code;
            }
          }

          return ExitCode.success.code;
        } else {
          _logger.err('${_platform.prettyName} is not activated.');

          return ExitCode.config.code;
        }
      });

  String get _language => _validateLanguageArg(argResults.rest);

  /// Validates whether [language] is valid language.
  ///
  /// Returns [language] when valid.
  String _validateLanguageArg(List<String> args) {
    if (args.isEmpty) {
      throw UsageException(
        'No option specified for the language.',
        usage,
      );
    }

    if (args.length > 1) {
      throw UsageException('Multiple languages specified.', usage);
    }

    final language = args.first;
    final isValid = validateLanguage(language);
    if (!isValid) {
      throw UsageException(
        '"$language" is not a valid language.\n\n'
        'See https://www.iana.org/assignments/language-subtag-registry/language-subtag-registry for more information.',
        usage,
      );
    }

    return language;
  }
}
