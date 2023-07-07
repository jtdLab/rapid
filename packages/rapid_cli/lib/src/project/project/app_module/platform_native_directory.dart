part of '../../project.dart';

sealed class PlatformNativeDirectory extends Directory {
  PlatformNativeDirectory({
    required this.projectName,
    required this.platform,
    required String path,
  }) : super(path);

  final String projectName;

  final Platform platform;
}

final class IosNativeDirectory extends PlatformNativeDirectory {
  IosNativeDirectory({
    required super.projectName,
    required super.path,
  }) : super(platform: Platform.ios);

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
        'has_script_code': language.hasScriptCode,
        'script_code': language.scriptCode,
        'has_country_code': language.hasCountryCode,
        'country_code': language.countryCode,
      },
    );
  }
}

final class MacosNativeDirectory extends PlatformNativeDirectory {
  MacosNativeDirectory({
    required super.projectName,
    required super.path,
  }) : super(platform: Platform.macos);

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

  File get podFile => File(p.join(path, 'Podfile'));
}

// TODO better name
final class NoneIosNativeDirectory extends PlatformNativeDirectory {
  NoneIosNativeDirectory({
    required super.projectName,
    required super.platform,
    required super.path,
  });

  factory NoneIosNativeDirectory.resolve({
    required String projectName,
    required String platformRootPackagePath,
    required Platform platform,
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
    // TODO cleaner
    final mason.MasonBundle bundle;
    switch (platform) {
      case Platform.android:
        bundle = androidNativeDirectoryBundle;
      case Platform.linux:
        bundle = linuxNativeDirectoryBundle;
      case Platform.web:
        bundle = webNativeDirectoryBundle;
      default:
        bundle = windowsNativeDirectoryBundle;
    }

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
