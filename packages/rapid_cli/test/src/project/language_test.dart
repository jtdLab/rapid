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

    group('.fromDartUiLocal', () {
      test("Locale('zh')", () {
        void test(String raw) {
          expect(
            Language.fromDartUiLocal(raw),
            const Language(languageCode: 'zh'),
          );
        }

        test("Locale('zh')");
        test("Locale('zh',)");
        test("Locale( 'zh' , ) ");
        test('Locale("zh")');
        test('Locale("zh",)');
        test('Locale( "zh" , ) ');
      });

      test("Locale('zh', 'CN')", () {
        void test(String raw) {
          expect(
            Language.fromDartUiLocal(raw),
            const Language(languageCode: 'zh', countryCode: 'CN'),
          );
        }

        test("Locale('zh', 'CN')");
        test("Locale('zh', 'CN',)");
        test(" Locale( 'zh' ,  'CN' , ) ");
        test('Locale("zh", "CN")');
        test('Locale("zh", "CN",)');
        test(' Locale( "zh" ,  "CN" , ) ');
      });

      test('Locale.fromSubtags()', () {
        expect(
          Language.fromDartUiLocal('Locale.fromSubtags()'),
          const Language(languageCode: 'und'),
        );
      });

      test("Locale.fromSubtags(languageCode: 'zh')", () {
        void test(String raw) {
          expect(
            Language.fromDartUiLocal(raw),
            const Language(languageCode: 'zh'),
          );
        }

        test("Locale.fromSubtags(languageCode: 'zh')");
        test("Locale.fromSubtags(languageCode: 'zh',)");
        test("Locale.fromSubtags( languageCode: 'zh' , ) ");
        test('Locale.fromSubtags(languageCode: "zh")');
        test('Locale.fromSubtags(languageCode: "zh",)');
        test('Locale.fromSubtags( languageCode: "zh" , ) ');
      });

      test("Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hans')", () {
        void test(String raw) {
          expect(
            Language.fromDartUiLocal(raw),
            const Language(languageCode: 'zh', scriptCode: 'Hans'),
          );
        }

        test("Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hans')");
        test("Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hans',)");
        test(
          "Locale.fromSubtags( languageCode: 'zh' , scriptCode: 'Hans' , ) ",
        );
        test('Locale.fromSubtags(languageCode: "zh", scriptCode: "Hans")');
        test('Locale.fromSubtags(languageCode: "zh", scriptCode: "Hans",)');
        test(
          'Locale.fromSubtags( languageCode: "zh" , scriptCode: "Hans" , ) ',
        );
      });

      test("Locale.fromSubtags(languageCode: 'zh', countryCode: 'CN')", () {
        void test(String raw) {
          expect(
            Language.fromDartUiLocal(raw),
            const Language(languageCode: 'zh', countryCode: 'CN'),
          );
        }

        test("Locale.fromSubtags(languageCode: 'zh', countryCode: 'CN')");
        test("Locale.fromSubtags(languageCode: 'zh', countryCode: 'CN',)");
        test(
          "Locale.fromSubtags( languageCode: 'zh' , countryCode: 'CN' , ) ",
        );
        test('Locale.fromSubtags(languageCode: "zh", countryCode: "CN")');
        test('Locale.fromSubtags(languageCode: "zh", countryCode: "CN",)');
        test('Locale.fromSubtags( languageCode: "zh" , countryCode: "CN" , ) ');
      });

      test(
          "Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hans', countryCode: 'CN')",
          () {
        void test(String raw) {
          expect(
            Language.fromDartUiLocal(raw),
            const Language(
              languageCode: 'zh',
              scriptCode: 'Hans',
              countryCode: 'CN',
            ),
          );
        }

        test(
          "Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hans', countryCode: 'CN')",
        );
        test(
          "Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hans', countryCode: 'CN',)",
        );
        test(
          "Locale.fromSubtags( languageCode: 'zh' , scriptCode: 'Hans' , countryCode: 'CN', ) ",
        );
        test(
          'Locale.fromSubtags(languageCode: "zh", scriptCode: "Hans", countryCode: "CN")',
        );
        test(
          'Locale.fromSubtags(languageCode: "zh", scriptCode: "Hans", countryCode: "CN",)',
        );
        test(
          'Locale.fromSubtags( languageCode: "zh" , scriptCode: "Hans" , countryCode: "CN", ) ',
        );
      });

      // TODO(jtdLab): maybe add more tests for param permuations of .subTags

      test('throws ArgumentError', () {
        expect(() => Language.fromDartUiLocal('foo'), throwsArgumentError);
      });
    });

    group('hasScriptCode', () {
      test('should return true if script code exists', () {
        const language = Language(languageCode: 'en', scriptCode: 'Latn');
        expect(language.hasScriptCode, true);
      });

      test('should return false if script code is null', () {
        const language = Language(languageCode: 'en');
        expect(language.hasScriptCode, false);
      });
    });

    group('hasCountryCode', () {
      test('should return true if country code exists', () {
        const language = Language(languageCode: 'en', countryCode: 'US');
        expect(language.hasCountryCode, true);
      });

      test('should return false if country code is null', () {
        const language = Language(languageCode: 'en');
        expect(language.hasCountryCode, false);
      });
    });

    group('toStringWithSeperator', () {
      test('should return the string representation with default separator',
          () {
        const language =
            Language(languageCode: 'en', scriptCode: 'Latn', countryCode: 'US');
        expect(language.toStringWithSeperator(), 'en_Latn_US');
      });

      test('should return the string representation with custom separator', () {
        const language =
            Language(languageCode: 'en', scriptCode: 'Latn', countryCode: 'US');
        expect(language.toStringWithSeperator('-'), 'en-Latn-US');
      });
    });

    group('==', () {
      test('should return true for equal languages', () {
        const language1 =
            Language(languageCode: 'en', scriptCode: 'Latn', countryCode: 'US');
        const language2 =
            Language(languageCode: 'en', scriptCode: 'Latn', countryCode: 'US');
        expect(language1 == language2, true);
      });

      test('should return false for different language codes', () {
        const language1 =
            Language(languageCode: 'en', scriptCode: 'Latn', countryCode: 'US');
        const language2 =
            Language(languageCode: 'fr', scriptCode: 'Latn', countryCode: 'US');
        expect(language1 == language2, false);
      });

      test('should return false for different script codes', () {
        const language1 =
            Language(languageCode: 'en', scriptCode: 'Latn', countryCode: 'US');
        const language2 =
            Language(languageCode: 'en', scriptCode: 'Cyrl', countryCode: 'US');
        expect(language1 == language2, false);
      });

      test('should return false for different country codes', () {
        const language1 =
            Language(languageCode: 'en', scriptCode: 'Latn', countryCode: 'US');
        const language2 =
            Language(languageCode: 'en', scriptCode: 'Latn', countryCode: 'CA');
        expect(language1 == language2, false);
      });
    });

    group('hashCode', () {
      test('should return the same value for equal languages', () {
        const language1 =
            Language(languageCode: 'en', scriptCode: 'Latn', countryCode: 'US');
        const language2 =
            Language(languageCode: 'en', scriptCode: 'Latn', countryCode: 'US');
        expect(language1.hashCode, language2.hashCode);
      });

      test('should return different values for different languages', () {
        const language1 =
            Language(languageCode: 'en', scriptCode: 'Latn', countryCode: 'US');
        const language2 =
            Language(languageCode: 'fr', scriptCode: 'Latn', countryCode: 'US');
        expect(language1.hashCode, isNot(language2.hashCode));
      });
    });

    group('toString', () {
      test('should return the string representation', () {
        const language =
            Language(languageCode: 'en', scriptCode: 'Latn', countryCode: 'US');
        expect(language.toString(), 'en_Latn_US');
      });
    });

    group('compareTo', () {
      test('should compare languages based on language code', () {
        const language1 =
            Language(languageCode: 'en', scriptCode: 'Latn', countryCode: 'US');
        const language2 =
            Language(languageCode: 'fr', scriptCode: 'Latn', countryCode: 'US');
        expect(language1.compareTo(language2), isNegative);
        expect(language2.compareTo(language1), isPositive);
        expect(language1.compareTo(language1), isZero);
      });

      test('should compare languages based on script code if available', () {
        const language1 =
            Language(languageCode: 'en', scriptCode: 'Cyrl', countryCode: 'US');
        const language2 =
            Language(languageCode: 'en', scriptCode: 'Latn', countryCode: 'US');
        expect(language1.compareTo(language2), isNegative);
        expect(language2.compareTo(language1), isPositive);
        expect(language1.compareTo(language1), isZero);
      });

      test('should compare languages based on country code if available', () {
        const language1 =
            Language(languageCode: 'en', scriptCode: 'Latn', countryCode: 'CA');
        const language2 =
            Language(languageCode: 'en', scriptCode: 'Latn', countryCode: 'US');
        expect(language1.compareTo(language2), isNegative);
        expect(language2.compareTo(language1), isPositive);
        expect(language1.compareTo(language1), isZero);
      });
    });
  });
}
