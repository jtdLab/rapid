import 'package:path/path.dart' as p;
import 'package:rapid_cli/src/core/dart_package.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/project/project.dart';
import 'package:universal_io/io.dart';

class FeatureNotFound implements Exception {}

/// {@template platform_directory}
/// Abstraction of the directory that contains the features of a given platform
/// {@endtemplate}
class PlatformDirectory {
  /// {@macro platform_directory}
  PlatformDirectory({
    required Platform platform,
    required Project project,
  })  : _platform = platform,
        _project = project,
        _directory = Directory(
          p.join(
            'packages',
            project.melosFile.name(),
            '${project.melosFile.name()}_${platform.name}',
          ),
        );

  final Directory _directory;

  final Project _project;
  final Platform _platform;

  void delete() => _directory.deleteSync();

  bool exists() => _directory.existsSync();

  /// Wheter the feature with [name] exists.
  bool featureExists(String name) {
    final projectName = _project.melosFile.name();
    final packageName = '${projectName}_${_platform.name}_$name';
    final package = DartPackage(path: p.join(path, packageName));

    return package.exists();
  }

  /// Returns the feature with [name] on [platform].
  DartPackage findFeature(String name) {
    final projectName = _project.melosFile.name();
    final packageName = '${projectName}_${_platform.name}_$name';
    final package = DartPackage(path: p.join(path, packageName));

    if (package.exists()) {
      return package;
    }

    throw FeatureNotFound();
  }

  String get path => _directory.path;
}
