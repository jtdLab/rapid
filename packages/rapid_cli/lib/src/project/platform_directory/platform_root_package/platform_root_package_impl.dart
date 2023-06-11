import 'package:mason/mason.dart';
import 'package:meta/meta.dart';
import 'package:path/path.dart' as p;
import 'package:rapid_cli/src/core/dart_file_impl.dart';
import 'package:rapid_cli/src/core/dart_package_impl.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/project/core/generator_mixins.dart';

import '../../infrastructure_directory/infrastructure_package/infrastructure_package.dart';
import '../../project.dart';
import '../platform_features_directory/platform_feature_package/platform_feature_package.dart';
import 'platform_native_directory/platform_native_directory.dart';
import 'platform_root_package.dart';
import 'platform_root_package_bundle.dart';

abstract class PlatformRootPackageImpl extends DartPackageImpl
    with OverridableGenerator, Generatable
    implements PlatformRootPackage {
  PlatformRootPackageImpl(
    this.platform, {
    required this.project,
  }) : super(
          path: p.join(
            project.path,
            'packages',
            project.name,
            '${project.name}_${platform.name}',
            '${project.name}_${platform.name}',
          ),
        );

  @override
  LocalizationsDelegatesFileBuilder? localizationsDelegatesFileOverrides;

  @override
  InjectionFileBuilder? injectionFileOverrides;

  @override
  RouterFileBuilder? routerFileOverrides;

  @override
  LocalizationsDelegatesFile get localizationsDelegatesFile =>
      (localizationsDelegatesFileOverrides ?? LocalizationsDelegatesFile.new)(
        rootPackage: this,
      );

  @override
  InjectionFile get injectionFile =>
      (injectionFileOverrides ?? InjectionFile.new)(
        rootPackage: this,
      );

  @override
  RouterFile get routerFile => (routerFileOverrides ?? RouterFile.new)(
        rootPackage: this,
      );

  @override
  final Platform platform;

  @override
  final RapidProject project;

  // TODO is this correct ??????
  @override
  String defaultLanguage() => supportedLanguages().first;

  @override
  Set<String> supportedLanguages() =>
      localizationsDelegatesFile.supportedLocales();

  @override
  Future<void> registerFeaturePackage(
    PlatformFeaturePackage featurePackage, {
    required bool routing,
  }) async {
    final packageName = featurePackage.packageName();
    localizationsDelegatesFile.addLocalizationsDelegate(packageName);
    pubspecFile.setDependency(packageName);
    injectionFile.addFeaturePackage(packageName);
    if (routing) {
      routerFile.addRouterModule(packageName);
    }
  }

  @override
  Future<void> unregisterFeaturePackage(
    PlatformFeaturePackage featurePackage,
  ) async {
    final packageName = featurePackage.packageName();
    localizationsDelegatesFile.removeLocalizationsDelegate(packageName);
    pubspecFile.removeDependency(packageName);
    injectionFile.removeFeaturePackage(packageName);
    routerFile.removeRouterModule(packageName);
  }

  @override
  Future<void> registerInfrastructurePackage(
    InfrastructurePackage infrastructurePackage,
  ) async {
    final packageName = infrastructurePackage.packageName();
    pubspecFile.setDependency(packageName);
    injectionFile.addFeaturePackage(packageName);
  }

  @override
  Future<void> unregisterInfrastructurePackage(
    InfrastructurePackage infrastructurePackage,
  ) async {
    final packageName = infrastructurePackage.packageName();
    pubspecFile.removeDependency(packageName);
    injectionFile.removeFeaturePackage(packageName);
  }

  @mustCallSuper
  @override
  Future<void> addLanguage(String language) async {
    localizationsDelegatesFile.addSupportedLocale(language);
  }

  @mustCallSuper
  @override
  Future<void> removeLanguage(String language) async {
    localizationsDelegatesFile.removeSupportedLocale(language);
  }
}

class NoneIosRootPackageImpl extends PlatformRootPackageImpl
    implements NoneIosRootPackage {
  NoneIosRootPackageImpl(
    super.platform, {
    required super.project,
  }) : assert(platform != Platform.ios);

  @override
  NoneIosNativeDirectoryBuilder? nativeDirectoryOverrides;

  @override
  NoneIosNativeDirectory get nativeDirectory =>
      (nativeDirectoryOverrides ?? NoneIosNativeDirectory.new)(
        rootPackage: this,
      );

  @override
  Future<void> create({
    String? description,
    String? orgName,
  }) async {
    final projectName = project.name;

    await generate(
      bundle: platformRootPackageBundle,
      vars: <String, dynamic>{
        'project_name': projectName,
        if (description != null) 'description': description,
        if (orgName != null) 'org_name': orgName,
        'android': platform == Platform.android,
        'linux': platform == Platform.linux,
        'macos': platform == Platform.macos,
        'web': platform == Platform.web,
        'windows': platform == Platform.windows,
      },
    );

    await nativeDirectory.create(
      description: description,
      orgName: orgName,
    );
  }
}

