import 'package:mason/mason.dart';
import 'package:meta/meta.dart';
import 'package:path/path.dart' as p;
import 'package:rapid_cli/src/core/dart_file_impl.dart';
import 'package:rapid_cli/src/core/dart_package_impl.dart';
import 'package:rapid_cli/src/core/language.dart';
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
  Language defaultLanguage() => supportedLanguages().first;

  @override
  Set<Language> supportedLanguages() =>
      localizationsDelegatesFile.supportedLocales();

  @override
  Future<void> registerFeaturePackage(
    PlatformFeaturePackage featurePackage, {
    required bool routing,
    required bool localization,
  }) async {
    final packageName = featurePackage.packageName();
    pubspecFile.setDependency(packageName);
    injectionFile.addFeaturePackage(packageName);
    if (localization) {
      localizationsDelegatesFile.addLocalizationsDelegate(featurePackage);
    }
    if (routing) {
      routerFile.addRouterModule(packageName);
    }
  }

  @override
  Future<void> unregisterFeaturePackage(
    PlatformFeaturePackage featurePackage,
  ) async {
    final packageName = featurePackage.packageName();
    localizationsDelegatesFile.removeLocalizationsDelegate(featurePackage);
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
  Future<void> addLanguage(
    Language language,
  ) async {
    localizationsDelegatesFile.addSupportedLocale(language);
  }

  @mustCallSuper
  @override
  Future<void> removeLanguage(
    Language language,
  ) async {
    localizationsDelegatesFile.removeSupportedLocale(language);

    if (!language.hasScriptCode && !language.hasCountryCode) {
      for (final locale in localizationsDelegatesFile
          .supportedLocales()
          .where((e) => e.languageCode == language.languageCode)) {
        localizationsDelegatesFile.removeSupportedLocale(locale);
      }
    }
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
    required Set<Language> languages,
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
        'languages': [
          for (final language in languages)
            {
              'language_code': language.languageCode,
              'has_script_code': language.hasScriptCode,
              'script_code': language.scriptCode,
              'has_country_code': language.hasCountryCode,
              'country_code': language.countryCode,
            },
        ],
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
    required Set<Language> languages,
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
        'languages': [
          for (final language in languages)
            {
              'language_code': language.languageCode,
              'has_script_code': language.hasScriptCode,
              'script_code': language.scriptCode,
              'has_country_code': language.hasCountryCode,
              'country_code': language.countryCode,
            },
        ],
      },
    );

    await nativeDirectory.create(
      orgName: orgName,
      languages: languages,
    );
  }

  @override
  Future<void> addLanguage(Language language) async {
    await super.addLanguage(language);
    nativeDirectory.addLanguage(language: language);
  }

  @override
  Future<void> removeLanguage(Language language) async {
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
    required Set<Language> languages,
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
        'languages': [
          for (final language in languages)
            {
              'language_code': language.languageCode,
              'has_script_code': language.hasScriptCode,
              'script_code': language.scriptCode,
              'has_country_code': language.hasCountryCode,
              'country_code': language.countryCode,
            },
        ],
      },
    );

    await iosNativeDirectory.create(
      orgName: orgName,
      languages: languages,
    );
    await androidNativeDirectory.create(
      description: description,
      orgName: orgName,
    );
  }

  @override
  Future<void> addLanguage(Language language) async {
    await super.addLanguage(language);
    iosNativeDirectory.addLanguage(language: language);
  }

  @override
  Future<void> removeLanguage(Language language) async {
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

  @override
  Set<Language> supportedLocales() {
    final supportedLanguagesRaw = readTopLevelListVar(name: 'supportedLocales');
    return supportedLanguagesRaw
        .map((e) => e.toLanguageFromDartLocale())
        .toSet();
  }

  @override
  void addLocalizationsDelegate(PlatformFeaturePackage feature) {
    final packageName = feature.packageName();
    final featureName = feature.name;
    addImport('package:$packageName/$packageName.dart');

    final newDelegate = '${featureName.pascalCase}Localizations.delegate';
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
  void addSupportedLocale(Language locale) {
    final existingLocales = supportedLocales();

    if (!existingLocales.contains(locale)) {
      setTopLevelListVar(
        name: 'supportedLocales',
        value: ([
          locale,
          ...existingLocales,
        ]..sort())
            .map((e) => e.toDartLocal())
            .toList(),
      );
    }
  }

  @override
  void removeLocalizationsDelegate(PlatformFeaturePackage feature) {
    final packageName = feature.packageName();
    final featureName = feature.name;
    removeImport('package:$packageName/$packageName.dart');

    final delegateToRemove = '${featureName.pascalCase}Localizations.delegate';
    final existingDelegates =
        readTopLevelListVar(name: 'localizationsDelegates');

    if (existingDelegates.contains(delegateToRemove)) {
      setTopLevelListVar(
        name: 'localizationsDelegates',
        value: existingDelegates..remove(delegateToRemove),
      );
    }
  }

  @override
  void removeSupportedLocale(Language locale) {
    final existingLocales = supportedLocales();

    if (existingLocales.contains(locale)) {
      setTopLevelListVar(
        name: 'supportedLocales',
        value: (existingLocales.toList()..remove(locale))
            .map((e) => e.toDartLocal())
            .toList(),
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
    // TODO rm mulitple reads to the file
    final projectName = rootPackage.project.name;
    final platformName = rootPackage.platform.name;
    addImport('package:$packageName/$packageName.dart');

    final moduleName =
        '${packageName.replaceAll('${projectName}_${platformName}_', '').pascalCase}Module';

    final content = read();
    final lines = content.split('\n');
    final lastImportOrExportIndex =
        lines.lastIndexWhere((e) => e.startsWith(RegExp('import|export')));
    lines.insertAll(
      lastImportOrExportIndex + 1,
      ['\n', '// TODO: Add routes of $moduleName to the router.'],
    );
    write(lines.join('\n'));

    final existingModules = _readModules();

    setTypeListOfAnnotationParamOfClass(
      property: 'modules',
      annotation: 'AutoRouterConfig',
      className: 'Router',
      value: {
        ...existingModules,
        moduleName,
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

extension on Language {
  String toDartLocal() {
    final countryCodeSegment =
        countryCode != null ? ', countryCode: \'$countryCode\'' : '';
    final scriptCodeSegment =
        scriptCode != null ? ', scriptCode: \'$scriptCode\'' : '';

    return 'const Locale.fromSubtags(languageCode: \'$languageCode\'$scriptCodeSegment$countryCodeSegment)';
  }
}

extension on String {
  Language toLanguageFromDartLocale() {
    final self = replaceAll('\r\n', '')
        .replaceAll('\n', '')
        .replaceAll(RegExp(r'\s\s+'), '');
    final RegExpMatch match;
    if (RegExp(r"Locale\('([A-z]+)'\)").hasMatch(self)) {
      match = RegExp(r"Locale\('([A-z]+)'\)").firstMatch(self)!;
      return Language(languageCode: match.group(1)!);
    } else if (RegExp(r"Locale\('([A-z]+)', '([A-z]+)'\)").hasMatch(self)) {
      match = RegExp(r"Locale\('([A-z]+)', '([A-z]+)'\)").firstMatch(self)!;
      return Language(
          languageCode: match.group(1)!, countryCode: match.group(2)!);
    } else if (RegExp(r"Locale.fromSubtags\(\)").hasMatch(self)) {
      match = RegExp(r"Locale.fromSubtags\(\)").firstMatch(self)!;
      return Language(languageCode: 'und');
    } else if (RegExp(r"Locale.fromSubtags\(languageCode: '([A-z]+)'\)")
        .hasMatch(self)) {
      match = RegExp(r"Locale.fromSubtags\(languageCode: '([A-z]+)'\)")
          .firstMatch(self)!;
      return Language(languageCode: match.group(1)!);
    } else if (RegExp(r"Locale.fromSubtags\(countryCode: '([A-z]+)'\)")
        .hasMatch(self)) {
      match = RegExp(r"Locale.fromSubtags\(countryCode: '([A-z]+)'\)")
          .firstMatch(self)!;
      return Language(languageCode: 'und', countryCode: match.group(1)!);
    } else if (RegExp(r"Locale.fromSubtags\(scriptCode: '([A-z]+)'\)")
        .hasMatch(self)) {
      match = RegExp(r"Locale.fromSubtags\(scriptCode: '([A-z]+)'\)")
          .firstMatch(self)!;
      return Language(languageCode: 'und', scriptCode: match.group(1)!);
    } else if (RegExp(r"Locale.fromSubtags\(languageCode: '([A-z]+)', countryCode: '([A-z]+)'\)")
        .hasMatch(self)) {
      match = RegExp(
              r"Locale.fromSubtags\(languageCode: '([A-z]+)', countryCode: '([A-z]+)'\)")
          .firstMatch(self)!;
      return Language(
          languageCode: match.group(1)!, countryCode: match.group(2)!);
    } else if (RegExp(r"Locale.fromSubtags\(languageCode: '([A-z]+)', scriptCode: '([A-z]+)'\)")
        .hasMatch(self)) {
      match = RegExp(
              r"Locale.fromSubtags\(languageCode: '([A-z]+)', scriptCode: '([A-z]+)'\)")
          .firstMatch(self)!;
      return Language(
          languageCode: match.group(1)!, scriptCode: match.group(2)!);
    } else if (RegExp(r"Locale.fromSubtags\(countryCode: '([A-z]+)', languageCode: '([A-z]+)'\)")
        .hasMatch(self)) {
      match = RegExp(
              r"Locale.fromSubtags\(countryCode: '([A-z]+)', languageCode: '([A-z]+)'\)")
          .firstMatch(self)!;
      return Language(
          countryCode: match.group(1)!, languageCode: match.group(2)!);
    } else if (RegExp(r"Locale.fromSubtags\(countryCode: '([A-z]+)', scriptCode: '([A-z]+)'\)")
        .hasMatch(self)) {
      match = RegExp(
              r"Locale.fromSubtags\(countryCode: '([A-z]+)', scriptCode: '([A-z]+)'\)")
          .firstMatch(self)!;
      return Language(
        languageCode: 'und',
        countryCode: match.group(1)!,
        scriptCode: match.group(2)!,
      );
    } else if (RegExp(r"Locale.fromSubtags\(scriptCode: '([A-z]+)', languageCode: '([A-z]+)'\)")
        .hasMatch(self)) {
      match = RegExp(
              r"Locale.fromSubtags\(scriptCode: '([A-z]+)', languageCode: '([A-z]+)'\)")
          .firstMatch(self)!;
      return Language(
          scriptCode: match.group(1)!, languageCode: match.group(2)!);
    } else if (RegExp(r"Locale.fromSubtags\(scriptCode: '([A-z]+)', countryCode: '([A-z]+)'\)")
        .hasMatch(self)) {
      match = RegExp(
              r"Locale.fromSubtags\(scriptCode: '([A-z]+)', countryCode: '([A-z]+)'\)")
          .firstMatch(self)!;
      return Language(
        languageCode: 'und',
        scriptCode: match.group(1)!,
        countryCode: match.group(2)!,
      );
    } else if (RegExp(r"Locale.fromSubtags\(languageCode: '([A-z]+)', countryCode: '([A-z]+)', scriptCode: '([A-z]+)'\)")
        .hasMatch(self)) {
      match = RegExp(
              r"Locale.fromSubtags\(languageCode: '([A-z]+)', countryCode: '([A-z]+)', scriptCode: '([A-z]+)'\)")
          .firstMatch(self)!;
      return Language(
        languageCode: match.group(1)!,
        countryCode: match.group(2)!,
        scriptCode: match.group(3)!,
      );
    } else if (RegExp(r"Locale.fromSubtags\(languageCode: '([A-z]+)', scriptCode: '([A-z]+)', countryCode: '([A-z]+)'\)")
        .hasMatch(self)) {
      match = RegExp(
              r"Locale.fromSubtags\(languageCode: '([A-z]+)', scriptCode: '([A-z]+)', countryCode: '([A-z]+)'\)")
          .firstMatch(self)!;
      return Language(
        languageCode: match.group(1)!,
        scriptCode: match.group(2)!,
        countryCode: match.group(3)!,
      );
    } else if (RegExp(r"Locale.fromSubtags\(countryCode: '([A-z]+)', languageCode: '([A-z]+)', scriptCode: '([A-z]+)'\)")
        .hasMatch(self)) {
      match = RegExp(
              r"Locale.fromSubtags\(countryCode: '([A-z]+)', languageCode: '([A-z]+)', scriptCode: '([A-z]+)'\)")
          .firstMatch(self)!;
      return Language(
        countryCode: match.group(1)!,
        languageCode: match.group(2)!,
        scriptCode: match.group(3)!,
      );
    } else if (RegExp(
            r"Locale.fromSubtags\(countryCode: '([A-z]+)', scriptCode: '([A-z]+)', languageCode: '([A-z]+)'\)")
        .hasMatch(self)) {
      match = RegExp(
              r"Locale.fromSubtags\(countryCode: '([A-z]+)', scriptCode: '([A-z]+)', languageCode: '([A-z]+)'\)")
          .firstMatch(self)!;
      return Language(
        countryCode: match.group(1)!,
        scriptCode: match.group(2)!,
        languageCode: match.group(3)!,
      );
    } else if (RegExp(
            r"Locale.fromSubtags\(scriptCode: '([A-z]+)', languageCode: '([A-z]+)', countryCode: '([A-z]+)'\)")
        .hasMatch(self)) {
      match = RegExp(
              r"Locale.fromSubtags\(scriptCode: '([A-z]+)', languageCode: '([A-z]+)', countryCode: '([A-z]+)'\)")
          .firstMatch(self)!;
      return Language(
        scriptCode: match.group(1)!,
        languageCode: match.group(2)!,
        countryCode: match.group(3)!,
      );
    } else if (RegExp(
            r"Locale.fromSubtags\(scriptCode: '([A-z]+)', countryCode: '([A-z]+)', languageCode: '([A-z]+)'\)")
        .hasMatch(self)) {
      match = RegExp(
              r"Locale.fromSubtags\(scriptCode: '([A-z]+)', countryCode: '([A-z]+)', languageCode: '([A-z]+)'\)")
          .firstMatch(self)!;
      return Language(
        scriptCode: match.group(1)!,
        countryCode: match.group(2)!,
        languageCode: match.group(3)!,
      );
    }

    // TODO
    throw Error();
  }
}
