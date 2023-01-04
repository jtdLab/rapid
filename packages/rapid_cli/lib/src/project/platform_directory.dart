import 'package:path/path.dart' as p;
import 'package:rapid_cli/src/core/dart_package.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/project/feature.dart';
import 'package:rapid_cli/src/project/project.dart';
import 'package:universal_io/io.dart';

// TODO the abstraction level here is other than in rest of project/filesystem maybe make all of em like this or this like all of em

class FeatureNotFound implements Exception {}

/// {@template platform_directory}
/// Abstraction of the directory that contains the features of a given platform
/// {@endtemplate}
class PlatformDirectory {
  /// {@macro platform_directory}
  PlatformDirectory({
    required this.platform,
    required this.project,
  }) : _directory = Directory(
          p.join(
            'packages',
            project.melosFile.name(),
            '${project.melosFile.name()}_${platform.name}',
          ),
        );

  final Directory _directory;

  void delete() => _directory.deleteSync(recursive: true);

  bool exists() => _directory.existsSync();

  /// Wheter the feature with [name] exists.
  bool featureExists(String name) {
    final projectName = project.melosFile.name();
    final packageName = '${projectName}_${platform.name}_$name';
    final package = DartPackage(path: p.join(path, packageName));

    return package.exists();
  }

  /// Returns the feature with [name] on [platform].
  Feature findFeature(String name) {
    final feature = Feature(name: name, platformDirectory: this);

    if (feature.exists()) {
      return feature;
    }

    throw FeatureNotFound();
  }

  /// Returns all features inside this except [exclude].
  List<Feature> getFeatures({Set<String> exclude = const {}}) {
    final projectName = project.melosFile.name();

    String packageName(String path) {
      return p
          .basename(path)
          .replaceFirst('${projectName}_${platform.name}_', '');
    }

    final features = _directory
        .listSync()
        .whereType<Directory>()
        .map((e) => packageName(e.path))
        .where((e) => !exclude.contains(e))
        .map((e) => Feature(name: e, platformDirectory: this))
        .toList();

    return features;
  }

  String get path => _directory.path;

  final Platform platform;

  final Project project;
}