class IosRootPackageImpl extends PlatformRootPackageImpl
    implements IosRootPackage {
  IosRootPackageImpl({
    required super.project,
  }) : super(Platform.ios);

  @override
  IosNativeDirectoryBuilder? nativeDirectoryOverrides;

  @override
  IosNativeDirectory get nativeDirectory =>
      (nativeDirectoryOverrides ?? IosNativeDirectory.new)(
        rootPackage: this,
      );

  @override
  Future<void> create({
    required String orgName,
    required String language,
  }) async {
    final projectName = project.name;

    await generate(
      bundle: platformRootPackageBundle,
      vars: <String, dynamic>{
        'project_name': projectName,
        'org_name': orgName,
        'android': false,
        'ios': true,
        'linux': false,
        'macos': false,
        'web': false,
        'windows': false,
        'mobile': false,
      },
    );

    await nativeDirectory.create(
      orgName: orgName,
      language: language,
    );
  }

  @override
  Future<void> addLanguage(String language) async {
    await super.addLanguage(language);
    nativeDirectory.addLanguage(language: language);
  }

  @override
  Future<void> removeLanguage(String language) async {
    await super.removeLanguage(language);
    nativeDirectory.removeLanguage(language: language);
  }
}

class MobileRootPackageImpl extends PlatformRootPackageImpl
    implements MobileRootPackage {
  MobileRootPackageImpl({
    required super.project,
  }) : super(Platform.mobile);

  @override
  IosNativeDirectoryBuilder? iosNativeDirectoryOverrides;

  @override
  NoneIosNativeDirectoryBuilder? androidNativeDirectoryOverrides;

  @override
  IosNativeDirectory get iosNativeDirectory =>
      (iosNativeDirectoryOverrides ?? IosNativeDirectory.new)(
        rootPackage: this,
      );

  @override
  NoneIosNativeDirectory get androidNativeDirectory =>
      (androidNativeDirectoryOverrides ?? NoneIosNativeDirectory.new)(
        rootPackage: this,
      );

  @override
  Future<void> create({
    required String orgName,
    required String language,
    String? description,
  }) async {
    final projectName = project.name;

    await generate(
      bundle: platformRootPackageBundle,
      vars: <String, dynamic>{
        'project_name': projectName,
        'org_name': orgName,
        'android': false,
        'ios': false,
        'linux': false,
        'macos': false,
        'web': false,
        'windows': false,
        'mobile': true,
      },
    );

    await iosNativeDirectory.create(
      orgName: orgName,
      language: language,
    );
    await androidNativeDirectory.create(
      description: description,
      orgName: orgName,
    );
  }

  @override
  Future<void> addLanguage(String language) async {
    await super.addLanguage(language);
    iosNativeDirectory.addLanguage(language: language);
  }

  @override
  Future<void> removeLanguage(String language) async {
    await super.removeLanguage(language);
    iosNativeDirectory.removeLanguage(language: language);
  }
}

