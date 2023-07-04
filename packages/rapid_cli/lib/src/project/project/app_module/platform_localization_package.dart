part of '../../project.dart';

class PlatformLocalizationPackage extends DartPackage {
  PlatformLocalizationPackage({
    required this.projectName,
    required this.platform,
    required String path,
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

    return PlatformLocalizationPackage(
      projectName: projectName,
      path: path,
      platform: platform,
    );
  }

  final String projectName;

  final Platform platform;

  DartFile get localizationsFile =>
      DartFile(p.join(path, 'lib', 'src', '${projectName}_localizations.dart'));

  YamlFile get l10nFile => YamlFile(p.join(path, 'l10n.yaml'));

  Future<void> generate({required Language language}) async {
    await mason.generate(
      bundle: platformLocalizationPackageBundle,
      target: this,
      vars: <String, dynamic>{
        'project_name': projectName,
        'platform': platform.name,
        // TODO multiple languages can be needed? when a script or country code are specified
        'language_code': language.languageCode,
        'has_script_code': language.hasScriptCode,
        'script_code': language.scriptCode,
        'has_country_code': language.hasCountryCode,
        'country_code': language.countryCode,
      },
    );
  }
}
