import 'package:mason/mason.dart';
import 'package:meta/meta.dart';

// TODO(jtdLab): .fromUnicodeCLDRLocaleIdentifier is not implemented 100%

/// {@template language}
/// Abstraction of a language.
/// {@endtemplate}
@immutable
class Language implements Comparable<Language> {
  /// {@macro language}
  const Language({
    required this.languageCode,
    this.scriptCode,
    this.countryCode,
  });

  /// Returns a language from a
  /// [Unicode CLDR locale identifier](https://www.unicode.org/reports/tr35/#Unicode_language_identifier).
  ///
  /// Hint: language code should be specified in order for current
  /// implementation to work properly.
  factory Language.fromUnicodeCLDRLocaleIdentifier(String raw) {
    final parts = raw.split('_');
    if (parts.length == 1) {
      return Language(
        languageCode: parts.first,
      );
    } else if (parts.length == 2) {
      if (parts.last.isUppercased) {
        return Language(
          languageCode: parts.first,
          countryCode: parts.last,
        );
      } else {
        return Language(
          languageCode: parts.first,
          scriptCode: parts.last,
        );
      }
    } else {
      return Language(
        languageCode: parts.first,
        scriptCode: parts[1],
        countryCode: parts.last,
      );
    }
  }

  /// Returns a [Language] from the provided [raw] string.
  ///
  /// The [raw] string is expected to be a representation
  /// of a [Locale](https://api.flutter.dev/flutter/dart-ui/Locale-class.html)
  /// in dart source code.
  factory Language.fromDartUiLocal(String raw) {
    raw = raw.replaceAll('\r', '').replaceAll(RegExp(r'\s*'), '');
    RegExpMatch? match;

    match = RegExp(
      r'''Locale\((['"](?<languageCode>[A-z]+)['"]),?(['"](?<countryCode>[A-z]+)['"])?,?\)''',
    ).firstMatch(raw);
    if (match != null) {
      return Language(
        languageCode: match.namedGroup('languageCode')!,
        countryCode: match.namedGroup('countryCode'),
      );
    }

    match =
        RegExp(r'''Locale.fromSubtags\((?<params>[\s\S]*)\)''').firstMatch(raw);
    if (match != null) {
      final params = match.namedGroup('params')!;
      final languageCodeMatch =
          RegExp('''languageCode:['"](?<languageCode>[A-z]+)['"]''')
              .firstMatch(params);
      final scriptCodeMatch =
          RegExp('''scriptCode:['"](?<scriptCode>[A-z]+)['"]''')
              .firstMatch(params);
      final countryCodeMatch =
          RegExp('''countryCode:['"](?<countryCode>[A-z]+)['"]''')
              .firstMatch(params);

      return Language(
        languageCode: languageCodeMatch?.namedGroup('languageCode') ?? 'und',
        scriptCode: scriptCodeMatch?.namedGroup('scriptCode'),
        countryCode: countryCodeMatch?.namedGroup('countryCode'),
      );
    }

    throw ArgumentError.value(raw, 'raw', 'Does not contain parsable Locale');
  }

  /// The language code.
  /// See valid values [here](https://github.com/unicode-org/cldr/blob/maint/maint-41/common/validity/language.xml).
  final String languageCode;

  /// The optional script code.
  /// See valid values [here](https://github.com/unicode-org/cldr/blob/maint/maint-41/common/validity/script.xml).
  final String? scriptCode;

  /// The optional country code.
  /// See valid values [here](https://github.com/unicode-org/cldr/blob/maint/maint-41/common/validity/region.xml).
  final String? countryCode;

  /// Wheter this language has a script code.
  bool get hasScriptCode => scriptCode != null;

  /// Wheter this language has a country code.
  bool get hasCountryCode => countryCode != null;

  /// Returns a string representation of this language
  /// with the specified [seperator].
  String toStringWithSeperator([String seperator = '_']) {
    final scriptCodeSegment = scriptCode != null ? '$seperator$scriptCode' : '';
    final countryCodeSegment =
        countryCode != null ? '$seperator$countryCode' : '';
    return '$languageCode$scriptCodeSegment$countryCodeSegment';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Language &&
        other.languageCode == languageCode &&
        other.scriptCode == scriptCode &&
        other.countryCode == countryCode;
  }

  @override
  int get hashCode => Object.hash(languageCode, scriptCode, countryCode);

  @override
  String toString() => toStringWithSeperator();

  @override
  int compareTo(Language other) {
    if (languageCode != other.languageCode) {
      return languageCode.compareTo(other.languageCode);
    }
    if (scriptCode != null &&
        other.scriptCode != null &&
        scriptCode != other.scriptCode) {
      return scriptCode!.compareTo(other.scriptCode!);
    }
    if (countryCode != null &&
        other.countryCode != null &&
        countryCode != other.countryCode) {
      return countryCode!.compareTo(other.countryCode!);
    }
    return 0;
  }
}

extension on String {
  bool get isUppercased => this == upperCase;
}
