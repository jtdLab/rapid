import 'dart:convert';

import 'package:mason/mason.dart' show StringCaseExtensions;
import 'package:path/path.dart' as p;
import 'package:rapid_cli/src/project/language.dart';
import 'package:rapid_cli/src/project/platform.dart';
import 'package:yaml/yaml.dart';

import 'io.dart';
import 'io.dart' as io;
import 'platform.dart';
import 'process.dart';
import 'project/project.dart';

export 'package:pubspec/pubspec.dart';

const globalOptionVersion = 'version';
const globalOptionVerbose = 'verbose';

String multiLine(List<String> lines) => lines.join('\n');

const envKeyRapidTerminalWidth = 'RAPID_TERMINAL_WIDTH';

bool dirExists(String directory) {
  final dir = Directory(directory);
  return dir.existsSync();
}

bool dirIsEmpty(String directory) {
  final dir = Directory(directory);
  return dir.listSync().isEmpty;
}

void replaceInFile(File file, String from, String replace) {
  final content = file.readAsStringSync();
  final updatedContent = content.replaceAll(from, replace);
  file.writeAsStringSync(updatedContent);
}

// TODO only used once
String pubspecYamlPathForDirectory(String directory) =>
    p.join(directory, 'pubspec.yaml');

int get terminalWidth {
  if (currentPlatform.environment.containsKey(envKeyRapidTerminalWidth)) {
    return int.tryParse(
          currentPlatform.environment[envKeyRapidTerminalWidth]!,
          radix: 10,
        ) ??
        80;
  }

  if (stdout.hasTerminal) {
    return stdout.terminalColumns;
  }

  return 80;
}

Future<ProcessResult> runCommand(
  List<String> cmd, {
  String? workingDirectory,
}) async {
  return currentProcessManager.run(
    cmd,
    workingDirectory: workingDirectory,
    runInShell: true,
    stderrEncoding: utf8,
    stdoutEncoding: utf8,
  );
}

Future<Process> startCommand(
  List<String> cmd, {
  String? workingDirectory,
}) async {
  return currentProcessManager.start(
    cmd,
    workingDirectory: workingDirectory,
    runInShell: true,
  );
}

extension YamlUtils on YamlNode {
  /// Converts a YAML node to a regular mutable Dart object.
  Object? toPlainObject() {
    final node = this;
    if (node is YamlScalar) {
      return node.value;
    }
    if (node is YamlMap) {
      return {
        for (final entry in node.nodes.entries)
          (entry.key as YamlNode).toPlainObject(): entry.value.toPlainObject(),
      };
    }
    if (node is YamlList) {
      return node.nodes.map((node) => node.toPlainObject()).toList();
    }
    throw FormatException(
      'Unsupported YAML node type encountered: ${node.runtimeType}',
      this,
    );
  }
}

extension StreamUtils<T> on Stream<T> {
  /// Runs [convert] for each event in this stream and emits the result, while
  /// ensuring that no more events than specified by [parallelism] are being
  /// processed at any given time.
  ///
  /// If [parallelism] is `null`, [Platform.numberOfProcessors] is used.
  Stream<R> parallel<R>(
    Future<R> Function(T) convert, {
    int? parallelism,
  }) async* {
    final pending = <Future<R>>[];
    final done = <Future<R>>[];

    await for (final value in this) {
      late final Future<R> future;
      future = Future(() async {
        try {
          return await convert(value);
        } finally {
          pending.remove(future);
          done.add(future);
        }
      });
      pending.add(future);

      if (pending.length < (parallelism ?? io.Platform.numberOfProcessors)) {
        continue;
      }

      await Future.any(pending);

      for (final future in done) {
        yield await future;
      }
      done.clear();
    }

    for (final result in await Future.wait(pending)) {
      yield result;
    }
  }
}

extension RapidProjectUtils on RapidProject {
  bool platformIsActivated(Platform platform) {
    return appModule
            .platformDirectory(platform: platform)
            .rootPackage
            .existsSync() &&
        appModule
            .platformDirectory(platform: platform)
            .localizationPackage
            .existsSync() &&
        appModule
            .platformDirectory(platform: platform)
            .navigationPackage
            .existsSync() &&
        appModule
            .platformDirectory(platform: platform)
            .featuresDirectory
            .appFeaturePackage
            .existsSync() &&
        uiModule.platformUiPackage(platform: platform).existsSync();
  }

