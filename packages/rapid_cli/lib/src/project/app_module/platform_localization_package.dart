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
            '${projectName.snakeCase}_localizations_${language.toStringWithSeperator()}.dart',
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
    await mason.generate(
      bundle: platformLocalizationPackageBundle,
      target: this,
      vars: <String, dynamic>{
        'project_name': projectName,
        'platform': platform.name,
        'default_language_code': defaultLanguage.languageCode,
        'default_has_script_code':
            defaultLanguage.hasScriptCode, // TODO inside hook ?
        'default_script_code': defaultLanguage.scriptCode,
        'default_has_country_code':
            defaultLanguage.hasCountryCode, // TODO inside hook ?
        'default_country_code': defaultLanguage.countryCode,
        if (defaultLanguage.needsFallback)
          'fallback_language_code': defaultLanguage.languageCode,
      },
    );
  }
}
