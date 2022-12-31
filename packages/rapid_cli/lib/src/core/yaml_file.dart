import 'package:path/path.dart' as p;
import 'package:universal_io/io.dart';
import 'package:yaml/yaml.dart';
import 'package:yaml_edit/yaml_edit.dart';

/// Thrown when [YamlFile.readValue] is called with empty [path].
class YamlPathEmpty implements Exception {}

/// Thrown when [YamlFile.readValue] is called with [path] having a length larger than 4.
class YamlPathToDeep implements Exception {}

/// Thrown when [YamlFile.readValue] is called with [path] that does not reference a value.
class ValueNotFound implements Exception {}

/// {@template yaml_file}
/// Abstraction of a yaml file.
/// {@endtemplate}
class YamlFile {
  /// {@macro yaml_file}
  YamlFile({
    String path = '.',
    required String name,
  }) : _file = File(p.normalize(p.join(path, '$name.yaml')));

  /// The underlying file
  final File _file;

  /// Reads the contents of the underlying file.
  String _read() => _file.readAsStringSync();

  /// Writes [contents] to the underlying file.
  void _write(String contents) =>
      _file.writeAsStringSync(contents, flush: true);

  String get path => _file.path;

  /// Reads the value at [path].
  T readValue<T extends Object?>(Iterable<Object?> path) {
    try {
      if (path.isEmpty) {
        throw YamlPathEmpty();
      }

      final yaml = loadYaml(_read());
      if (path.length == 1) {
        return yaml[path.first];
      } else if (path.length == 2) {
        return yaml[path.first][path.last];
      } else if (path.length == 3) {
        return yaml[path.first][path.elementAt(1)][path.last];
      } else if (path.length == 4) {
        return yaml[path.first][path.elementAt(1)][path.elementAt(2)]
            [path.last];
      } else {
        throw YamlPathToDeep();
      }
    } catch (e) {
      if (e is YamlPathEmpty) rethrow;
      if (e is YamlPathToDeep) rethrow;
      throw ValueNotFound();
    }
  }

  /// Removes the value at [path].
  void removeValue(Iterable<Object?> path) {
    final contents = _read();

    final editor = YamlEditor(contents);
    editor.remove(path);
    final output = editor.toString();

    _write(output);
  }

  /// Sets [value] at [path].
  ///
  /// If [value] is `null` the output differs depending on [blankIfValueNull].
  ///
  /// a) [blankIfValueNull] = false
  /// ```yaml
  /// my_value: null
  /// ```
  /// b) [blankIfValueNull] = true
  /// ```yaml
  /// my_value:
  /// ```
  void setValue<T extends Object?>(
    Iterable<Object?> path,
    T? value, {
    bool blankIfValueNull = false,
  }) {
    final contents = _read();

    final editor = YamlEditor(contents);
    editor.update(path, value);
    var output = editor.toString();
    if (blankIfValueNull) {
      final replacement = editor.edits.first.replacement;
      output =
          output.replaceAll(replacement, replacement.replaceAll(': null', ':'));
    }

    _write(output);
  }
}