import 'package:args/command_runner.dart';
import 'package:meta/meta.dart';

import 'overridable_arg_results.dart';
import 'validate_language.dart';

/// Adds `language` getter.
mixin LanguageGetter on OverridableArgResults {
  /// Gets the language specified as the first positional argument.
  @protected
  String get language => _validateLanguageArg(argResults.rest);

  /// Validates whether [args] contains a valid language as the first element.
  ///
  /// Returns the language when valid.
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
