import 'package:args/args.dart';
import 'package:args/command_runner.dart';
import 'package:meta/meta.dart';

import 'overridable_arg_results.dart';
import 'validate_language.dart';

/// The default language.
const _defaultLanguage = 'en';

/// Adds language option.
extension LanguageOption on ArgParser {
  /// Adds `--language`, `--lang` option.
  void addLanguageOption({required String help}) {
    addOption(
      'language',
      aliases: ['lang'],
      help: help,
      defaultsTo: _defaultLanguage,
    );
  }
}

/// Adds `language` getter.
mixin LanguageGetter on OverridableArgResults {
  /// Gets language specified by the user.
  ///
  /// Returns [_defaultLanguage] when no language specified.
  @protected
  String get language =>
      _validateLanguage(argResults['language'] ?? _defaultLanguage);

  /// Validates whether [language] is valid language.
  ///
  /// Returns [language] when valid.
  String _validateLanguage(String language) {
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
