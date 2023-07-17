import 'package:mocktail/mocktail.dart';
import 'package:rapid_cli/src/mason.dart';
import 'package:rapid_cli/src/project/bundles/bundles.dart';
import 'package:rapid_cli/src/project/language.dart';
import 'package:rapid_cli/src/project/platform.dart';
import 'package:rapid_cli/src/project/project.dart';
import 'package:test/test.dart';

import '../../mock_fs.dart';
import '../../mocks.dart';

PlatformLocalizationPackage _getPlatformLocalizationPackage({
  String? projectName,
  String? path,
  Platform? platform,
}) {
  return PlatformLocalizationPackage(
    projectName: projectName ?? 'projectName',
    path: path ?? 'path',
    platform: platform ?? Platform.android,
    languageArbFile: ({required Language language}) => MockArbFile(),
    languageLocalizationsFile: ({required Language language}) => MockDartFile(),
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
        '/path/to/project/packages/test_project/test_project_windows/test_project_windows_localization/lib/src/test_project_localizations_en_US.dart',
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
                    'default_language_code': 'en',
                    'default_has_script_code': false,
                    'default_script_code': null,
                    'default_has_country_code': true,
                    'default_country_code': 'US',
                    'fallback_language_code': 'en',
                  },
                ),
          ]);
        },
      ),
    );

// TODO
/*
    test('supportedLanguages', () {
      final platformLocalizationPackage = _getPlatformLocalizationPackage(
        path: '/path/to/localization_package',
      );

      final mockLocalizationsFile = MockDartFile();
      when(
        () => mockLocalizationsFile.readListVarOfClass(
          name: any(named: 'name'),
          parentClass: any(named: 'parentClass'),
        ),
      ).thenReturn([
        'Locale(\'en\', \'US\')',
        'Locale(\'es\', \'ES\')',
      ]);

      platformLocalizationPackage.localizationsFile = mockLocalizationsFile;

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
    });

    test('defaultLanguage', () {
      final platformLocalizationPackage = _getPlatformLocalizationPackage(
        path: '/path/to/localization_package',
      );

      final mockL10nFile = MockYamlFile();
      when(() => mockL10nFile.read<String>(any())).thenReturn(
        'template-arb-file: lib/src/arbs/test_project_en-US.arb',
      );

      platformLocalizationPackage.l10nFile = mockL10nFile;

      final defaultLanguage = platformLocalizationPackage.defaultLanguage();

      expect(defaultLanguage, Language(languageCode: 'en', countryCode: 'US'));
    });

    test('setDefaultLanguage', () {
      final platformLocalizationPackage = _getPlatformLocalizationPackage(
        path: '/path/to/localization_package',
      );

      final mockL10nFile = MockYamlFile();
      when(() => mockL10nFile.read<String>('template-arb-file'))
          .thenReturn('lib/src/arbs/test_project_en-US.arb');

      platformLocalizationPackage.l10nFile = mockL10nFile;

      platformLocalizationPackage.setDefaultLanguage(
        Language(languageCode: 'es', countryCode: 'ES'),
      );

      verify(
        () => mockL10nFile.set(
          ['template-arb-file'],
          'lib/src/arbs/test_project_es-ES.arb',
        ),
      );
    });

    test('addLanguage', () {
      final platformLocalizationPackage = _getPlatformLocalizationPackage(
        path: '/path/to/localization_package',
      );

      final mockLanguageArbFile = MockArbFile();
      final mockLanguageArbFileBuilder = MockArbFileBuilder(
        arbFile: mockLanguageArbFile,
      );
      arbFileOverrides = mockLanguageArbFileBuilder;

      final language = Language(languageCode: 'fr', countryCode: 'FR');
      final expectedArbFilePath =
          '/path/to/localization_package/lib/src/arb/test_project_localizations_fr-FR.arb';

      platformLocalizationPackage.addLanguage(language);

      verifyInOrder([
        () => mockLanguageArbFileBuilder(expectedArbFilePath),
        () => mockLanguageArbFile.createSync(recursive: true),
        () => mockLanguageArbFile.writeAsStringSync(
              '{\n'
              '  "@@locale": "fr_FR"\n'
              '}',
            ),
      ]);
    });

    test('removeLanguage', () {
      final platformLocalizationPackage = _getPlatformLocalizationPackage(
        path: '/path/to/localization_package',
      );

      final mockSupportedLanguages = MockSet<Language>();
      when(() => mockSupportedLanguages.contains(any())).thenReturn(true);

      final mockLanguageArbFile = MockArbFile();
      final mockLanguageLocalizationsFile = MockDartFile();
      when(() => mockLanguageArbFile.deleteSync(
          recursive: any(named: 'recursive'))).thenReturn(true);
      when(() => mockLanguageLocalizationsFile.deleteSync(
            recursive: any(named: 'recursive'),
          )).thenReturn(true);

      platformLocalizationPackage.languageArbFile =
          ({required Language language}) => mockLanguageArbFile;
      platformLocalizationPackage.languageLocalizationsFile =
          ({required Language language}) => mockLanguageLocalizationsFile;
      platformLocalizationPackage.supportedLanguages = mockSupportedLanguages;

      final language = Language(languageCode: 'fr', countryCode: 'FR');

      platformLocalizationPackage.removeLanguage(language);

      verifyInOrder([
        () => mockSupportedLanguages.contains(language),
        () => mockLanguageArbFile.deleteSync(recursive: true),
        () => mockLanguageLocalizationsFile.deleteSync(recursive: true),
      ]);
    });
*/
  });
}
