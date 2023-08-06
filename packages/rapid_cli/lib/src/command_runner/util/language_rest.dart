import 'package:args/command_runner.dart';
import 'package:meta/meta.dart';

import '../../project/language.dart';
import '../base.dart';
import 'validate_language.dart';

/// Adds `language` getter.
mixin LanguageGetter on RapidLeafCommand {
  /// Returns the language specified as the first positional argument.
  @protected
  Language get language => _validateLanguageArg(argResults.rest);

  Language _validateLanguageArg(List<String> args) {
    if (args.isEmpty) {
      throw UsageException(
        'No option specified for the language.',
        usage,
      );
    }

    if (args.length > 1) {
      throw UsageException('Multiple languages specified.', usage);
    }

    final language = Language.fromString(args.first);
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
