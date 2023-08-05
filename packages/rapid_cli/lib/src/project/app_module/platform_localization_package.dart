part of '../project.dart';

class PlatformLocalizationPackage extends DartPackage {
  PlatformLocalizationPackage({
    required this.projectName,
    required this.platform,
    required String path,
    required this.languageArbFile,
    required this.languageLocalizationsFile,
  }) : super(path);

  factory PlatformLocalizationPackage.resolve({
    required String projectName,
    required String projectPath,
    required Platform platform,
  }) {
    final path = p.join(
      projectPath,
      'packages',
      projectName,
      '${projectName}_${platform.name}',
      '${projectName}_${platform.name}_localization',
    );
    languageArbFile({required Language language}) => ArbFile(
          p.join(
            path,
            'lib',
            'src',
            'arb',
            '${projectName.snakeCase}_${language.toStringWithSeperator()}.arb',
          ),
        );
    languageLocalizationsFile({required Language language}) => DartFile(
          p.join(
            path,
            'lib',
            'src',
            '${projectName.snakeCase}_localizations_${language.languageCode}.dart',
          ),
        );

    return PlatformLocalizationPackage(
      projectName: projectName,
      path: path,
      platform: platform,
      languageArbFile: languageArbFile,
      languageLocalizationsFile: languageLocalizationsFile,
    );
  }

  final String projectName;

  final Platform platform;

  final ArbFile Function({required Language language}) languageArbFile;

  final DartFile Function({required Language language})
      languageLocalizationsFile;

  DartFile get localizationsFile =>
      DartFile(p.join(path, 'lib', 'src', '${projectName}_localizations.dart'));

  YamlFile get l10nFile => YamlFile(p.join(path, 'l10n.yaml'));

  Future<void> generate({required Language defaultLanguage}) async {
    final fallbackLanguage =
        defaultLanguage.needsFallback ? defaultLanguage.fallback() : null;
    await mason.generate(
      bundle: platformLocalizationPackageBundle,
      target: this,
      vars: <String, dynamic>{
        'project_name': projectName,
        ...platformVars(platform),
        'default_language_code': defaultLanguage.languageCode,
        'default_script_code': defaultLanguage.scriptCode,
        'default_has_script_code': defaultLanguage.hasScriptCode,
        'default_country_code': defaultLanguage.countryCode,
        'default_has_country_code': defaultLanguage.hasCountryCode,
        if (fallbackLanguage != null)
          'fallback_language_code': fallbackLanguage.languageCode,
      },
    );

    languageArbFile(language: defaultLanguage)
      ..createSync(recursive: true)
      ..writeAsStringSync(
        multiLine([
          '{',
          '  "@@locale": "${defaultLanguage.toStringWithSeperator()}"',
          '}',
        ]),
      );

    if (fallbackLanguage != null) {
      languageArbFile(language: fallbackLanguage)
        ..createSync(recursive: true)
        ..writeAsStringSync(
          multiLine([
            '{',
            '  "@@locale": "${fallbackLanguage.toStringWithSeperator()}"',
            '}',
          ]),
        );
    }
  }

  Set<Language> supportedLanguages() {
    return localizationsFile
        .readListVarOfClass(
          name: 'supportedLocales',
          parentClass: '${projectName.pascalCase}Localizations',
        )
        .map((e) => Language.fromDartUiLocal(e))
        .toSet();
  }

  Language defaultLanguage() {
    final templateArbFile = l10nFile.read<String>('template-arb-file');

    return Language.fromString(
      templateArbFile
          .substring(templateArbFile.indexOf('${projectName}_') +
              (projectName.length + 1))
          .split('.')
          .first,
    );
  }

  void setDefaultLanguage(Language language) {
    final templateArbFile = l10nFile.read<String>('template-arb-file');
    final newTemplateArbFile = templateArbFile.replaceRange(
      templateArbFile.indexOf('${projectName}_') + (projectName.length + 1),
      templateArbFile.lastIndexOf('.arb'),
      language.toStringWithSeperator(),
    );
    l10nFile.set(['template-arb-file'], newTemplateArbFile);
  }

  void addLanguage(Language language) {
    // TODO
    final existingLanguages = supportedLanguages();

    if (!existingLanguages.contains(language)) {
      final languageArbFile = this.languageArbFile(language: language);
      languageArbFile.createSync(recursive: true);
      languageArbFile.writeAsStringSync([
        '{',
        '  "@@locale": "${language.toStringWithSeperator()}"',
        '}',
      ].join('\n'));
    }
  }

  void removeLanguage(Language language) {
    // TODO
    final existingLanguages = supportedLanguages();

    if (existingLanguages.contains(language)) {
      languageArbFile(language: language).deleteSync(recursive: true);
      if (!language.hasScriptCode && !language.hasCountryCode) {
        languageLocalizationsFile(language: language)
            .deleteSync(recursive: true);
      }
    }
  }
}
