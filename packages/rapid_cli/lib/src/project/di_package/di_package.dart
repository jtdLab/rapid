import 'package:mason/mason.dart';
import 'package:path/path.dart' as p;
import 'package:rapid_cli/src/core/dart_file.dart';
import 'package:rapid_cli/src/core/dart_package.dart';
import 'package:rapid_cli/src/core/generator_builder.dart';
import 'package:rapid_cli/src/project/platform_directory/platform_feature_package/platform_feature_package.dart';
import 'package:rapid_cli/src/project/project.dart';
import 'package:universal_io/io.dart';

import 'di_package_bundle.dart';

/// {@template di_package}
/// Abstraction of the di package of a Rapid project.
///
/// Location: `packages/<project name>/<project name>_di`
/// {@endtemplate}
class DiPackage extends DartPackage {
  /// {@macro di_package}
  DiPackage({
    required Project project,
    super.pubspecFile,
    InjectionFile? injectionFile,
    GeneratorBuilder? generator,
  })  : _project = project,
        _generator = generator ?? MasonGenerator.fromBundle,
        super(
          path: p.join(
            project.path,
            'packages',
            project.name(),
            '${project.name()}_di',
          ),
        ) {
    _injectionFile = injectionFile ?? InjectionFile(diPackage: this);
  }

  final Project _project;
  late final InjectionFile _injectionFile;
  final GeneratorBuilder _generator;

  Future<void> create({
    required bool android,
    required bool ios,
    required bool linux,
    required bool macos,
    required bool web,
    required bool windows,
    required Logger logger,
  }) async {
    final projectName = _project.name();

    final generator = await _generator(diPackageBundle);
    await generator.generate(
      DirectoryGeneratorTarget(Directory(path)),
      vars: <String, dynamic>{
        'project_name': projectName,
        'android': android,
        'ios': ios,
        'linux': linux,
        'macos': macos,
        'web': web,
        'windows': windows,
      },
      logger: logger,
    );
  }

  Future<void> registerCustomFeaturePackage(
    PlatformCustomFeaturePackage customFeaturePackage, {
    required Logger logger,
  }) async {
    pubspecFile.setDependency(customFeaturePackage.packageName());
    _injectionFile.addCustomFeaturePackage(customFeaturePackage);
  }

  Future<void> unregisterCustomFeaturePackages(
    Iterable<PlatformCustomFeaturePackage> customFeaturePackages, {
    required Logger logger,
  }) async {
    for (final customFeaturePackage in customFeaturePackages) {
      pubspecFile.removeDependency(customFeaturePackage.packageName());
      _injectionFile.removeCustomFeaturePackage(customFeaturePackage);
    }
  }
}

/// {@template injection_file}
/// Abstraction of the injection file in the di package of a Rapid project.
///
/// Location: `packages/<project name>/<project name>_di/lib/src/injection.dart`
/// {@endtemplate}
class InjectionFile extends DartFile {
  /// {@macro injection_file}
  InjectionFile({
    required DiPackage diPackage,
  }) : super(
          path: p.join(diPackage.path, 'lib', 'src'),
          name: 'injection',
        );

  List<String> _readExternalPackageModules() =>
      readTypeListFromAnnotationParamOfTopLevelFunction(
        property: 'externalPackageModules',
        annotation: 'InjectableInit',
        functionName: 'configureDependencies',
      );

  /// Adds [customFeaturePackage] to this file.
  void addCustomFeaturePackage(
    PlatformCustomFeaturePackage customFeaturePackage,
  ) {
    final packageName = customFeaturePackage.packageName();

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

  /// Removes [customFeaturePackage] from this file.
  void removeCustomFeaturePackage(
    PlatformCustomFeaturePackage customFeaturePackage,
  ) {
    final packageName = customFeaturePackage.packageName();

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
}
