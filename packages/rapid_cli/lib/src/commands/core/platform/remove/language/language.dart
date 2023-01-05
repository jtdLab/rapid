import 'package:args/command_runner.dart';
import 'package:collection/collection.dart';
import 'package:mason/mason.dart';
import 'package:rapid_cli/src/cli/cli.dart';
import 'package:rapid_cli/src/commands/android/remove/language/language.dart';
import 'package:rapid_cli/src/commands/core/overridable_arg_results.dart';
import 'package:rapid_cli/src/commands/core/run_when_cwd_has_melos.dart';
import 'package:rapid_cli/src/commands/core/validate_language.dart';
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
    FlutterGenl10nCommand? flutterGenl10n,
  })  : _platform = platform,
        _logger = logger ?? Logger(),
        _project = project,
        _flutterGenl10n = flutterGenl10n ?? Flutter.genl10n;

  final Platform _platform;
  final Logger _logger;
  final Project _project;
  final FlutterGenl10nCommand _flutterGenl10n;

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
  Future<int> run() => runWhenCwdHasMelos(_project, _logger, () async {
        final platformIsActivated = _project.isActivated(_platform);

        if (platformIsActivated) {
          final language = _language;
          final platformDirectory = _project.platformDirectory(_platform);
          final features =
              platformDirectory.getFeatures(exclude: {'app', 'routing'});

          if (features.isEmpty) {
            _logger.err('No ${_platform.prettyName} features found!\n'
                'Run "rapid ${_platform.name} add feature" to add your first ${_platform.prettyName} feature.');

            return ExitCode.config.code;
          }

          final allFeaturesHaveSameLanguages = EqualitySet.from(
                  DeepCollectionEquality.unordered(),
                  features.map((e) => e.supportedLanguages())).length ==
              1;

          if (allFeaturesHaveSameLanguages) {
            final allFeaturesHaveSameDefaultLanguage =
                features.map((e) => e.defaultLanguage()).toSet().length == 1;
            if (allFeaturesHaveSameDefaultLanguage) {
              if (features.first.supportsLanguage(language)) {
                if (features.first.defaultLanguage() != language) {
                  for (final feature in features) {
                    final arbFile = feature.findArbFileByLanguage(language);
                    arbFile.delete();

                    await _flutterGenl10n(cwd: feature.path);
                  }

                  // TODO add hint how to work with localization
                  return ExitCode.success.code;
                } else {
                  _logger.err(
                      'Can not remove language "$language" because it is the default language.');
                  // TODO add hint how to change default language

                  return ExitCode.config.code;
                }
              } else {
                _logger.err(
                    'The language "$language" is not present.'); // TODO better hint

                return ExitCode.config.code;
              }
            } else {
              _logger.err(
                  'The ${_platform.prettyName} part of your project is corrupted.\n'
                  'Because not all features have the same default language.\n\n'
                  'Run "rapid doctor" to see which features are affected.');

              return ExitCode.config.code;
            }
          } else {
            _logger.err(
                'The ${_platform.prettyName} part of your project is corrupted.\n'
                'Because not all features support the same languages.\n\n'
                'Run "rapid doctor" to see which features are affected.');

            return ExitCode.config.code;
          }
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
