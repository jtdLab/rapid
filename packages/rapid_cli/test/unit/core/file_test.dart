// TODO this file exists only for coverage reasons and should not be needed in final release

import 'package:rapid_cli/src/core/directory.dart';
import 'package:rapid_cli/src/core/file.dart';
import 'package:test/test.dart';

File _getFile({
  String path = '.',
  String? name,
  String? extension,
}) {
  return File(
    path: path,
    name: name ?? 'foo',
    extension: extension,
  );
}

void main() {
  group('File', () {
    test('.parent', () {
      // Arrange
      final file = _getFile(path: 'parent');

      // Assert
      expect(
        file.parent,
        isA<Directory>().having(
          (directory) => directory.path,
          'path',
          'parent',
        ),
      );
    });
  });
}
