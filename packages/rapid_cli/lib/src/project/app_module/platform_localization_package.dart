part of '../project.dart';

/// {@template platform_localization_package}
/// Abstraction of a platform localization package of a Rapid project.
///
// TODO(jtdLab): more docs.
/// {@endtemplate}
class PlatformLocalizationPackage extends DartPackage {
  /// {@macro platform_localization_package}
  PlatformLocalizationPackage({
    required this.projectName,
    required this.platform,
    required String path,
    required this.languageArbFile,
    required this.languageLocalizationsFile,
  }) : super(path);

  /// Returns a [PlatformLocalizationPackage] with [platform] from
  /// given [projectName] and [projectPath].
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
    ArbFile languageArbFile({required Language language}) => ArbFile(
          p.join(
            path,
            'lib',
            'src',
            'arb',
            '${projectName.snakeCase}_${language.toStringWithSeperator()}.arb',
          ),
        );
    DartFile languageLocalizationsFile({required Language language}) =>
        DartFile(
          p.join(
            path,
            'lib',
            'src',
            '''${projectName.snakeCase}_localizations_${language.languageCode}.dart''',
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

  /// The name of the project this package is part of.
  final String projectName;

  /// The platform.
  final Platform platform;

  /// The language arb file builder.
  final ArbFile Function({required Language language}) languageArbFile;

  /// The language localizations file builder.
  final DartFile Function({required Language language})
      languageLocalizationsFile;

  /// The `lib/src/<project-name>_localizations.dart` file.
  DartFile get localizationsFile =>
      DartFile(p.join(path, 'lib', 'src', '${projectName}_localizations.dart'));

  /// The `l10n.yaml` file.
  YamlFile get l10nFile => YamlFile(p.join(path, 'l10n.yaml'));

  /// Generate this package on disk.
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

  /// Returns the supported language of this package.
  ///
  /// The language are read from the [localizationsFile].
  Set<Language> supportedLanguages() {
    return localizationsFile
        .readListVarOfClass(
          name: 'supportedLocales',
          parentClass: '${projectName.pascalCase}Localizations',
        )
        .map(Language.fromDartUiLocal)
        .toSet();
  }

  /// Returns the default language of this package.
  ///
  /// The default language is read from the [l10nFile].
  Language defaultLanguage() {
    final templateArbFile = l10nFile.read<String>('template-arb-file');

    return Language.fromUnicodeCLDRLocaleIdentifier(
      templateArbFile
          .substring(
            templateArbFile.indexOf('${projectName}_') +
                (projectName.length + 1),
          )
          .split('.')
          .first,
    );
  }

  /// Sets the default language of this package to [language].
  ///
  /// This updates the [l10nFile].
  void setDefaultLanguage(Language language) {
    final templateArbFile = l10nFile.read<String>('template-arb-file');
    final newTemplateArbFile = templateArbFile.replaceRange(
      templateArbFile.indexOf('${projectName}_') + (projectName.length + 1),
      templateArbFile.lastIndexOf('.arb'),
      language.toStringWithSeperator(),
    );
    l10nFile.set(['template-arb-file'], newTemplateArbFile);
  }

  /// Adds the [language] to this package.
  void addLanguage(Language language) {
    // TODO(jtdLab): impl cleaner
    final existingLanguages = supportedLanguages();

    if (!existingLanguages.contains(language)) {
      final languageArbFile = this.languageArbFile(language: language);
      languageArbFile.createSync(recursive: true);
      languageArbFile.writeAsStringSync(
        [
          '{',
          '  "@@locale": "${language.toStringWithSeperator()}"',
          '}',
        ].join('\n'),
      );
    }
  }

  /// Removes the [language] from this package.
  void removeLanguage(Language language) {
    // TODO(jtdLab): impl cleaner
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
