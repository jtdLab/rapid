import 'package:mocktail/mocktail.dart';
import 'package:rapid_cli/src/io.dart';
import 'package:rapid_cli/src/mason.dart';
import 'package:rapid_cli/src/project/bundles/bundles.dart';
import 'package:rapid_cli/src/project/language.dart';
import 'package:rapid_cli/src/project/platform.dart';
import 'package:rapid_cli/src/project/project.dart';
import 'package:rapid_cli/src/utils.dart';
import 'package:test/test.dart';
import 'package:path/path.dart' as p;

import '../../mock_fs.dart';
import '../../mocks.dart';

PlatformLocalizationPackage _getPlatformLocalizationPackage({
  String? projectName,
  String? path,
  Platform? platform,
  ArbFile Function({required Language language})? languageArbFile,
  DartFile Function({required Language language})? languageLocalizationsFile,
}) {
  return PlatformLocalizationPackage(
    projectName: projectName ?? 'projectName',
    path: path ?? 'path',
    platform: platform ?? Platform.android,
    languageArbFile:
        languageArbFile ?? ({required Language language}) => MockArbFile(),
    languageLocalizationsFile: languageLocalizationsFile ??
        ({required Language language}) => MockDartFile(),
  );
}

void main() {
  setUpAll(() {
    registerFallbackValues();
  });

  group('PlatformLocalizationPackage', () {
    test('.resolve', () {
      final platformLocalizationPackage = PlatformLocalizationPackage.resolve(
        projectName: 'test_project',
        projectPath: '/path/to/project',
        platform: Platform.windows,
      );

      expect(platformLocalizationPackage.projectName, 'test_project');
      expect(
        platformLocalizationPackage.path,
        '/path/to/project/packages/test_project/test_project_windows/test_project_windows_localization',
      );
      final languageArbFile = platformLocalizationPackage.languageArbFile(
        language: Language(languageCode: 'en', countryCode: 'US'),
      );
      expect(
        languageArbFile.path,
        '/path/to/project/packages/test_project/test_project_windows/test_project_windows_localization/lib/src/arb/test_project_en_US.arb',
      );
      final languageLocalizationsFile =
          platformLocalizationPackage.languageLocalizationsFile(
        language: Language(
          languageCode: 'en',
          countryCode: 'US',
        ),
      );
      expect(
        languageLocalizationsFile.path,
        '/path/to/project/packages/test_project/test_project_windows/test_project_windows_localization/lib/src/test_project_localizations_en.dart',
      );
    });

    test('localizationsFile', () {
      final platformLocalizationPackage = _getPlatformLocalizationPackage(
        projectName: 'test_project',
        path: '/path/to/localization_package',
      );

      expect(
        platformLocalizationPackage.localizationsFile.path,
        '/path/to/localization_package/lib/src/test_project_localizations.dart',
      );
    });

    test('l10nFile', () {
      final platformLocalizationPackage = _getPlatformLocalizationPackage(
        path: '/path/to/localization_package',
      );

      expect(
        platformLocalizationPackage.l10nFile.path,
        '/path/to/localization_package/l10n.yaml',
      );
    });

    test(
      'generate',
      withMockFs(
        () async {
          final generator = MockMasonGenerator();
          final generatorBuilder = MockMasonGeneratorBuilder(
            generator: generator,
          );
          generatorOverrides = generatorBuilder;
          final platformLocalizationPackage = _getPlatformLocalizationPackage(
            projectName: 'test_project',
            path: '/path/to/localization_package',
            platform: Platform.linux,
            languageArbFile: ({required language}) {
              if (language == Language(languageCode: 'en')) {
                return ArbFile(
                  p.join(
                    '/path/to/localization_package',
                    'lib',
                    'src',
                    'arb',
                    'test_project_en.arb',
                  ),
                );
              } else {
                return ArbFile(
                  p.join(
                    '/path/to/localization_package',
                    'lib',
                    'src',
                    'arb',
                    'test_project_en_US.arb',
                  ),
                );
              }
            },
          );

          await platformLocalizationPackage.generate(
            defaultLanguage: Language(languageCode: 'en', countryCode: 'US'),
          );

          verifyInOrder([
            () => generatorBuilder(platformLocalizationPackageBundle),
            () => generator.generate(
                  any(
                    that: isA<DirectoryGeneratorTarget>().having(
                      (e) => e.dir.path,
                      'path',
                      '/path/to/localization_package',
                    ),
                  ),
                  vars: <String, dynamic>{
                    'project_name': 'test_project',
                    'platform': 'linux',
                    'android': false,
                    'ios': false,
                    'linux': true,
                    'macos': false,
                    'web': false,
                    'windows': false,
                    'mobile': false,
                    'default_language_code': 'en',
                    'default_script_code': null,
                    'default_has_script_code': false,
                    'default_country_code': 'US',
                    'default_has_country_code': true,
                    'fallback_language_code': 'en',
                  },
                ),
          ]);
          expect(
            File(
              p.join(
                '/path/to/localization_package',
                'lib',
                'src',
                'arb',
                'test_project_en_US.arb',
              ),
            ).readAsStringSync(),
            multiLine([
              '{',
              '  "@@locale": "en_US"',
              '}',
            ]),
          );
          expect(
            File(
              p.join(
                '/path/to/localization_package',
                'lib',
                'src',
                'arb',
                'test_project_en.arb',
              ),
            ).readAsStringSync(),
            multiLine([
              '{',
              '  "@@locale": "en"',
              '}',
            ]),
          );
        },
      ),
    );

    test(
      'supportedLanguages',
      withMockFs(() {
        File(
            '/path/to/localization_package/lib/src/test_project_localizations.dart')
          ..createSync(recursive: true)
          ..writeAsStringSync(
            multiLine([
              'class TestProjectLocalizations {',
              '  final supportedLocales = [',
              '    Locale(\'en\', \'US\'),',
              '    Locale(\'es\', \'ES\'),',
              '  ];',
              '}'
            ]),
          );
        final platformLocalizationPackage = _getPlatformLocalizationPackage(
          projectName: 'test_project',
          path: '/path/to/localization_package',
        );

        final supportedLanguages =
            platformLocalizationPackage.supportedLanguages();

        expect(supportedLanguages, hasLength(2));
        expect(
          supportedLanguages,
          containsAll([
            Language(languageCode: 'en', countryCode: 'US'),
            Language(languageCode: 'es', countryCode: 'ES'),
          ]),
        );
      }),
    );

    test(
      'defaultLanguage',
      withMockFs(() {
        File('/path/to/localization_package/l10n.yaml')
          ..createSync(recursive: true)
          ..writeAsStringSync('template-arb-file: test_project_en_US');
        final platformLocalizationPackage = _getPlatformLocalizationPackage(
          projectName: 'test_project',
          path: '/path/to/localization_package',
        );

        final defaultLanguage = platformLocalizationPackage.defaultLanguage();

        expect(
          defaultLanguage,
          Language(languageCode: 'en', countryCode: 'US'),
        );
      }),
    );

    test(
      'setDefaultLanguage',
      withMockFs(() {
        final file = File('/path/to/localization_package/l10n.yaml')
          ..createSync(recursive: true)
          ..writeAsStringSync('template-arb-file: test_project_en_US.arb');
        final platformLocalizationPackage = _getPlatformLocalizationPackage(
          projectName: 'test_project',
          path: '/path/to/localization_package',
        );

        platformLocalizationPackage.setDefaultLanguage(
          Language(languageCode: 'es', countryCode: 'ES'),
        );

        expect(
          file.readAsStringSync(),
          'template-arb-file: test_project_es_ES.arb',
        );
      }),
    );

    test(
      'addLanguage',
      withMockFs(() {
        File(
            '/path/to/localization_package/lib/src/test_project_localizations.dart')
          ..createSync(recursive: true)
          ..writeAsStringSync(
            multiLine([
              'class TestProjectLocalizations {',
              '  final supportedLocales = [',
              '    Locale(\'en\', \'US\'),',
              '  ];',
              '}'
            ]),
          );
        final arbFile = ArbFile(
          '/path/to/localization_package/lib/src/arb/test_project_localizations_fr-FR.arb',
        );
        final platformLocalizationPackage = _getPlatformLocalizationPackage(
          projectName: 'test_project',
          path: '/path/to/localization_package',
          languageArbFile: ({required language}) => arbFile,
        );

        platformLocalizationPackage.addLanguage(
          Language(languageCode: 'fr', countryCode: 'FR'),
        );

        expect(arbFile.existsSync(), true);
        expect(
          arbFile.readAsStringSync(),
          multiLine([
            '{',
            '  "@@locale": "fr_FR"',
            '}',
          ]),
        );
      }),
    );

    group('removeLanguage', () {
      test(
        'removes arb file',
        withMockFs(() {
          File(
              '/path/to/localization_package/lib/src/test_project_localizations.dart')
            ..createSync(recursive: true)
            ..writeAsStringSync(
              multiLine([
                'class TestProjectLocalizations {',
                '  final supportedLocales = [',
                '    Locale(\'en\', \'US\'),',
                '  ];',
                '}'
              ]),
            );
          final arbFile = ArbFile(
            '/path/to/localization_package/lib/src/arb/test_project_localizations_fr-FR.arb',
          )..createSync(recursive: true);
          final platformLocalizationPackage = _getPlatformLocalizationPackage(
            projectName: 'test_project',
            path: '/path/to/localization_package',
            languageArbFile: ({required language}) => arbFile,
          );

          platformLocalizationPackage.removeLanguage(
            Language(languageCode: 'en', countryCode: 'US'),
          );

          expect(arbFile.existsSync(), false);
        }),
      );

      test(
        'removes language localizations file when language has only language code',
        withMockFs(() {
          File(
              '/path/to/localization_package/lib/src/test_project_localizations.dart')
            ..createSync(recursive: true)
            ..writeAsStringSync(
              multiLine([
                'class TestProjectLocalizations {',
                '  final supportedLocales = [',
                '    Locale(\'en\'),',
                '    Locale(\'fr\'),',
                '  ];',
                '}'
              ]),
            );
          final arbFile = ArbFile(
            '/path/to/localization_package/lib/src/arb/test_project_localizations_fr.arb',
          )..createSync(recursive: true);
          final languageLocalizationsFile = DartFile(
            '/path/to/localization_package/lib/src/test_project_localizations_fr.dart',
          )..createSync(recursive: true);
          final platformLocalizationPackage = _getPlatformLocalizationPackage(
            projectName: 'test_project',
            path: '/path/to/localization_package',
            languageArbFile: ({required language}) => arbFile,
            languageLocalizationsFile: ({required language}) =>
                languageLocalizationsFile,
          );

          platformLocalizationPackage
              .removeLanguage(Language(languageCode: 'fr'));

          expect(arbFile.existsSync(), false);
          expect(languageLocalizationsFile.existsSync(), false);
        }),
      );
    });
  });
}
