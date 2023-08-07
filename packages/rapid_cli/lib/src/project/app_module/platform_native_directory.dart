part of '../project.dart';

sealed class PlatformNativeDirectory extends Directory {
  PlatformNativeDirectory({
    required this.projectName,
    required this.platform,
    required String path,
  }) : super(path);

  final String projectName;

  final NativePlatform platform;
}

class IosNativeDirectory extends PlatformNativeDirectory {
  IosNativeDirectory({
    required super.projectName,
    required super.path,
  }) : super(platform: NativePlatform.ios);

  factory IosNativeDirectory.resolve({
    required String projectName,
    required String platformRootPackagePath,
  }) {
    final path = p.join(platformRootPackagePath, 'ios');

    return IosNativeDirectory(
      projectName: projectName,
      path: path,
    );
  }

  PlistFile get infoFile => PlistFile(p.join(path, 'Runner', 'Info.plist'));

  Future<void> generate({
    required String orgName,
    required Language language,
  }) async {
    await mason.generate(
      bundle: iosNativeDirectoryBundle,
      target: this,
      vars: <String, dynamic>{
        'project_name': projectName,
        'org_name': orgName,
        'language_code': language.languageCode,
        'script_code': language.scriptCode,
        'has_script_code': language.hasScriptCode,
        'country_code': language.countryCode,
        'has_country_code': language.hasCountryCode,
      },
    );
  }

  void addLanguage(Language language) {
    final dict = infoFile.readDict();

    final localizations =
        (dict['CFBundleLocalizations'] as List<dynamic>?)?.cast<String>();

    dict['CFBundleLocalizations'] = [
      ...?localizations,
      language.toStringWithSeperator('-'),
    ]..sort();

    infoFile.setDict(dict);
  }

  void removeLanguage(Language language) {
    final dict = infoFile.readDict();
    final localizations =
        (dict['CFBundleLocalizations'] as List<dynamic>?)?.cast<String>();

    dict['CFBundleLocalizations'] = [
      ...?localizations?..remove(language.toStringWithSeperator('-')),
    ]..sort();

    infoFile.setDict(dict);
  }
}

class MacosNativeDirectory extends PlatformNativeDirectory {
  MacosNativeDirectory({
    required super.projectName,
    required super.path,
  }) : super(platform: NativePlatform.macos);

  factory MacosNativeDirectory.resolve({
    required String projectName,
    required String platformRootPackagePath,
  }) {
    final path = p.join(platformRootPackagePath, 'macos');

    return MacosNativeDirectory(
      projectName: projectName,
      path: path,
    );
  }

  Future<void> generate({required String orgName}) async {
    await mason.generate(
      bundle: macosNativeDirectoryBundle,
      target: this,
      vars: <String, dynamic>{
        'project_name': projectName,
        'org_name': orgName,
      },
    );
  }
}

// TODO(jtdLab): better names
class NoneIosNativeDirectory extends PlatformNativeDirectory {
  NoneIosNativeDirectory({
    required super.projectName,
    required super.platform,
    required super.path,
  });

  factory NoneIosNativeDirectory.resolve({
    required String projectName,
    required String platformRootPackagePath,
    required NativePlatform platform,
  }) {
    final path = p.join(platformRootPackagePath, platform.name);

    return NoneIosNativeDirectory(
      projectName: projectName,
      platform: platform,
      path: path,
    );
  }

  Future<void> generate({
    String? orgName,
    String? description,
  }) async {
    final bundle = switch (platform) {
      NativePlatform.android => androidNativeDirectoryBundle,
      NativePlatform.linux => linuxNativeDirectoryBundle,
      NativePlatform.web => webNativeDirectoryBundle,
      _ => windowsNativeDirectoryBundle,
    };

    await mason.generate(
      bundle: bundle,
      target: this,
      vars: <String, dynamic>{
        'project_name': projectName,
        'description': description,
        'org_name': orgName,
      },
    );
  }
}
