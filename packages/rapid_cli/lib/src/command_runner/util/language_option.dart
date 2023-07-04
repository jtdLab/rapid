import 'package:args/args.dart';
import 'package:args/command_runner.dart';
import 'package:meta/meta.dart';
import 'package:rapid_cli/src/language.dart';

import '../base.dart';
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
mixin LanguageGetter on RapidLeafCommand {
  /// Gets language specified by the user.
  ///
  /// Returns [_defaultLanguage] when no language specified.
  @protected
  Language get language =>
      _validateLanguage(argResults['language'] ?? _defaultLanguage);

  /// Validates whether [raw] is valid language.
  ///
  /// Returns parsed language when valid.
  Language _validateLanguage(String raw) {
    final language = Language.fromString(raw);
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
