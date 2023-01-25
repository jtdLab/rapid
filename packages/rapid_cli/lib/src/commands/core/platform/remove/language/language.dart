import 'package:args/command_runner.dart';
import 'package:mason/mason.dart';
import 'package:rapid_cli/src/commands/android/remove/language/language.dart';
import 'package:rapid_cli/src/commands/core/overridable_arg_results.dart';
import 'package:rapid_cli/src/commands/core/platform/core/validate_language.dart';
import 'package:rapid_cli/src/commands/core/run_when.dart';
import 'package:rapid_cli/src/commands/ios/remove/language/language.dart';
import 'package:rapid_cli/src/commands/linux/remove/language/language.dart';
import 'package:rapid_cli/src/commands/macos/remove/language/language.dart';
import 'package:rapid_cli/src/commands/web/remove/language/language.dart';
import 'package:rapid_cli/src/commands/windows/remove/language/language.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/project/project.dart';

/// {@template platform_remove_language_command}
/// Base class for:
///
///  * [AndroidRemoveLanguageCommand]
///
///  * [IosRemoveLanguageCommand]
///
///  * [LinuxRemoveLanguageCommand]
///
///  * [MacosRemoveLanguageCommand]
///
///  * [WebRemoveLanguageCommand]
///
///  * [WindowsRemoveLanguageCommand]
/// {@endtemplate}
abstract class PlatformRemoveLanguageCommand extends Command<int>
    with OverridableArgResults {
  /// {@macro platform_remove_language_command}
  PlatformRemoveLanguageCommand({
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
  String get name => 'language';

  @override
  List<String> get aliases => ['lang'];

  @override
  String get invocation => 'rapid ${_platform.name} remove language <language>';

  @override
  String get description =>
      'Removes a language from the ${_platform.prettyName} part of an existing Rapid project.';

  @override
  Future<int> run() => runWhen(
        [
          projectExists(_project),
          platformIsActivated(_platform, _project),
        ],
        _logger,
        () async {
          final language = _language;

          try {
            await _project.removeLanguage(
              language,
              platform: _platform,
              logger: _logger,
            );

            _logger
              ..info('')
              ..success(
                'Removed $language from the ${_platform.prettyName} part of your project.',
              );

            return ExitCode.success.code;
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
                'Run "rapid doctor" to see which features are affected.',
              );

            return ExitCode.config.code;
          } on FeaturesHaveDiffrentDefaultLanguage {
            _logger
              ..info('')
              ..err(
                'The ${_platform.prettyName} part of your project is corrupted.\n'
                'Because not all features have the same default language.\n\n'
                'Run "rapid doctor" to see which features are affected.',
              );

            return ExitCode.config.code;
          } on FeaturesDoNotSupportLanguage {
            // TODO better hint
            _logger
              ..info('')
              ..err('The language "$language" is not present.');

            return ExitCode.config.code;
          } on UnableToRemoveDefaultLanguage {
            // TODO add hint how to change default language
            _logger
              ..info('')
              ..err(
                'Can not remove language "$language" because it is the default language.',
              );

            return ExitCode.config.code;
          }
        },
      );

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