class LocalizationsDelegatesFileImpl extends DartFileImpl
    implements LocalizationsDelegatesFile {
  LocalizationsDelegatesFileImpl({
    required PlatformRootPackage rootPackage,
  }) : super(
          path: p.join(rootPackage.path, 'lib'),
          name: 'localizations_delegates',
        );

  // TODO impl cleaner without ! ?
  @override
  Set<String> supportedLocales() =>
      readTopLevelListVar(name: 'supportedLocales')
          .map((e) => RegExp(r"Locale\('([a-z]+)'\)").firstMatch(e)!.group(1)!)
          .toSet();

  @override
  void addLocalizationsDelegate(String packageName) {
    addImport('package:$packageName/$packageName.dart');

    final newDelegate = '${packageName.pascalCase}Localizations.delegate';
    final existingDelegates =
        readTopLevelListVar(name: 'localizationsDelegates');

    if (!existingDelegates.contains(newDelegate)) {
      setTopLevelListVar(
        name: 'localizationsDelegates',
        value: [
          newDelegate,
          ...existingDelegates,
        ]..sort(),
      );
    }
  }

  @override
  void addSupportedLocale(String locale) {
    final newLocale = 'const Locale(\'$locale\')';
    final existingLocales = readTopLevelListVar(name: 'supportedLocales');

    if (!existingLocales.contains(locale)) {
      setTopLevelListVar(
        name: 'supportedLocales',
        value: [
          newLocale,
          ...existingLocales,
        ]..sort(),
      );
    }
  }

  @override
  void removeLocalizationsDelegate(String packageName) {
    removeImport('package:$packageName/$packageName.dart');

    final deleteToRemove = '${packageName.pascalCase}Localizations.delegate';
    final existingDelegates =
        readTopLevelListVar(name: 'localizationsDelegates');

    if (existingDelegates.contains(deleteToRemove)) {
      setTopLevelListVar(
        name: 'localizationsDelegates',
        value: existingDelegates..remove(deleteToRemove),
      );
    }
  }

  @override
  void removeSupportedLocale(String locale) {
    final localeToRemove = 'const Locale(\'$locale\')';
    final existingLocales = readTopLevelListVar(name: 'supportedLocales');

    if (existingLocales.contains(localeToRemove)) {
      setTopLevelListVar(
        name: 'supportedLocales',
        value: existingLocales..remove(localeToRemove),
      );
    }
  }
}

class InjectionFileImpl extends DartFileImpl implements InjectionFile {
  InjectionFileImpl({
    required PlatformRootPackage rootPackage,
  }) : super(
          path: p.join(rootPackage.path, 'lib'),
          name: 'injection',
        );

  @override
  void addFeaturePackage(String packageName) {
    addImport('package:$packageName/$packageName.dart');

    final existingExternalPackageModules = _readExternalPackageModules();

    setTypeListOfAnnotationParamOfTopLevelFunction(
      property: 'externalPackageModules',
      annotation: 'InjectableInit',
      functionName: 'configureDependencies',
      value: {
        ...existingExternalPackageModules,
        '${packageName.pascalCase}PackageModule',
      }.toList(),
    );
  }

  @override
  void removeFeaturePackage(String packageName) {
    final imports = readImports().where((e) => e.contains(packageName));
    for (final import in imports) {
      removeImport(import);
    }

    final existingExternalPackageModules = _readExternalPackageModules();

    setTypeListOfAnnotationParamOfTopLevelFunction(
      property: 'externalPackageModules',
      annotation: 'InjectableInit',
      functionName: 'configureDependencies',
      value: existingExternalPackageModules
          .where((e) => !e.contains('${packageName.pascalCase}PackageModule'))
          .toList(),
    );
  }

  List<String> _readExternalPackageModules() =>
      readTypeListFromAnnotationParamOfTopLevelFunction(
        property: 'externalPackageModules',
        annotation: 'InjectableInit',
        functionName: 'configureDependencies',
      );
}

class RouterFileImpl extends DartFileImpl implements RouterFile {
  RouterFileImpl({
    required this.rootPackage,
  }) : super(
          path: p.join(rootPackage.path, 'lib'),
          name: 'router',
        );

  final PlatformRootPackage rootPackage;

  @override
  void addRouterModule(String packageName) {
    final projectName = rootPackage.project.name;
    final platformName = rootPackage.platform.name;
    addImport('package:$packageName/$packageName.dart');

    final existingModules = _readModules();

    setTypeListOfAnnotationParamOfClass(
      property: 'modules',
      annotation: 'AutoRouterConfig',
      className: 'Router',
      value: {
        ...existingModules,
        '${packageName.replaceAll('${projectName}_${platformName}_', '').pascalCase}Module',
      }.toList(),
    );
  }

  @override
  void removeRouterModule(String packageName) {
    final projectName = rootPackage.project.name;
    final platformName = rootPackage.platform.name;

    final imports = readImports().where((e) => e.contains(packageName));
    for (final import in imports) {
      removeImport(import);
    }

    final existingModules = _readModules();

    print(packageName
        .replaceAll('${projectName}_${platformName}_', '')
        .pascalCase);

    setTypeListOfAnnotationParamOfClass(
      property: 'modules',
      annotation: 'AutoRouterConfig',
      className: 'Router',
      value: existingModules
          .where(
            (e) => !e.contains(
              packageName
                  .replaceAll('${projectName}_${platformName}_', '')
                  .pascalCase,
            ),
          )
          .toList(),
    );
  }

  List<String> _readModules() => readTypeListFromAnnotationParamOfClass(
        property: 'modules',
        annotation: 'AutoRouterConfig',
        className: 'Router',
      );
}
