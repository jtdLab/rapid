import 'dart:io';

import 'package:path/path.dart' as p;

Future<ProcessResult> run(
  String executable,
  List<String> arguments, {
  String? workingDirectory,
}) {
  return Process.run(
    executable,
    arguments,
    workingDirectory: workingDirectory,
    runInShell: true,
  );
}

Directory getTempDir([String? name]) {
  final tempDir = Directory.systemTemp.createTempSync();
  return Directory(p.join(tempDir.path, name ?? ''));
}
