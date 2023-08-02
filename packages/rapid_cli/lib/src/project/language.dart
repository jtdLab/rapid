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

  /// Creates a [Language] by extracting it from the provided [raw] string.
  ///
  /// The [raw] string is expected to be a representation
  /// of a [Locale](https://api.flutter.dev/flutter/dart-ui/Locale-class.html) in dart code.
  factory Language.fromDartUiLocal(String raw) {
    raw = raw
        .replaceAll('\r\n', '')
        .replaceAll('\n', '')
        .replaceAll(RegExp(r'\s\s+'), '');
    final RegExpMatch match;
    if (RegExp(r"Locale\('([A-z]+)',?\)").hasMatch(raw)) {
      match = RegExp(r"Locale\('([A-z]+)',?\)").firstMatch(raw)!;
      return Language(languageCode: match.group(1)!);
    } else if (RegExp(r"Locale\('([A-z]+)', '([A-z]+)',?\)").hasMatch(raw)) {
      match = RegExp(r"Locale\('([A-z]+)', '([A-z]+)',?\)").firstMatch(raw)!;
      return Language(
          languageCode: match.group(1)!, countryCode: match.group(2)!);
    } else if (RegExp(r"Locale.fromSubtags\(,?\)").hasMatch(raw)) {
      match = RegExp(r"Locale.fromSubtags\(,?\)").firstMatch(raw)!;
      return Language(languageCode: 'und');
    } else if (RegExp(r"Locale.fromSubtags\(languageCode: '([A-z]+)',?\)")
        .hasMatch(raw)) {
      match = RegExp(r"Locale.fromSubtags\(languageCode: '([A-z]+)',?\)")
          .firstMatch(raw)!;
      return Language(languageCode: match.group(1)!);
    } else if (RegExp(r"Locale.fromSubtags\(countryCode: '([A-z]+)',?\)")
        .hasMatch(raw)) {
      match = RegExp(r"Locale.fromSubtags\(countryCode: '([A-z]+)',?\)")
          .firstMatch(raw)!;
      return Language(languageCode: 'und', countryCode: match.group(1)!);
    } else if (RegExp(r"Locale.fromSubtags\(scriptCode: '([A-z]+)',?\)")
        .hasMatch(raw)) {
      match = RegExp(r"Locale.fromSubtags\(scriptCode: '([A-z]+)',?\)")
          .firstMatch(raw)!;
      return Language(languageCode: 'und', scriptCode: match.group(1)!);
    } else if (RegExp(r"Locale.fromSubtags\(languageCode: '([A-z]+)', countryCode: '([A-z]+)',?\)")
        .hasMatch(raw)) {
      match = RegExp(
              r"Locale.fromSubtags\(languageCode: '([A-z]+)', countryCode: '([A-z]+)',?\)")
          .firstMatch(raw)!;
      return Language(
          languageCode: match.group(1)!, countryCode: match.group(2)!);
    } else if (RegExp(r"Locale.fromSubtags\(languageCode: '([A-z]+)', scriptCode: '([A-z]+)',?\)")
        .hasMatch(raw)) {
      match = RegExp(
              r"Locale.fromSubtags\(languageCode: '([A-z]+)', scriptCode: '([A-z]+)',?\)")
          .firstMatch(raw)!;
      return Language(
          languageCode: match.group(1)!, scriptCode: match.group(2)!);
    } else if (RegExp(r"Locale.fromSubtags\(countryCode: '([A-z]+)', languageCode: '([A-z]+)',?\)")
        .hasMatch(raw)) {
      match = RegExp(
              r"Locale.fromSubtags\(countryCode: '([A-z]+)', languageCode: '([A-z]+)',?\)")
          .firstMatch(raw)!;
      return Language(
          countryCode: match.group(1)!, languageCode: match.group(2)!);
    } else if (RegExp(r"Locale.fromSubtags\(countryCode: '([A-z]+)', scriptCode: '([A-z]+)',?\)")
        .hasMatch(raw)) {
      match = RegExp(
              r"Locale.fromSubtags\(countryCode: '([A-z]+)', scriptCode: '([A-z]+)',?\)")
          .firstMatch(raw)!;
      return Language(
        languageCode: 'und',
        countryCode: match.group(1)!,
        scriptCode: match.group(2)!,
      );
    } else if (RegExp(r"Locale.fromSubtags\(scriptCode: '([A-z]+)', languageCode: '([A-z]+)',?\)")
        .hasMatch(raw)) {
      match = RegExp(
              r"Locale.fromSubtags\(scriptCode: '([A-z]+)', languageCode: '([A-z]+)',?\)")
          .firstMatch(raw)!;
      return Language(
          scriptCode: match.group(1)!, languageCode: match.group(2)!);
    } else if (RegExp(r"Locale.fromSubtags\(scriptCode: '([A-z]+)', countryCode: '([A-z]+)',?\)")
        .hasMatch(raw)) {
      match = RegExp(
              r"Locale.fromSubtags\(scriptCode: '([A-z]+)', countryCode: '([A-z]+)',?\)")
          .firstMatch(raw)!;
      return Language(
        languageCode: 'und',
        scriptCode: match.group(1)!,
        countryCode: match.group(2)!,
      );
    } else if (RegExp(r"Locale.fromSubtags\(languageCode: '([A-z]+)', countryCode: '([A-z]+)', scriptCode: '([A-z]+)',?\)")
        .hasMatch(raw)) {
      match = RegExp(
              r"Locale.fromSubtags\(languageCode: '([A-z]+)', countryCode: '([A-z]+)', scriptCode: '([A-z]+)',?\)")
          .firstMatch(raw)!;
      return Language(
        languageCode: match.group(1)!,
        countryCode: match.group(2)!,
        scriptCode: match.group(3)!,
      );
    } else if (RegExp(r"Locale.fromSubtags\(languageCode: '([A-z]+)', scriptCode: '([A-z]+)', countryCode: '([A-z]+)',?\)")
        .hasMatch(raw)) {
      match = RegExp(
              r"Locale.fromSubtags\(languageCode: '([A-z]+)', scriptCode: '([A-z]+)', countryCode: '([A-z]+)',?\)")
          .firstMatch(raw)!;
      return Language(
        languageCode: match.group(1)!,
        scriptCode: match.group(2)!,
        countryCode: match.group(3)!,
      );
    } else if (RegExp(r"Locale.fromSubtags\(countryCode: '([A-z]+)', languageCode: '([A-z]+)', scriptCode: '([A-z]+)',?\)")
        .hasMatch(raw)) {
      match = RegExp(
              r"Locale.fromSubtags\(countryCode: '([A-z]+)', languageCode: '([A-z]+)', scriptCode: '([A-z]+)',?\)")
          .firstMatch(raw)!;
      return Language(
        countryCode: match.group(1)!,
        languageCode: match.group(2)!,
        scriptCode: match.group(3)!,
      );
    } else if (RegExp(
            r"Locale.fromSubtags\(countryCode: '([A-z]+)', scriptCode: '([A-z]+)', languageCode: '([A-z]+)',?\)")
        .hasMatch(raw)) {
      match = RegExp(
              r"Locale.fromSubtags\(countryCode: '([A-z]+)', scriptCode: '([A-z]+)', languageCode: '([A-z]+)',?\)")
          .firstMatch(raw)!;
      return Language(
        countryCode: match.group(1)!,
        scriptCode: match.group(2)!,
        languageCode: match.group(3)!,
      );
    } else if (RegExp(
            r"Locale.fromSubtags\(scriptCode: '([A-z]+)', languageCode: '([A-z]+)', countryCode: '([A-z]+)',?\)")
        .hasMatch(raw)) {
      match = RegExp(
              r"Locale.fromSubtags\(scriptCode: '([A-z]+)', languageCode: '([A-z]+)', countryCode: '([A-z]+)',?\)")
          .firstMatch(raw)!;
      return Language(
        scriptCode: match.group(1)!,
        languageCode: match.group(2)!,
        countryCode: match.group(3)!,
      );
    } else if (RegExp(
            r"Locale.fromSubtags\(scriptCode: '([A-z]+)', countryCode: '([A-z]+)', languageCode: '([A-z]+)',?\)")
        .hasMatch(raw)) {
      match = RegExp(
              r"Locale.fromSubtags\(scriptCode: '([A-z]+)', countryCode: '([A-z]+)', languageCode: '([A-z]+)',?\)")
          .firstMatch(raw)!;
      return Language(
        scriptCode: match.group(1)!,
        countryCode: match.group(2)!,
        languageCode: match.group(3)!,
      );
    }

    // TODO
    throw Error();
  }

  bool get hasScriptCode => scriptCode != null;

  bool get hasCountryCode => countryCode != null;

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
