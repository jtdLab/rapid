import 'package:args/command_runner.dart';
import 'package:mason/mason.dart';
import 'package:rapid_cli/src/commands/android/add/language/language.dart';
import 'package:rapid_cli/src/commands/core/overridable_arg_results.dart';
import 'package:rapid_cli/src/commands/core/platform/core/validate_language.dart';
import 'package:rapid_cli/src/commands/core/platform_x.dart';
import 'package:rapid_cli/src/commands/core/run_when.dart';
import 'package:rapid_cli/src/commands/ios/add/language/language.dart';
import 'package:rapid_cli/src/commands/linux/add/language/language.dart';
import 'package:rapid_cli/src/commands/macos/add/language/language.dart';
import 'package:rapid_cli/src/commands/web/add/language/language.dart';
import 'package:rapid_cli/src/commands/windows/add/language/language.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/project/project.dart';

// TODO share code with the remove lang command

/// {@template platform_add_language_command}
/// Base class for:
///
///  * [AndroidAddLanguageCommand]
///
///  * [IosAddLanguageCommand]
///
///  * [LinuxAddLanguageCommand]
///
///  * [MacosAddLanguageCommand]
///
///  * [WebAddLanguageCommand]
///
///  * [WindowsAddLanguageCommand]
/// {@endtemplate}
abstract class PlatformAddLanguageCommand extends Command<int>
    with OverridableArgResults {
  /// {@macro platform_add_language_command}
  PlatformAddLanguageCommand({
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
  String get invocation => 'rapid ${_platform.name} add language <language>';

  @override
  String get description =>
      'Add a language to the ${_platform.prettyName} part of an existing Rapid project.';

  @override
  Future<int> run() => runWhen(
        [
          projectExists(_project),
          platformIsActivated(
            _platform,
            _project,
            '${_platform.prettyName} is not activated.',
          ),
        ],
        _logger,
        () async {
          final language = _language;

          _logger.info('Adding Language ...');

          try {
            await _project.addLanguage(
              language,
              platform: _platform,
              logger: _logger,
            );

            // TODO add hint how to work with localization
            _logger
              ..info('')
              ..success(
                'Added $language to the ${_platform.prettyName} part of your project.',
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
          } on FeaturesAlreadySupportLanguage {
            _logger
              ..info('')
              ..err('The language "$language" is already present.');

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
