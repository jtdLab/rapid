part of '../project.dart';

// TODO(jtdLab): find better name for NoneIosNativeDirectory.

/// {@template platform_native_directory}
/// Base class for:
///
///  * [IosNativeDirectory]
///
///  * [MacosNativeDirectory]
///
///  * [NoneIosNativeDirectory]
/// {@endtemplate}
sealed class PlatformNativeDirectory extends Directory {
  /// {@macro platform_native_directory}
  PlatformNativeDirectory({
    required this.projectName,
    required this.platform,
    required String path,
  }) : super(path);

  /// The name of the project this directory is part of.
  final String projectName;

  /// The platform.
  final NativePlatform platform;
}

/// {@template ios_native_directory}
/// Abstraction of a ios native directory of a Rapid project.
///
// TODO(jtdLab): more docs.
/// {@endtemplate}
class IosNativeDirectory extends PlatformNativeDirectory {
  /// {@macro ios_native_directory}
  IosNativeDirectory({
    required super.projectName,
    required super.path,
  }) : super(platform: NativePlatform.ios);

  /// Returns a [IosNativeDirectory] from given [projectName]
  /// and [platformRootPackagePath].
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

  /// The `Runner/Info.plist` file.
  PlistFile get infoFile => PlistFile(p.join(path, 'Runner', 'Info.plist'));

  /// Generate this directory on disk.
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

  /// Adds [language] to this directory.
  ///
  /// This updates the [infoFile].
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

  /// Removes [language] from this directory.
  ///
  /// This updates the [infoFile].
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

/// {@template macos_native_directory}
/// Abstraction of a macos native directory of a Rapid project.
///
// TODO(jtdLab): more docs.
/// {@endtemplate}
class MacosNativeDirectory extends PlatformNativeDirectory {
  /// {@macro macos_native_directory}
  MacosNativeDirectory({
    required super.projectName,
    required super.path,
  }) : super(platform: NativePlatform.macos);

  /// Returns a [MacosNativeDirectory] from given [projectName]
  /// and [platformRootPackagePath].
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

  /// Generate this directory on disk.
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

/// {@template none_ios_native_directory}
/// Abstraction of a none ios native directory of a Rapid project.
///
// TODO(jtdLab): more docs.
/// {@endtemplate}
class NoneIosNativeDirectory extends PlatformNativeDirectory {
  /// {@macro none_ios_native_directory}
  NoneIosNativeDirectory({
    required super.projectName,
    required super.platform,
    required super.path,
  });

  /// Returns a [NoneIosNativeDirectory] with [platform] from
  /// given [projectName] and [platformRootPackagePath].
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

  /// Generate this directory on disk.
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
