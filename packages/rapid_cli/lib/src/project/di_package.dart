import 'package:path/path.dart' as p;
import 'package:rapid_cli/src/core/dart_file.dart';
import 'package:rapid_cli/src/core/dart_package.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/project/project.dart';
import 'package:recase/recase.dart';

/// {@template di_package}
/// Abstraction of the di package of a Rapid project.
/// {@endtemplate}
class DiPackage {
  /// {@macro di_package}
  DiPackage({required this.project})
      : _package = DartPackage(
          path: p.join('packages', project.melosFile.name(),
              '${project.melosFile.name()}_di'),
        );

  final DartPackage _package;

  final Project project;

  late final InjectionFile injectionFile = InjectionFile(diPackage: this);

  String get path => _package.path;

  late final PubspecFile pubspecFile = PubspecFile(path: path);
}

/// {@template injection_file}
/// Abstraction of the injection file in the di package of a Rapid project.
/// {@endtemplate}
class InjectionFile {
  /// {@macro injection_file}
  InjectionFile({
    required this.diPackage,
  }) : _file = DartFile(
            path: p.join(diPackage.path, 'lib', 'src'), name: 'injection');

  final DartFile _file;

  final DiPackage diPackage;

  String get path => _file.path;

  List<String> _readExternalPackageModules() =>
      _file.readTypeListFromAnnotationParamOfTopLevelFunction(
        property: 'externalPackageModules',
        annotation: 'InjectableInit',
        functionName: 'configureDependencies',
      );

  /// Adds [package] to this file.
  void addPackage(String package) {
    _file.addImport('package:$package/$package.dart');

    final existingExternalPackageModules = _readExternalPackageModules();

    _file.setTypeListOfAnnotationParamOfTopLevelFunction(
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
    final projectName = diPackage.project.melosFile.name();
    final platformName = platform.name;

    final import = _file
        .readImports()
        .firstWhere((e) => e.contains('${projectName}_${platformName}_$name'));
    _file.removeImport(import);

    final existingExternalPackageModules = _readExternalPackageModules();

    _file.setTypeListOfAnnotationParamOfTopLevelFunction(
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
    final projectName = diPackage.project.melosFile.name();
    final platformName = platform.name;

    final imports = _file
        .readImports()
        .where((e) => e.contains('${projectName}_$platformName'));
    for (final import in imports) {
      _file.removeImport(import);
    }

    final existingExternalPackageModules = _readExternalPackageModules();

    _file.setTypeListOfAnnotationParamOfTopLevelFunction(
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