  List<DartPackage> packages() => [
        rootPackage,
        appModule.diPackage,
        appModule.loggingPackage,
        ...appModule.domainDirectory.domainPackages(),
        ...appModule.infrastructureDirectory.infrastructurePackages(),
        uiModule.uiPackage,
        for (final platform in Platform.values) ...[
          appModule.platformDirectory(platform: platform).rootPackage,
          appModule.platformDirectory(platform: platform).localizationPackage,
          appModule.platformDirectory(platform: platform).navigationPackage,
          appModule
              .platformDirectory(platform: platform)
              .featuresDirectory
              .appFeaturePackage,
          ...appModule
              .platformDirectory(platform: platform)
              .featuresDirectory
              .featurePackages(),
          uiModule.platformUiPackage(platform: platform),
        ],
      ].where((e) => e.existsSync()).toList();

  List<PlatformRootPackage> rootPackages() => Platform.values
      .where((e) => platformIsActivated(e))
      .map((e) => appModule.platformDirectory(platform: e).rootPackage)
      .toList();

  DartPackage findByPackageName(String packageName) {
    return packages().firstWhere((e) => e.packageName == packageName);
  }

  DartPackage findByCwd() {
    return packages().firstWhere((e) => e.path == Directory.current.path);
  }

  /// Returns all packages that depend on [package].
  ///
  /// This includes packages that have a transitive dependency on [package].
  List<DartPackage> dependentPackages(DartPackage package) {
    return _dependentPackages(packages()
        .where((e) => e.pubSpecFile.hasDependency(name: package.packageName))
        .toList());
  }

  List<DartPackage> _dependentPackages(List<DartPackage> initial) {
    final dependentPackages = packages()
        .without(initial)
        .where(
          (e) => initial.any(
            (i) => e.pubSpecFile.hasDependency(name: i.packageName),
          ),
        )
        .toList();

    if (dependentPackages.isEmpty) {
      return initial;
    } else {
      return _dependentPackages(
        initial + dependentPackages,
      );
    }
  }
}

extension LanguageUtils on Language {
  bool get needsFallback => hasScriptCode || hasCountryCode;

  Language fallback() => Language(languageCode: languageCode);
}

extension PlatformRootPackageUtils on PlatformRootPackage {
  Future<void> registerFeaturePackage(
    PlatformFeaturePackage featurePackage,
  ) async {
    final packageName = featurePackage.packageName;
    pubSpecFile.setDependency(
      name: packageName,
      dependency: HostedReference(VersionConstraint.empty),
    );
    _addFeaturePackage(packageName, injectionFile: injectionFile);
    if (PlatformFeaturePackage is PlatformRoutableFeaturePackage) {
      _addRouterModule(packageName, routerFile: routerFile);
    }
  }

