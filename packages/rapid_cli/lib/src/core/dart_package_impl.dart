import 'package:rapid_cli/src/core/dart_package.dart';
import 'package:yaml/yaml.dart';

import 'directory_impl.dart';
import 'yaml_file_impl.dart';

class DartPackageImpl extends DirectoryImpl implements DartPackage {
  DartPackageImpl({
    super.path,
    PubspecFile? pubspecFile,
  });

  @override
  PubspecFile? pubspecFileOverrides;

  @override
  PubspecFile get pubspecFile =>
      pubspecFileOverrides ?? PubspecFile(path: path);

  @override
  String packageName() => pubspecFile.readName();
}

class PubspecFileImpl extends YamlFileImpl implements PubspecFile {
  PubspecFileImpl({super.path}) : super(name: 'pubspec');

  @override
  String readName() {
    try {
      return readValue(['name']);
    } catch (_) {
      throw ReadNameFailure();
    }
  }

  @override
  bool hasDependency(String name) {
    final dependencies = readValue(['dependencies']) as YamlMap;

    return dependencies.entries
        .map((e) => (e.key as String).split(':').first.trim())
        .contains(name);
  }

  @override
  void removeDependency(String name) => removeValue(['dependencies', name]);

  @override
  void removeDependencyByPattern(String pattern) {
    final dependencies = readValue(['dependencies']) as YamlMap;

    for (final dependency in dependencies.entries
        .map((e) => (e.key as String).split(':').first.trim())
        .where((e) => e.contains(pattern))) {
      removeDependency(dependency);
    }
  }

  @override
  void setDependency(String name, {String? version, bool dev = false}) =>
      setValue(
        [dev ? 'dev_dependencies' : 'dependencies', name],
        version,
        blankIfValueNull: true,
      );
}
