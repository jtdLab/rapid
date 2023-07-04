part of '../../project.dart';

sealed class PlatformRootPackage extends DartPackage {
  PlatformRootPackage({
    required this.projectName,
    required this.platform,
    required String path,
  }) : super(path);

  final String projectName;

  final Platform platform;

  DartFile get injectionFile => DartFile(p.join(path, 'lib', 'injection.dart'));

  DartFile get routerFile => DartFile(p.join(path, 'lib', 'router.dart'));
}

final class IosRootPackage extends PlatformRootPackage {
  IosRootPackage({
    required super.projectName,
    required super.path,
    required this.nativeDirectory,
  }) : super(platform: Platform.ios);

  factory IosRootPackage.resolve({
    required String projectName,
    required String projectPath,
  }) {
    final path = p.join(
      projectPath,
      'packages',
      projectName,
      '${projectName}_ios',
      '${projectName}_ios',
    );
    final nativeDirectory = IosNativeDirectory.resolve(
      projectName: projectName,
      projectPath: projectPath,
    );

    return IosRootPackage(
      projectName: projectName,
      path: path,
      nativeDirectory: nativeDirectory,
    );
  }

  final IosNativeDirectory nativeDirectory;

  Future<void> generate({
    required String orgName,
    required Language language,
  }) async {
    await mason.generate(
      bundle: platformRootPackageBundle,
      target: this,
      vars: <String, dynamic>{
        'project_name': projectName,
        'org_name': orgName,
        'platform': platform.name,
      },
    );
    await nativeDirectory.generate(orgName: orgName, language: language);
  }
}

final class MacosRootPackage extends PlatformRootPackage {
  MacosRootPackage({
    required super.projectName,
    required super.path,
    required this.nativeDirectory,
  }) : super(platform: Platform.macos);

  factory MacosRootPackage.resolve({
    required String projectName,
    required String projectPath,
  }) {
    final path = p.join(
      projectPath,
      'packages',
      projectName,
      '${projectName}_macos',
      '${projectName}_macos',
    );
    final nativeDirectory = MacosNativeDirectory.resolve(
      projectName: projectName,
      projectPath: projectPath,
    );

    return MacosRootPackage(
      projectName: projectName,
      path: path,
      nativeDirectory: nativeDirectory,
    );
  }

  final MacosNativeDirectory nativeDirectory;

  Future<void> generate({required String orgName}) async {
    await mason.generate(
      bundle: platformRootPackageBundle,
      target: this,
      vars: <String, dynamic>{
        'project_name': projectName,
        'org_name': orgName,
        'platform': platform.name,
      },
    );
    await nativeDirectory.generate(orgName: orgName);
  }
}

// TODO better name
final class NoneIosRootPackage extends PlatformRootPackage {
  NoneIosRootPackage({
    required super.projectName,
    required super.platform,
    required super.path,
    required this.nativeDirectory,
  });

  factory NoneIosRootPackage.resolve({
    required String projectName,
    required String projectPath,
    required Platform platform,
  }) {
    final path = p.join(
      projectPath,
      'packages',
      projectName,
      '${projectName}_${platform.name}',
      '${projectName}_${platform.name}',
    );
    final nativeDirectory = NoneIosNativeDirectory.resolve(
      projectName: projectName,
      projectPath: projectPath,
      platform: platform,
    );

    return NoneIosRootPackage(
      projectName: projectName,
      platform: platform,
      path: path,
      nativeDirectory: nativeDirectory,
    );
  }

  final NoneIosNativeDirectory nativeDirectory;

  Future<void> generate({
    required String description,
    required String orgName,
  }) async {
    await mason.generate(
      bundle: platformRootPackageBundle,
      target: this,
      vars: <String, dynamic>{
        'project_name': projectName,
        'description': description,
        'org_name': orgName,
        'platform': platform.name,
      },
    );
    await nativeDirectory.generate(description: description, orgName: orgName);
  }
}

final class MobileRootPackage extends PlatformRootPackage {
  MobileRootPackage({
    required super.projectName,
    required super.path,
    required this.androidNativeDirectory,
    required this.iosNativeDirectory,
  }) : super(platform: Platform.mobile);

  factory MobileRootPackage.resolve({
    required String projectName,
    required String projectPath,
  }) {
    final path = p.join(
      projectPath,
      'packages',
      projectName,
      '${projectName}_mobile',
      '${projectName}_mobile',
    );
    final androidNativeDirectory = NoneIosNativeDirectory.resolve(
      projectName: projectName,
      projectPath: projectPath,
      platform: Platform.android,
    );
    final iosNativeDirectory = IosNativeDirectory.resolve(
      projectName: projectName,
      projectPath: projectPath,
    );

    return MobileRootPackage(
      projectName: projectName,
      path: path,
      androidNativeDirectory: androidNativeDirectory,
      iosNativeDirectory: iosNativeDirectory,
    );
  }

  final NoneIosNativeDirectory androidNativeDirectory;

  final IosNativeDirectory iosNativeDirectory;

  Future<void> generate({
    required String orgName,
    required String description,
    required Language language,
  }) async {
    await mason.generate(
      bundle: platformRootPackageBundle,
      target: this,
      vars: <String, dynamic>{
        'project_name': projectName,
        'org_name': orgName,
        'platform': platform.name,
      },
    );
    await androidNativeDirectory.generate(
      orgName: orgName,
      description: description,
    );
    await iosNativeDirectory.generate(orgName: orgName, language: language);
  }
}
