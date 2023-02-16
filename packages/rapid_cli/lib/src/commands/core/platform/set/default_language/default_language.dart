import 'package:args/command_runner.dart';
import 'package:mason/mason.dart';
import 'package:rapid_cli/src/commands/android/set/default_language/default_language.dart';
import 'package:rapid_cli/src/commands/core/overridable_arg_results.dart';
import 'package:rapid_cli/src/commands/core/platform_x.dart';
import 'package:rapid_cli/src/commands/core/run_when.dart';
import 'package:rapid_cli/src/commands/core/validate_language.dart';
import 'package:rapid_cli/src/commands/ios/set/default_language/default_language.dart';
import 'package:rapid_cli/src/commands/linux/set/default_language/default_language.dart';
import 'package:rapid_cli/src/commands/macos/set/default_language/default_language.dart';
import 'package:rapid_cli/src/commands/web/set/default_language/default_language.dart';
import 'package:rapid_cli/src/commands/windows/set/default_language/default_language.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/project/project.dart';

/// {@template platform_set_default_language_command}
/// Base class for:
///
///  * [AndroidSetDefaultLanguageCommand]
///
///  * [IosSetDefaultLanguageCommand]
///
///  * [LinuxSetDefaultLanguageCommand]
///
///  * [MacosSetDefaultLanguageCommand]
///
///  * [WebSetDefaultLanguageCommand]
///
///  * [WindowsSetDefaultLanguageCommand]
/// {@endtemplate}
abstract class PlatformSetDefaultLanguageCommand extends Command<int>
    with OverridableArgResults {
  /// {@macro platform_set_default_language_command}
  PlatformSetDefaultLanguageCommand({
    required Platform platform,
    Logger? logger,
    required Project project,
  })  : _platform = platform,
        _logger = logger ?? Logger(),
        _project = project;

  final Platform _platform;
  final Logger _logger;
  final Project _project;

  @override
  String get name => 'default_language';

  @override
  List<String> get aliases => ['default_lang'];

  @override
  String get invocation =>
      'rapid ${_platform.name} set default_language <language>';

  @override
  String get description =>
      'Set the default language of the ${_platform.prettyName} part of an existing Rapid project.';

  @override
  Future<int> run() => runWhen(
        [
          projectExistsAll(_project),
          platformIsActivated(
            _platform,
            _project,
            '${_platform.prettyName} is not activated.',
          ),
        ],
        _logger,
        () async {
          final language = _language;

          _logger.info('Setting default language ...');

          try {
            await _project.setDefaultLanguage(
              language,
              platform: _platform,
              logger: _logger,
            );

            // TODO add hint how to work with localization
            _logger
              ..info('')
              ..success(
                'Set $language as the default language of the ${_platform.prettyName} part of your project.',
              );

            return ExitCode.success.code;
            // TODO Share error messages
          } on NoFeaturesFound {
            _logger
              ..info('')
              ..err(
                'No ${_platform.prettyName} features found!\n'
                'Run "rapid ${_platform.name} add feature" to add your first ${_platform.prettyName} feature.',
              );

            return ExitCode.config.code;
          } on FeaturesHaveDiffrentLanguages {
            _logger
              ..info('')
              ..err(
                  'The ${_platform.prettyName} part of your project is corrupted.\n'
                  'Because not all features support the same languages.\n\n'
                  'Run "rapid doctor" to see which features are affected.');

            return ExitCode.config.code;
          } on FeaturesHaveDiffrentDefaultLanguage {
            _logger
              ..info('')
              ..err(
                  'The ${_platform.prettyName} part of your project is corrupted.\n'
                  'Because not all features have the same default language.\n\n'
                  'Run "rapid doctor" to see which features are affected.');

            return ExitCode.config.code;
          } on FeaturesDoNotSupportLanguage {
            // TODO better hint
            _logger
              ..info('')
              ..err('The language "$language" is not present.');

            return ExitCode.config.code;
          } on DefaultLanguageAlreadySetToRequestedLanguage {
            _logger
              ..info('')
              ..err(
                'The language "$language" already is the default language.',
              );

            return ExitCode.config.code;
          }
        },
      );

  String get _language => _validateLanguageArg(argResults.rest);

  // TODO share with other commands

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
    final isValid = isValidLanguage(language);
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
