import 'dart:convert';

import 'arb_file.dart';
import 'file_impl.dart';

class ArbFileImpl extends FileImpl implements ArbFile {
  ArbFileImpl({
    super.path,
    required String super.name,
  }) : super(extension: 'arb');

  @override
  void setValue<T extends Object?>(Iterable<String> path, T? value) {
    assert(path.length == 1);

    final contents = read();

    final json = jsonDecode(contents);
    json[path.first] = value;

    final output = JsonEncoder.withIndent('  ').convert(json);
    write(output);
  }
}
