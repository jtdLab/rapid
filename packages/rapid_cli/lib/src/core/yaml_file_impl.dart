import 'package:yaml/yaml.dart';
import 'package:yaml_edit/yaml_edit.dart';

import 'file_impl.dart';
import 'yaml_file.dart';

class YamlFileImpl extends FileImpl implements YamlFile {
  YamlFileImpl({
    super.path,
    required String super.name,
  }) : super(extension: 'yaml');

  @override
  T readValue<T extends Object?>(Iterable<Object?> path) {
    // TODO take single object instead of list
    assert(path.length == 1);

    final contents = read();

    final yaml = loadYaml(contents);
    return yaml[path.first];
  }

  @override
  void removeValue(Iterable<Object?> path) {
    final contents = read();

    try {
      final editor = YamlEditor(contents);
      editor.remove(path);
      // TODO in nested paths the removing leads to a empty set "{}" instead of blank field
      final output = editor.toString();

      write(output);
    } catch (_) {}
  }

  @override
  void setValue<T extends Object?>(
    Iterable<Object?> path,
    T? value, {
    bool blankIfValueNull = false,
  }) {
    final contents = read();

    final editor = YamlEditor(contents);
    editor.update(path, value);
    var output = editor.toString();
    if (value == null && blankIfValueNull) {
      final replacement = editor.edits.first.replacement;
      output =
          output.replaceAll(replacement, replacement.replaceAll(' null', ''));
    }

    write(output);
  }
}
