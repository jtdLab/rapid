import 'package:path/path.dart' as p;
import 'package:rapid_cli/src/core/dart_file.dart';
import 'package:rapid_cli/src/core/dart_package.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/project/project.dart';

/// {@template di_package}
/// Abstraction of the di package of a Rapid project.
/// {@endtemplate}
class DiPackage {
  /// {@macro di_package}
  DiPackage({required Project project})
      : _package = DartPackage(
          path: p.join('packages', project.melosFile.name(),
              '${project.melosFile.name()}_di'),
        );

  final DartPackage _package;

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
    required DiPackage diPackage,
  }) : _file = DartFile(
            path: p.join(diPackage.path, 'lib', 'src'), name: 'injection');

  final DartFile _file;

  String get path => _file.path;

  /// Adds [package] to this file.
  void addPackage(String package) {
    // TODO: impl
    throw UnimplementedError();
  }

  /// Removes all packages with [platform].
  void removePlatform(Platform platform) {
    // TODO: impl
    throw UnimplementedError();
  }
}
