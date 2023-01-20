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
        path = p.join(
          project.path,
          'packages',
          project.name(),
          '${project.name()}_di',
        ),
        flutterPubRunBuildRunnerBuildDeleteConflictingOutputs =
            flutterPubRunBuildRunnerBuildDeleteConflictingOutputs ??
                Flutter.pubRunBuildRunnerBuildDeleteConflictingOutputs {
    _injectionFile = injectionFile ?? InjectionFile(diPackage: this);
  }

  final Project _project;
  late final InjectionFile _injectionFile;
  final GeneratorBuilder _generator;

  @override
  final String path;

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

  Future<void> registerFeaturePackage(
    PlatformCustomFeaturePackage featurePackage, {
    required Logger logger,
  }) async {
    final packageName = featurePackage.name;
    _injectionFile.addPackage(packageName);
    await rebuild(logger: logger);
  }

  Future<void> unregisterFeaturePackage(
    PlatformCustomFeaturePackage featurePackage, {
    required Logger logger,
  }) async {
    final packageName = featurePackage.name;
    final packagePlatform = featurePackage.platform;
    _injectionFile.removePackage(packageName, packagePlatform);
    await rebuild(logger: logger);
  }

  Future<void> unregisterFeaturePackagesByPlatform(
    Platform platform, {
    required Logger logger,
  }) async {
    _injectionFile.removePackagesByPlatform(platform);
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
  })  : _diPackage = diPackage,
        _dartFile = DartFile(
            path: p.join(diPackage.path, 'lib', 'src'), name: 'injection') {
    path = _dartFile.path;
  }

  final DiPackage _diPackage;
  final DartFile _dartFile;

  @override
  late final String path;

  @override
  bool exists() => _dartFile.exists();

  List<String> _readExternalPackageModules() =>
      _dartFile.readTypeListFromAnnotationParamOfTopLevelFunction(
        property: 'externalPackageModules',
        annotation: 'InjectableInit',
        functionName: 'configureDependencies',
      );

  /// Adds [package] to this file.
  void addPackage(String package) {
    _dartFile.addImport('package:$package/$package.dart');

    final existingExternalPackageModules = _readExternalPackageModules();

    _dartFile.setTypeListOfAnnotationParamOfTopLevelFunction(
      property: 'externalPackageModules',
      annotation: 'InjectableInit',
      functionName: 'configureDependencies',
      value: {
        ...existingExternalPackageModules,
        '${package.pascalCase}PackageModule',
      }.toList(),
    );
  }

  /// Removes the package with [name] available on [platform].
  void removePackage(String name, Platform platform) {
    final projectName = _diPackage._project.name();
    final platformName = platform.name;

    final import = _dartFile
        .readImports()
        .firstWhere((e) => e.contains('${projectName}_${platformName}_$name'));
    _dartFile.removeImport(import);

    final existingExternalPackageModules = _readExternalPackageModules();

    _dartFile.setTypeListOfAnnotationParamOfTopLevelFunction(
      property: 'externalPackageModules',
      annotation: 'InjectableInit',
      functionName: 'configureDependencies',
      value: existingExternalPackageModules
          .where(
            (e) => !e.contains(
              '${projectName.pascalCase}${platformName.pascalCase}${name.pascalCase}',
            ),
          )
          .toList(),
    );
  }

  // TODO test

  /// Removes all packages with [platform].
  void removePackagesByPlatform(Platform platform) {
    final projectName = _diPackage._project.name();
    final platformName = platform.name;

    final imports = _dartFile
        .readImports()
        .where((e) => e.contains('${projectName}_$platformName'));
    for (final import in imports) {
      _dartFile.removeImport(import);
    }

    final existingExternalPackageModules = _readExternalPackageModules();

    _dartFile.setTypeListOfAnnotationParamOfTopLevelFunction(
      property: 'externalPackageModules',
      annotation: 'InjectableInit',
      functionName: 'configureDependencies',
      value: existingExternalPackageModules
          .where(
            (e) => !e.contains(
              '${projectName.pascalCase}${platformName.pascalCase}',
            ),
          )
          .toList(),
    );
  }
}
