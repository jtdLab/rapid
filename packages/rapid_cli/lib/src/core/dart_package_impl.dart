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
  void removeDependency(String name) => removeValue(['dependencies', name]);

  @override
  void removeDependencyByPattern(String pattern) {
    final dependencies = readValue(['dependencies']);

    for (final dependency in (dependencies as YamlMap)
        .entries
        .map((e) => (e.key as String).split(':').first.trim())
        .where((e) => e.contains(pattern))) {
      removeDependency(dependency);
    }
  }

  @override
  void setDependency(String name, {String? version}) =>
      setValue(['dependencies', name], version, blankIfValueNull: true);
}
