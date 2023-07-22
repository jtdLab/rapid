import 'package:rapid_cli/src/project/language.dart';
import 'package:test/test.dart';

void main() {
  group('Language', () {
    group('.fromString', () {
      test('should parse language code', () {
        final language = Language.fromString('en');
        expect(language.languageCode, 'en');
        expect(language.scriptCode, isNull);
        expect(language.countryCode, isNull);
      });

      test('should parse language code and script code', () {
        final language = Language.fromString('en_Latn');
        expect(language.languageCode, 'en');
        expect(language.scriptCode, 'Latn');
        expect(language.countryCode, isNull);
      });

      test('should parse language code and country code', () {
        final language = Language.fromString('en_US');
        expect(language.languageCode, 'en');
        expect(language.scriptCode, isNull);
        expect(language.countryCode, 'US');
      });

      test('should parse language code, script code, and country code', () {
        final language = Language.fromString('en_Latn_US');
        expect(language.languageCode, 'en');
        expect(language.scriptCode, 'Latn');
        expect(language.countryCode, 'US');
      });
    });

    group('hasScriptCode', () {
      test('should return true if script code exists', () {
        final language = Language(languageCode: 'en', scriptCode: 'Latn');
        expect(language.hasScriptCode, true);
      });

      test('should return false if script code is null', () {
        final language = Language(languageCode: 'en');
        expect(language.hasScriptCode, false);
      });
    });

    group('hasCountryCode', () {
      test('should return true if country code exists', () {
        final language = Language(languageCode: 'en', countryCode: 'US');
        expect(language.hasCountryCode, true);
      });

      test('should return false if country code is null', () {
        final language = Language(languageCode: 'en');
        expect(language.hasCountryCode, false);
      });
    });

    group('toStringWithSeperator', () {
      test('should return the string representation with default separator',
          () {
        final language =
            Language(languageCode: 'en', scriptCode: 'Latn', countryCode: 'US');
        expect(language.toStringWithSeperator(), 'en_Latn_US');
      });

      test('should return the string representation with custom separator', () {
        final language =
            Language(languageCode: 'en', scriptCode: 'Latn', countryCode: 'US');
        expect(language.toStringWithSeperator('-'), 'en-Latn-US');
      });
    });

    group('==', () {
      test('should return true for equal languages', () {
        final language1 =
            Language(languageCode: 'en', scriptCode: 'Latn', countryCode: 'US');
        final language2 =
            Language(languageCode: 'en', scriptCode: 'Latn', countryCode: 'US');
        expect(language1 == language2, true);
      });

      test('should return false for different language codes', () {
        final language1 =
            Language(languageCode: 'en', scriptCode: 'Latn', countryCode: 'US');
        final language2 =
            Language(languageCode: 'fr', scriptCode: 'Latn', countryCode: 'US');
        expect(language1 == language2, false);
      });

      test('should return false for different script codes', () {
        final language1 =
            Language(languageCode: 'en', scriptCode: 'Latn', countryCode: 'US');
        final language2 =
            Language(languageCode: 'en', scriptCode: 'Cyrl', countryCode: 'US');
        expect(language1 == language2, false);
      });

      test('should return false for different country codes', () {
        final language1 =
            Language(languageCode: 'en', scriptCode: 'Latn', countryCode: 'US');
        final language2 =
            Language(languageCode: 'en', scriptCode: 'Latn', countryCode: 'CA');
        expect(language1 == language2, false);
      });
    });

    group('hashCode', () {
      test('should return the same value for equal languages', () {
        final language1 =
            Language(languageCode: 'en', scriptCode: 'Latn', countryCode: 'US');
        final language2 =
            Language(languageCode: 'en', scriptCode: 'Latn', countryCode: 'US');
        expect(language1.hashCode, language2.hashCode);
      });

      test('should return different values for different languages', () {
        final language1 =
            Language(languageCode: 'en', scriptCode: 'Latn', countryCode: 'US');
        final language2 =
            Language(languageCode: 'fr', scriptCode: 'Latn', countryCode: 'US');
        expect(language1.hashCode, isNot(language2.hashCode));
      });
    });

    group('toString', () {
      test('should return the string representation', () {
        final language =
            Language(languageCode: 'en', scriptCode: 'Latn', countryCode: 'US');
        expect(language.toString(), 'en_Latn_US');
      });
    });

    group('compareTo', () {
      test('should compare languages based on language code', () {
        final language1 =
            Language(languageCode: 'en', scriptCode: 'Latn', countryCode: 'US');
        final language2 =
            Language(languageCode: 'fr', scriptCode: 'Latn', countryCode: 'US');
        expect(language1.compareTo(language2), isNegative);
        expect(language2.compareTo(language1), isPositive);
        expect(language1.compareTo(language1), isZero);
      });

      test('should compare languages based on script code if available', () {
        final language1 =
            Language(languageCode: 'en', scriptCode: 'Cyrl', countryCode: 'US');
        final language2 =
            Language(languageCode: 'en', scriptCode: 'Latn', countryCode: 'US');
        expect(language1.compareTo(language2), isNegative);
        expect(language2.compareTo(language1), isPositive);
        expect(language1.compareTo(language1), isZero);
      });

      test('should compare languages based on country code if available', () {
        final language1 =
            Language(languageCode: 'en', scriptCode: 'Latn', countryCode: 'CA');
        final language2 =
            Language(languageCode: 'en', scriptCode: 'Latn', countryCode: 'US');
        expect(language1.compareTo(language2), isNegative);
        expect(language2.compareTo(language1), isPositive);
        expect(language1.compareTo(language1), isZero);
      });
    });
  });
}
