part of '../project.dart';

// TODO(jtdLab): better name for none ios root package

/// {@template platform_root_package}
/// Base class for:
///
///  * [IosRootPackage]
///
///  * [MacosRootPackage]
///
///  * [MobileRootPackage]
///
///  * [NoneIosRootPackage]
/// {@endtemplate}
sealed class PlatformRootPackage extends DartPackage {
  /// {@macro platform_root_package}
  PlatformRootPackage({
    required this.projectName,
    required this.platform,
    required String path,
  }) : super(path);

  /// The name of the project this package is part of.
  final String projectName;

  /// The platform.
  final Platform platform;

  /// The `lib/injection.dart` file.
  DartFile get injectionFile => DartFile(p.join(path, 'lib', 'injection.dart'));

  /// The `lib/router.dart` file.
  DartFile get routerFile => DartFile(p.join(path, 'lib', 'router.dart'));

  /// Registers [featurePackage] with this package.
  ///
  /// This adds the [featurePackage] as a dependency to the [pubSpecFile]
  /// and its [injectable module](https://pub.dev/packages/injectable#including-micropackages-and-external-modules)
  /// to the [injectionFile].
  ///
  /// If [featurePackage] is routable this also adds its [auto_router module](https://pub.dev/packages/auto_route#including-microexternal-packages)
  /// to the [routerFile].
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

  /// Unregisters [featurePackage] from this package.
  ///
  /// This removes the [featurePackage] dependency from the [pubSpecFile]
  /// and its [injectable module](https://pub.dev/packages/injectable#including-micropackages-and-external-modules)
  /// from the [injectionFile].
  ///
  /// If [featurePackage] is routable this also removes its [auto_router module](https://pub.dev/packages/auto_route#including-microexternal-packages)
  /// from the [routerFile].
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

  /// Registers [infrastructurePackage] with this package.
  ///
  /// This adds the [infrastructurePackage] as a dependency to the [pubSpecFile]
  /// and its [injectable module](https://pub.dev/packages/injectable#including-micropackages-and-external-modules)
  /// to the [injectionFile].
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

  /// Unregisters [infrastructurePackage] from this package.
  ///
  /// This removes the [infrastructurePackage] dependency from the [pubSpecFile]
  /// and its [injectable module](https://pub.dev/packages/injectable#including-micropackages-and-external-modules)
  /// from the [injectionFile].
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
    // TODO(jtdLab): rm mulitple reads to the file
    routerFile.addImport('package:$packageName/$packageName.dart');

    final moduleName =
        '''${packageName.replaceAll('${projectName}_${platform.name}_', '').pascalCase}Module''';

    final content = routerFile.readAsStringSync();
    final lines = content.split('\n');
    final lastImportOrExportIndex =
        lines.lastIndexWhere((e) => e.startsWith(RegExp('import|export')));
    lines.insertAll(
      lastImportOrExportIndex + 1,
      ['\n', '// TODO(jtdLab): Add routes of $moduleName to the router.'],
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

/// {@template ios_root_package}
/// Abstraction of the ios root package of a Rapid project.
///
// TODO(jtdLab): more docs.
/// {@endtemplate}
class IosRootPackage extends PlatformRootPackage {
  /// {@macro ios_root_package}
  IosRootPackage({
    required super.projectName,
    required super.path,
    required this.nativeDirectory,
  }) : super(platform: Platform.ios);

  /// Returns a [IosRootPackage] from given [projectName] and [projectPath].
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

  /// The native directory of this package.
  final IosNativeDirectory nativeDirectory;

  /// Generate this package on disk.
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

  /// Adds [language] to this package.
  void addLanguage(Language language) {
    nativeDirectory.addLanguage(language);
  }

  /// Removes [language] from this package.
  void removeLanguage(Language language) {
    nativeDirectory.removeLanguage(language);
  }
}

/// {@template macos_root_package}
/// Abstraction of the macos root package of a Rapid project.
///
// TODO(jtdLab): more docs.
/// {@endtemplate}
class MacosRootPackage extends PlatformRootPackage {
  /// {@macro macos_root_package}
  MacosRootPackage({
    required super.projectName,
    required super.path,
    required this.nativeDirectory,
  }) : super(platform: Platform.macos);

  /// Returns a [MacosRootPackage] from given [projectName] and [projectPath].
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

  /// The native directory of this package.
  final MacosNativeDirectory nativeDirectory;

  /// Generate this package on disk.
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

/// {@template mobile_root_package}
/// Abstraction of the mobile root package of a Rapid project.
///
// TODO(jtdLab): more docs.
/// {@endtemplate}
class MobileRootPackage extends PlatformRootPackage {
  /// {@macro mobile_root_package}
  MobileRootPackage({
    required super.projectName,
    required super.path,
    required this.androidNativeDirectory,
    required this.iosNativeDirectory,
  }) : super(platform: Platform.mobile);

  /// Returns a [MobileRootPackage] from given [projectName] and [projectPath].
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

  /// The native directory of this package. (Android)
  final NoneIosNativeDirectory androidNativeDirectory;

  /// The native directory of this package. (iOS)
  final IosNativeDirectory iosNativeDirectory;

  /// Generate this package on disk.
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

  /// Adds [language] to this package.
  void addLanguage(Language language) {
    iosNativeDirectory.addLanguage(language);
  }

  /// Removes [language] from this package.
  void removeLanguage(Language language) {
    iosNativeDirectory.removeLanguage(language);
  }
}

/// {@template none_ios_root_package}
/// Abstraction of a none ios root package of a Rapid project.
///
// TODO(jtdLab): more docs.
/// {@endtemplate}
class NoneIosRootPackage extends PlatformRootPackage {
  /// {@macro none_ios_root_package}
  NoneIosRootPackage({
    required super.projectName,
    required super.platform,
    required super.path,
    required this.nativeDirectory,
  });

  /// Returns a [NoneIosRootPackage] with [platform] from given [projectName]
  /// and [projectPath].
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

  /// The native directory of this package.
  final NoneIosNativeDirectory nativeDirectory;

  /// Generate this package on disk.
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
