import 'package:dart_style/dart_style.dart';
import 'package:recase/recase.dart';

import 'platform.dart';
import 'project_file.dart';
import 'project_package.dart';

/// {@template di_package}
/// Abstraction of the `packages/<NAME>/<NAME>_di` package in a Rapid project.
/// {@endtemplate}
class DiPackage extends ProjectPackage {
  /// {@macro di_package}
  DiPackage({
    required super.project,
  }) : super('packages/${project.melosFile.name}/${project.melosFile.name}_di');

  InjectionFile get injectionFile => InjectionFile(diPackage: this);
}

// TODO remove comments in external module templates

/// {@template di_package_injection_file}
/// Abstraction of the `lib/src/injection.dart` file in a the di package of a Rapid project.
/// {@endtemplate}
class InjectionFile extends ProjectFile with DartFile {
  /// {@macro di_package_injection_file}
  InjectionFile({
    required this.diPackage,
  }) : super('${diPackage.path}/lib/src/injection.dart');

  final DiPackage diPackage;

  /// Returns the names of all rapid packages registered under [platform].
  List<String> getPackagesByPlatform(Platform platform) {
    final projectName = diPackage.project.melosFile.name;
    final platformName = platform.name;
    final regExp = RegExp(
      'import \'package:(${projectName}_${platformName}_[a-z_]*)/${projectName}_${platformName}_[a-z_]*.dart\';',
    );

    final output = <String>[];
    final content = file.readAsStringSync();
    final matches = regExp.allMatches(content);
    for (final match in matches) {
      output.add(match.group(1)!);
    }

    return output;
  }

  /// Adds all code required for dependency injection for package with [packageName].
  void addPackage(String packageName) {
    final existingImports = getImports();
    if (existingImports.contains('package:$packageName/$packageName.dart')) {
      // TODO add check for presence of external package module
      return;
    }

    addImport('package:$packageName/$packageName.dart', null);

    // TODO add external module
    final content = file.readAsStringSync();

    final extModIndex = content.indexOf('externalPackageModules:');
    final openingCornerBraceIndex = content.indexOf('[', extModIndex);
    final closingCornerBraceIndex =
        content.indexOf(']', openingCornerBraceIndex);

    final modulesString =
        content.substring(openingCornerBraceIndex + 1, closingCornerBraceIndex);
    modulesString.replaceAll('\n', '');
    final modules = modulesString.split(',');
    modules.removeWhere((string) => string.trim().isEmpty);

    final newModule = '${packageName.pascalCase}PackageModule';
    final newModules = [
      ...modules.map((e) => e.trim()),
      newModule,
    ];
    newModules.sort();

    final output = DartFormatter().format(
      content.replaceRange(
        openingCornerBraceIndex + 1,
        closingCornerBraceIndex,
        newModules.join(','),
      ),
    );

    file.writeAsStringSync(output);
  }

  /// Removes all code required for dependency injection for package with [packageName].
  void removePackage(String packageName) {
    final importRegExp = RegExp(
      'import \'package:$packageName/$packageName.dart\';',
    );
    final externalPackageModuleRegExp =
        RegExp('${packageName.pascalCase}PackageModule');

    final lines = file.readAsLinesSync();
    lines.removeWhere(
      (line) =>
          importRegExp.hasMatch(line) ||
          externalPackageModuleRegExp.hasMatch(line),
    );
    lines.add('');

    file.writeAsStringSync(lines.join('\n'));
  }
}
