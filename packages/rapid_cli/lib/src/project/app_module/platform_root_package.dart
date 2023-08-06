part of '../project.dart';

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

  Future<void> registerFeaturePackage(
    PlatformFeaturePackage featurePackage,
  ) async {
    final packageName = featurePackage.packageName;
    pubSpecFile.setDependency(
      name: packageName,
      dependency: HostedReference(VersionConstraint.empty),
    );
    _addFeaturePackage(packageName, injectionFile: injectionFile);
    if (featurePackage is PlatformRoutableFeaturePackage) {
      _addRouterModule(packageName, routerFile: routerFile);
    }
  }

  Future<void> unregisterFeaturePackage(
    PlatformFeaturePackage featurePackage,
  ) async {
    final packageName = featurePackage.packageName;
    pubSpecFile.removeDependency(name: packageName);
    _removeFeaturePackage(packageName, injectionFile: injectionFile);
    if (featurePackage is PlatformRoutableFeaturePackage) {
      _removeRouterModule(packageName, routerFile: routerFile);
    }
  }

  Future<void> registerInfrastructurePackage(
    InfrastructurePackage infrastructurePackage,
  ) async {
    final packageName = infrastructurePackage.packageName;
    pubSpecFile.setDependency(
      name: packageName,
      dependency: HostedReference(VersionConstraint.empty),
    );
    _addFeaturePackage(packageName, injectionFile: injectionFile);
  }

  Future<void> unregisterInfrastructurePackage(
    InfrastructurePackage infrastructurePackage,
  ) async {
    final packageName = infrastructurePackage.packageName;
    pubSpecFile.removeDependency(name: packageName);
    _removeFeaturePackage(packageName, injectionFile: injectionFile);
  }

  void _addFeaturePackage(
    String packageName, {
    required DartFile injectionFile,
  }) {
    injectionFile.addImport('package:$packageName/$packageName.dart');

    final existingExternalPackageModules =
        _readExternalPackageModules(injectionFile);

    injectionFile.setTypeListOfAnnotationParamOfTopLevelFunction(
      property: 'externalPackageModules',
      annotation: 'InjectableInit',
      functionName: 'configureDependencies',
      value: {
        ...existingExternalPackageModules,
        '${packageName.pascalCase}PackageModule',
      }.toList(),
    );
  }

  void _removeFeaturePackage(
    String packageName, {
    required DartFile injectionFile,
  }) {
    injectionFile.removeImport('package:$packageName/$packageName.dart');

    final existingExternalPackageModules =
        _readExternalPackageModules(injectionFile);

    injectionFile.setTypeListOfAnnotationParamOfTopLevelFunction(
      property: 'externalPackageModules',
      annotation: 'InjectableInit',
      functionName: 'configureDependencies',
      value: existingExternalPackageModules
          .where((e) => !e.contains('${packageName.pascalCase}PackageModule'))
          .toList(),
    );
  }

  List<String> _readExternalPackageModules(DartFile injectionFile) =>
      injectionFile.readTypeListFromAnnotationParamOfTopLevelFunction(
        property: 'externalPackageModules',
        annotation: 'InjectableInit',
        functionName: 'configureDependencies',
      );

  void _addRouterModule(
    String packageName, {
    required DartFile routerFile,
  }) {
    // TODO rm mulitple reads to the file
    routerFile.addImport('package:$packageName/$packageName.dart');

    final moduleName =
        '${packageName.replaceAll('${projectName}_${platform.name}_', '').pascalCase}Module';

    final content = routerFile.readAsStringSync();
    final lines = content.split('\n');
    final lastImportOrExportIndex =
        lines.lastIndexWhere((e) => e.startsWith(RegExp('import|export')));
    lines.insertAll(
      lastImportOrExportIndex + 1,
      ['\n', '// TODO: Add routes of $moduleName to the router.'],
    );
    routerFile.writeAsStringSync(lines.join('\n'));

    final existingModules = _readModules(routerFile);

    routerFile.setTypeListOfAnnotationParamOfClass(
      property: 'modules',
      annotation: 'AutoRouterConfig',
      className: 'Router',
      value: {
        ...existingModules,
        moduleName,
      }.toList(),
    );
  }

  void _removeRouterModule(
    String packageName, {
    required DartFile routerFile,
  }) {
    final imports =
        routerFile.readImports().where((e) => e.contains(packageName));
    for (final import in imports) {
      routerFile.removeImport(import);
    }

    final existingModules = _readModules(routerFile);

    routerFile.setTypeListOfAnnotationParamOfClass(
      property: 'modules',
      annotation: 'AutoRouterConfig',
      className: 'Router',
      value: existingModules
          .where(
            (e) => !e.contains(
              packageName
                  .replaceAll('${projectName}_${platform.name}_', '')
                  .pascalCase,
            ),
          )
          .toList(),
    );
  }

  List<String> _readModules(DartFile routerFile) =>
      routerFile.readTypeListFromAnnotationParamOfClass(
        property: 'modules',
        annotation: 'AutoRouterConfig',
        className: 'Router',
      );
}

class IosRootPackage extends PlatformRootPackage {
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
      platformRootPackagePath: path,
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
        ...platformVars(platform),
      },
    );
    await nativeDirectory.generate(orgName: orgName, language: language);
  }

  void addLanguage(Language language) {
    nativeDirectory.addLanguage(language);
  }

  void removeLanguage(Language language) {
    nativeDirectory.removeLanguage(language);
  }
}

class MacosRootPackage extends PlatformRootPackage {
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
      platformRootPackagePath: path,
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
        ...platformVars(platform),
      },
    );
    await nativeDirectory.generate(orgName: orgName);
  }
}

class MobileRootPackage extends PlatformRootPackage {
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
      platformRootPackagePath: path,
      platform: NativePlatform.android,
    );
    final iosNativeDirectory = IosNativeDirectory.resolve(
      projectName: projectName,
      platformRootPackagePath: path,
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
        ...platformVars(platform),
      },
    );
    await androidNativeDirectory.generate(
      orgName: orgName,
      description: description,
    );
    await iosNativeDirectory.generate(orgName: orgName, language: language);
  }

  void addLanguage(Language language) {
    iosNativeDirectory.addLanguage(language);
  }

  void removeLanguage(Language language) {
    iosNativeDirectory.removeLanguage(language);
  }
}

// TODO better name
class NoneIosRootPackage extends PlatformRootPackage {
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
      platformRootPackagePath: path,
      platform: switch (platform) {
        Platform.android => NativePlatform.android,
        Platform.linux => NativePlatform.linux,
        Platform.web => NativePlatform.web,
        _ => NativePlatform.windows,
      },
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
    String? description,
    String? orgName,
  }) async {
    await mason.generate(
      bundle: platformRootPackageBundle,
      target: this,
      vars: <String, dynamic>{
        'project_name': projectName,
        'description': description,
        'org_name': orgName,
        ...platformVars(platform),
      },
    );
    await nativeDirectory.generate(description: description, orgName: orgName);
  }
}
