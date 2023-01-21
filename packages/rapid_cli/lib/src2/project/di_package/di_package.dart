import 'package:mason/mason.dart';
import 'package:path/path.dart' as p;
import 'package:rapid_cli/src2/cli/cli.dart';
import 'package:rapid_cli/src2/core/dart_file.dart';
import 'package:rapid_cli/src2/core/generator_builder.dart';
import 'package:rapid_cli/src2/core/platform.dart';
import 'package:rapid_cli/src2/project/platform_directory/platform_feature_package/platform_feature_package.dart';
import 'package:rapid_cli/src2/project/project.dart';
import 'package:recase/recase.dart';
import 'package:universal_io/io.dart';

import 'di_package_bundle.dart';

/// {@template di_package}
/// Abstraction of the di package of a Rapid project.
///
/// Location: `packages/<project name>/<project name>_di`
/// {@endtemplate}
class DiPackage extends ProjectPackage with RebuildMixin {
  /// {@macro di_package}
  DiPackage({
    required Project project,
    InjectionFile? injectionFile,
    FlutterPubRunBuildRunnerBuildDeleteConflictingOutputsCommand?
        flutterPubRunBuildRunnerBuildDeleteConflictingOutputs,
    GeneratorBuilder? generator,
  })  : _project = project,
        _generator = generator ?? MasonGenerator.fromBundle,
        flutterPubRunBuildRunnerBuildDeleteConflictingOutputs =
            flutterPubRunBuildRunnerBuildDeleteConflictingOutputs ??
                Flutter.pubRunBuildRunnerBuildDeleteConflictingOutputs {
    _injectionFile = injectionFile ?? InjectionFile(diPackage: this);
  }

  final Project _project;
  late final InjectionFile _injectionFile;
  final GeneratorBuilder _generator;

  @override
  String get path => p.join(
        _project.path,
        'packages',
        _project.name(),
        '${_project.name()}_di',
      );

  @override
  final FlutterPubRunBuildRunnerBuildDeleteConflictingOutputsCommand
      flutterPubRunBuildRunnerBuildDeleteConflictingOutputs;

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
    await rebuild(logger: logger);
  }

  Future<void> unregisterCustomFeaturePackage(
    PlatformCustomFeaturePackage customFeaturePackage, {
    required Logger logger,
  }) async {
    pubspecFile.removeDependency(customFeaturePackage.packageName());
    _injectionFile.removeCustomFeaturePackage(customFeaturePackage);
    await rebuild(logger: logger);
  }
}

/// {@template injection_file}
/// Abstraction of the injection file in the di package of a Rapid project.
///
/// Location: `packages/<project name>/<project name>_di/lib/src/injection.dart`
/// {@endtemplate}
class InjectionFile extends ProjectEntity {
  /// {@macro injection_file}
  InjectionFile({
    required DiPackage diPackage,
  }) : _diPackage = diPackage;

  final DiPackage _diPackage;

  DartFile get _dartFile => DartFile(
        path: p.join(_diPackage.path, 'lib', 'src'),
        name: 'injection',
      );

  @override
  String get path => _dartFile.path;

  @override
  bool exists() => _dartFile.exists();

  List<String> _readExternalPackageModules() =>
      _dartFile.readTypeListFromAnnotationParamOfTopLevelFunction(
        property: 'externalPackageModules',
        annotation: 'InjectableInit',
        functionName: 'configureDependencies',
      );

  /// Adds [customFeaturePackage] to this file.
  void addCustomFeaturePackage(
    PlatformCustomFeaturePackage customFeaturePackage,
  ) {
    final packageName = customFeaturePackage.packageName();

    _dartFile.addImport('package:$packageName/$packageName.dart');

    final existingExternalPackageModules = _readExternalPackageModules();

    _dartFile.setTypeListOfAnnotationParamOfTopLevelFunction(
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

    final imports =
        _dartFile.readImports().where((e) => e.contains(packageName));
    for (final import in imports) {
      _dartFile.removeImport(import);
    }

    final existingExternalPackageModules = _readExternalPackageModules();

    _dartFile.setTypeListOfAnnotationParamOfTopLevelFunction(
      property: 'externalPackageModules',
      annotation: 'InjectableInit',
      functionName: 'configureDependencies',
      value: existingExternalPackageModules
          .where((e) => !e.contains(packageName.pascalCase))
          .toList(),
    );
  }
}
