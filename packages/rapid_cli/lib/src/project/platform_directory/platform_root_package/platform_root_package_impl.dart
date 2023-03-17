import 'package:mason/mason.dart';
import 'package:path/path.dart' as p;
import 'package:rapid_cli/src/core/dart_file_impl.dart';
import 'package:rapid_cli/src/core/dart_package_impl.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/project/core/generator_mixins.dart';
import 'package:rapid_cli/src/project/platform_directory/platform_features_directory/platform_feature_package/platform_feature_package.dart';
import 'package:rapid_cli/src/project/platform_directory/platform_root_package/platform_native_directory/platform_native_directory.dart';
import 'package:rapid_cli/src/project/project.dart';

import 'platform_root_package.dart';
import 'platform_root_package_bundle.dart';

abstract class PlatformRootPackageImpl extends DartPackageImpl
    with OverridableGenerator, Generatable
    implements PlatformRootPackage {
  PlatformRootPackageImpl(
    this.platform, {
    required this.project,
  })  : _platform = platform,
        super(
          path: p.join(
            project.path,
            'packages',
            project.name(),
            '${project.name()}_${platform.name}',
            '${project.name()}_${platform.name}',
          ),
        );

  final Platform _platform;
  LocalizationsDelegatesFile get _localizationsDelegatesFile =>
      (localizationsDelegatesFileOverrides ??
          LocalizationsDelegatesFileImpl.new)(rootPackage: this);
  InjectionFile get _injectionFile =>
      (injectionFileOverrides ?? InjectionFileImpl.new)(rootPackage: this);

  @override
  LocalizationsDelegatesFileBuilder? localizationsDelegatesFileOverrides;

  @override
  InjectionFileBuilder? injectionFileOverrides;

  @override
  final Platform platform;

  @override
  final Project project;

  @override
  Set<String> supportedLanguages() =>
      _localizationsDelegatesFile.supportedLocales();

  @override
  Future<void> registerFeaturePackage(
    PlatformFeaturePackage featurePackage, {
    required Logger logger,
  }) async {
    pubspecFile.setDependency(featurePackage.packageName());
    _localizationsDelegatesFile.addLocalizationsDelegate(featurePackage);

    pubspecFile.setDependency(featurePackage.packageName());
    _injectionFile.addFeaturePackage(featurePackage);
  }

  @override
  Future<void> unregisterFeaturePackage(
    PlatformFeaturePackage featurePackage, {
    required Logger logger,
  }) async {
    pubspecFile.removeDependency(featurePackage.packageName());
    _localizationsDelegatesFile.removeLocalizationsDelegate(featurePackage);

    pubspecFile.removeDependency(featurePackage.packageName());
    _injectionFile.removeFeaturePackage(featurePackage);
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

  NoneIosNativeDirectory get _nativeDirectory =>
      (nativeDirectoryOverrides ?? NoneIosNativeDirectory.new)(
        rootPackage: this,
      );

  @override
  Future<void> create({
    String? description,
    String? orgName,
    required Logger logger,
  }) async {
    final projectName = project.name();

    await generate(
      name: 'root package (${platform.name})',
      bundle: platformRootPackageBundle,
      vars: <String, dynamic>{
        'project_name': projectName,
        if (description != null) 'description': description,
        if (orgName != null) 'org_name': orgName,
        'android': _platform == Platform.android,
        'linux': _platform == Platform.linux,
        'macos': _platform == Platform.macos,
        'web': _platform == Platform.web,
        'windows': _platform == Platform.windows,
      },
      logger: logger,
    );

    _nativeDirectory.create(
      description: description,
      orgName: orgName,
      logger: logger,
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

  IosNativeDirectory get _nativeDirectory =>
      (nativeDirectoryOverrides ?? IosNativeDirectory.new)(
        rootPackage: this,
      );

  @override
  Future<void> create({
    required String orgName,
    required String language,
    required Logger logger,
  }) async {
    final projectName = project.name();

    await generate(
      name: 'root package (ios)',
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
      },
      logger: logger,
    );

    await _nativeDirectory.create(
      orgName: orgName,
      language: language,
      logger: logger,
    );
  }

  @override
  Future<void> addLanguage(
    String language, {
    required Logger logger,
  }) async {
    _nativeDirectory.addLanguage(language: language);
  }

  @override
  Future<void> removeLanguage(
    String language, {
    required Logger logger,
  }) async {
    _nativeDirectory.removeLanguage(language: language);
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
  void addLocalizationsDelegate(PlatformFeaturePackage featurePackage) {
    final packageName = featurePackage.packageName();
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
    final newLocale = 'Locale(\'$locale\')';
    final existingLocales = readTopLevelListVar(name: 'supportedLocales');

    if (!existingLocales.contains(locale)) {
      setTopLevelListVar(
        name: 'localizationsDelegates',
        value: [
          newLocale,
          ...existingLocales,
        ]..sort(),
      );
    }
  }

  @override
  void removeLocalizationsDelegate(PlatformFeaturePackage featurePackage) {
    final packageName = featurePackage.packageName();
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
    final localeToRemove = 'Locale(\'$locale\')';
    final existingLocales = readTopLevelListVar(name: 'supportedLocales');

    if (existingLocales.contains(localeToRemove)) {
      setTopLevelListVar(
        name: 'localizationsDelegates',
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
  void addFeaturePackage(PlatformFeaturePackage featurePackage) {
    final packageName = featurePackage.packageName();

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
  void removeFeaturePackage(PlatformFeaturePackage featurePackage) {
    final packageName = featurePackage.packageName();

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
          .where((e) => !e.contains(packageName.pascalCase))
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