  Future<void> unregisterFeaturePackage(
    PlatformFeaturePackage featurePackage,
  ) async {
    final packageName = featurePackage.packageName;
    pubSpecFile.removeDependency(name: packageName);
    _removeFeaturePackage(packageName, injectionFile: injectionFile);
    if (PlatformFeaturePackage is PlatformRoutableFeaturePackage) {
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
    final imports =
        injectionFile.readImports().where((e) => e.contains(packageName));
    for (final import in imports) {
      injectionFile.removeImport(import);
    }

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

extension IosRootPackageUtils on IosRootPackage {
  void addLanguage(Language language) {
    // TODO edit plist
    nativeDirectory;
  }

  void removeLanguage(Language language) {
    // TODO edit plist
    nativeDirectory;
  }
}

extension MobileRootPackageUtils on MobileRootPackage {
  void addLanguage(Language language) {
    // TODO edit plist
    iosNativeDirectory;
  }

  void removeLanguage(Language language) {
    // TODO edit plist
    iosNativeDirectory;
  }
}

///  class InfoPlistFileImpl extends PlistFileImpl implements InfoPlistFile {
///   InfoPlistFileImpl({
///     required IosNativeDirectory iosNativeDirectory,
///   }) : super(
///           path: p.join(iosNativeDirectory.path, 'Runner'),
///           name: 'Info',
///         );
///
///   @override
///   void addLanguage({required Language language}) {
///     final dict = readDict();
///
///     var languages = ((dict['CFBundleLocalizations'] ?? []) as List)
///         .cast<String>()
///         .map((e) => Language.fromString(e));
///     if (!languages.contains(language)) {
///       dict['CFBundleLocalizations'] = {
///         ...languages,
///         language,
///       }.map((e) => e.toStringWithSeperator('-')).toList();
///     }
///
///     setDict(dict);
///   }
///
///   @override
///   void removeLanguage({required Language language}) {
///     final dict = readDict();
///
///     var languages = ((dict['CFBundleLocalizations'] ?? []) as List)
///         .cast<String>()
///         .map((e) => Language.fromString(e))
///         .toList();
///     if (languages.contains(language)) {
///       dict['CFBundleLocalizations'] = (languages..remove(language))
///           .map((e) => e.toStringWithSeperator('-'))
///           .toList();
///     }
///
///     languages = ((dict['CFBundleLocalizations'] ?? []) as List)
///         .cast<String>()
///         .map((e) => Language.fromString(e))
///         .toList();
///     if (!language.hasScriptCode && !language.hasCountryCode) {
///       dict['CFBundleLocalizations'] = (languages
///             ..removeWhere(
///               (e) => e.languageCode.startsWith(language.languageCode),
///             ))
///           .map((e) => e.toStringWithSeperator('-'))
///           .toList();
///     }
///
///     setDict(dict);
///   }
/// }
///

extension PlatformLocalizationPackageUtils on PlatformLocalizationPackage {
  Set<Language> supportedLanguages() {
    return localizationsFile
        .readTopLevelListVar(name: 'supportedLocales')
        .map((e) => e.toLanguageFromDartLocale())
        .toSet();
  }

  Language defaultLanguage() {
    final templateArbFile = l10nFile.read<String>('template-arb-file');

    return Language.fromString(
      templateArbFile
          .substring(templateArbFile.indexOf('_') + 1) // TODO share ?
          .split('.')
          .first,
    );
  }

  void setDefaultLanguage(Language language) {
    final templateArbFile = l10nFile.read<String>('template-arb-file');
    final newTemplateArbFile = templateArbFile.replaceRange(
      templateArbFile.indexOf('_') + 1,
      templateArbFile.lastIndexOf('.arb'),
      language.toStringWithSeperator(),
    );
    l10nFile.set(['template-arb-file'], newTemplateArbFile);
  }

  void addLanguage(Language language) {
    final existingLanguages = supportedLanguages();

    if (!existingLanguages.contains(language)) {
      // TODO add arb file
    }
  }

  void removeLanguage(Language language) {
    final existingLanguages = supportedLanguages();

    if (existingLanguages.contains(language)) {
      // TODO rm arb file
    }
  }
}

extension DomainDirectoryUtils on DomainDirectory {
  List<DomainPackage> domainPackages() {
    return (existsSync()
        ? listSync().whereType<Directory>().map(
            (e) {
              final basename = p.basename(e.path);
              if (!basename.startsWith('${projectName}_domain_')) {
                return domainPackage(name: null);
              }

              final name =
                  p.basename(e.path).replaceAll('${projectName}_domain_', '');
              return domainPackage(name: name);
            },
          ).toList()
        : [])
      ..sort();
  }
}

extension InfrastructureDirectoryUtils on InfrastructureDirectory {
  List<InfrastructurePackage> infrastructurePackages() {
    return (existsSync()
        ? listSync().whereType<Directory>().map(
            (e) {
              final basename = p.basename(e.path);
              if (!basename.startsWith('${projectName}_infrastructure_')) {
                return infrastructurePackage(name: null);
              }

              final name = p
                  .basename(e.path)
                  .replaceAll('${projectName}_infrastructure_', '');
              return infrastructurePackage(name: name);
            },
          ).toList()
        : [])
      ..sort();
  }
}

extension PlatformFeaturesDirectoryUtils on PlatformFeaturesDirectory {
  List<PlatformFeaturePackage> featurePackages() {
    return (existsSync()
        ? listSync()
            .whereType<Directory>()
            .map((dir) => p.basename(dir.path))
            .where(
              (basename) =>
                  basename.endsWith('page') ||
                  basename.endsWith('flow') ||
                  basename.endsWith('widget'),
            )
            .map(
              (basename) => featurePackage(
                name:
                    basename.replaceAll('${projectName}_${platform.name}_', ''),
              ),
            )
            .toList()
        : [])
      ..sort();
  }
}

extension InfrastructurePackageUtils on InfrastructurePackage {
  bool get isDefault => name == null;
}

extension DartPackageListUtils on List<DartPackage> {
  List<DartPackage> without(List<DartPackage> packages) {
    // TODO maybe override euqalitty in DartPackage
    return this
      ..removeWhere(
        (e) => packages.map((e) => e.packageName).contains(e.packageName),
      );
  }
}

// TODO needed ?
extension on String {
  Language toLanguageFromDartLocale() {
    final self = replaceAll('\r\n', '')
        .replaceAll('\n', '')
        .replaceAll(RegExp(r'\s\s+'), '');
    final RegExpMatch match;
    if (RegExp(r"Locale\('([A-z]+)',?\)").hasMatch(self)) {
      match = RegExp(r"Locale\('([A-z]+)',?\)").firstMatch(self)!;
      return Language(languageCode: match.group(1)!);
    } else if (RegExp(r"Locale\('([A-z]+)', '([A-z]+)',?\)").hasMatch(self)) {
      match = RegExp(r"Locale\('([A-z]+)', '([A-z]+)',?\)").firstMatch(self)!;
      return Language(
          languageCode: match.group(1)!, countryCode: match.group(2)!);
    } else if (RegExp(r"Locale.fromSubtags\(,?\)").hasMatch(self)) {
      match = RegExp(r"Locale.fromSubtags\(,?\)").firstMatch(self)!;
      return Language(languageCode: 'und');
    } else if (RegExp(r"Locale.fromSubtags\(languageCode: '([A-z]+)',?\)")
        .hasMatch(self)) {
      match = RegExp(r"Locale.fromSubtags\(languageCode: '([A-z]+)',?\)")
          .firstMatch(self)!;
      return Language(languageCode: match.group(1)!);
    } else if (RegExp(r"Locale.fromSubtags\(countryCode: '([A-z]+)',?\)")
        .hasMatch(self)) {
      match = RegExp(r"Locale.fromSubtags\(countryCode: '([A-z]+)',?\)")
          .firstMatch(self)!;
      return Language(languageCode: 'und', countryCode: match.group(1)!);
    } else if (RegExp(r"Locale.fromSubtags\(scriptCode: '([A-z]+)',?\)")
        .hasMatch(self)) {
      match = RegExp(r"Locale.fromSubtags\(scriptCode: '([A-z]+)',?\)")
          .firstMatch(self)!;
      return Language(languageCode: 'und', scriptCode: match.group(1)!);
    } else if (RegExp(r"Locale.fromSubtags\(languageCode: '([A-z]+)', countryCode: '([A-z]+)',?\)")
        .hasMatch(self)) {
      match = RegExp(
              r"Locale.fromSubtags\(languageCode: '([A-z]+)', countryCode: '([A-z]+)',?\)")
          .firstMatch(self)!;
      return Language(
          languageCode: match.group(1)!, countryCode: match.group(2)!);
    } else if (RegExp(r"Locale.fromSubtags\(languageCode: '([A-z]+)', scriptCode: '([A-z]+)',?\)")
        .hasMatch(self)) {
      match = RegExp(
              r"Locale.fromSubtags\(languageCode: '([A-z]+)', scriptCode: '([A-z]+)',?\)")
          .firstMatch(self)!;
      return Language(
          languageCode: match.group(1)!, scriptCode: match.group(2)!);
    } else if (RegExp(r"Locale.fromSubtags\(countryCode: '([A-z]+)', languageCode: '([A-z]+)',?\)")
        .hasMatch(self)) {
      match = RegExp(
              r"Locale.fromSubtags\(countryCode: '([A-z]+)', languageCode: '([A-z]+)',?\)")
          .firstMatch(self)!;
      return Language(
          countryCode: match.group(1)!, languageCode: match.group(2)!);
    } else if (RegExp(r"Locale.fromSubtags\(countryCode: '([A-z]+)', scriptCode: '([A-z]+)',?\)")
        .hasMatch(self)) {
      match = RegExp(
              r"Locale.fromSubtags\(countryCode: '([A-z]+)', scriptCode: '([A-z]+)',?\)")
          .firstMatch(self)!;
      return Language(
        languageCode: 'und',
        countryCode: match.group(1)!,
        scriptCode: match.group(2)!,
      );
    } else if (RegExp(r"Locale.fromSubtags\(scriptCode: '([A-z]+)', languageCode: '([A-z]+)',?\)")
        .hasMatch(self)) {
      match = RegExp(
              r"Locale.fromSubtags\(scriptCode: '([A-z]+)', languageCode: '([A-z]+)',?\)")
          .firstMatch(self)!;
      return Language(
          scriptCode: match.group(1)!, languageCode: match.group(2)!);
    } else if (RegExp(r"Locale.fromSubtags\(scriptCode: '([A-z]+)', countryCode: '([A-z]+)',?\)")
        .hasMatch(self)) {
      match = RegExp(
              r"Locale.fromSubtags\(scriptCode: '([A-z]+)', countryCode: '([A-z]+)',?\)")
          .firstMatch(self)!;
      return Language(
        languageCode: 'und',
        scriptCode: match.group(1)!,
        countryCode: match.group(2)!,
      );
    } else if (RegExp(r"Locale.fromSubtags\(languageCode: '([A-z]+)', countryCode: '([A-z]+)', scriptCode: '([A-z]+)',?\)")
        .hasMatch(self)) {
      match = RegExp(
              r"Locale.fromSubtags\(languageCode: '([A-z]+)', countryCode: '([A-z]+)', scriptCode: '([A-z]+)',?\)")
          .firstMatch(self)!;
      return Language(
        languageCode: match.group(1)!,
        countryCode: match.group(2)!,
        scriptCode: match.group(3)!,
      );
    } else if (RegExp(r"Locale.fromSubtags\(languageCode: '([A-z]+)', scriptCode: '([A-z]+)', countryCode: '([A-z]+)',?\)")
        .hasMatch(self)) {
      match = RegExp(
              r"Locale.fromSubtags\(languageCode: '([A-z]+)', scriptCode: '([A-z]+)', countryCode: '([A-z]+)',?\)")
          .firstMatch(self)!;
      return Language(
        languageCode: match.group(1)!,
        scriptCode: match.group(2)!,
        countryCode: match.group(3)!,
      );
    } else if (RegExp(r"Locale.fromSubtags\(countryCode: '([A-z]+)', languageCode: '([A-z]+)', scriptCode: '([A-z]+)',?\)")
        .hasMatch(self)) {
      match = RegExp(
              r"Locale.fromSubtags\(countryCode: '([A-z]+)', languageCode: '([A-z]+)', scriptCode: '([A-z]+)',?\)")
          .firstMatch(self)!;
      return Language(
        countryCode: match.group(1)!,
        languageCode: match.group(2)!,
        scriptCode: match.group(3)!,
      );
    } else if (RegExp(
            r"Locale.fromSubtags\(countryCode: '([A-z]+)', scriptCode: '([A-z]+)', languageCode: '([A-z]+)',?\)")
        .hasMatch(self)) {
      match = RegExp(
              r"Locale.fromSubtags\(countryCode: '([A-z]+)', scriptCode: '([A-z]+)', languageCode: '([A-z]+)',?\)")
          .firstMatch(self)!;
      return Language(
        countryCode: match.group(1)!,
        scriptCode: match.group(2)!,
        languageCode: match.group(3)!,
      );
    } else if (RegExp(
            r"Locale.fromSubtags\(scriptCode: '([A-z]+)', languageCode: '([A-z]+)', countryCode: '([A-z]+)',?\)")
        .hasMatch(self)) {
      match = RegExp(
              r"Locale.fromSubtags\(scriptCode: '([A-z]+)', languageCode: '([A-z]+)', countryCode: '([A-z]+)',?\)")
          .firstMatch(self)!;
      return Language(
        scriptCode: match.group(1)!,
        languageCode: match.group(2)!,
        countryCode: match.group(3)!,
      );
    } else if (RegExp(
            r"Locale.fromSubtags\(scriptCode: '([A-z]+)', countryCode: '([A-z]+)', languageCode: '([A-z]+)',?\)")
        .hasMatch(self)) {
      match = RegExp(
              r"Locale.fromSubtags\(scriptCode: '([A-z]+)', countryCode: '([A-z]+)', languageCode: '([A-z]+)',?\)")
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
