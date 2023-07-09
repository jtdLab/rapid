import 'package:mason/mason.dart';

class Language implements Comparable<Language> {
  final String languageCode;
  final String? scriptCode;
  final String? countryCode;

  const Language({
    required this.languageCode,
    this.scriptCode,
    this.countryCode,
  });

  factory Language.fromString(String raw) {
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

  bool get hasScriptCode => scriptCode != null;

  bool get hasCountryCode => countryCode != null;

  String toStringWithSeperator([String seperator = '_']) {
    final scriptCodeSegment = scriptCode != null ? '_$scriptCode' : '';
    final countryCodeSegment = countryCode != null ? '_$countryCode' : '';
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
