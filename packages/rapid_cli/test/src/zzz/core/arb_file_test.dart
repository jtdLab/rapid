import 'dart:io';

import 'package:rapid_cli/src/core/arb_file.dart';
import 'package:test/test.dart';

import '../../common.dart';

const emptyArbFile = '{}';

const arbFileWithString = '''{
  "key": "value"
}''';

const arbFileWithUpdatedString = '''{
  "key": "updatedValue"
}''';

const arbFileWithMap = '''{
  "key": {
    "mapKey": "mapValue"
  }
}''';

const arbFileWithUpdatedMap = '''{
  "key": {
    "upatedMapKey": "updatedMapValue"
  }
}''';

ArbFile _getArbFile({
  String? path,
  String? name,
}) {
  return ArbFile(
    path: path ?? 'some/path',
    name: name ?? 'some',
  );
}

void main() {
  group('ArbFile', () {
    test('.path', () {
      // Arrange
      final arbFile = _getArbFile(path: 'arb_file/path', name: 'foo');

      // Act + Assert
      expect(arbFile.path, 'arb_file/path/foo.arb');
    });

    group('setValue', () {
      test(
        'sets value correctly key does not exist',
        withTempDir(() {
          // Arrange
          final arbFile = _getArbFile();
          final file = File(arbFile.path)
            ..createSync(recursive: true)
            ..writeAsStringSync(emptyArbFile);

          // Act
          arbFile.setValue(['key'], 'value');

          // Assert
          expect(file.readAsStringSync(), arbFileWithString);
        }),
      );

      test(
        'sets a string correctly',
        withTempDir(() {
          // Arrange
          final arbFile = _getArbFile();
          final file = File(arbFile.path)
            ..createSync(recursive: true)
            ..writeAsStringSync(arbFileWithString);

          // Act
          arbFile.setValue(['key'], 'updatedValue');

          // Assert
          expect(file.readAsStringSync(), arbFileWithUpdatedString);
        }),
      );

      test(
        'sets a map correctly',
        withTempDir(() {
          // Arrange
          final arbFile = _getArbFile();
          final file = File(arbFile.path)
            ..createSync(recursive: true)
            ..writeAsStringSync(arbFileWithMap);

          // Act
          arbFile.setValue(['key'], {'upatedMapKey': 'updatedMapValue'});

          // Assert
          expect(file.readAsStringSync(), arbFileWithUpdatedMap);
        }),
      );

      test('throws AssertionError when depth is 0', () {
        // Arrange
        final arbFile = _getArbFile();

        // Act + Assert
        expect(
          () => arbFile.setValue([], 1),
          throwsA(isA<AssertionError>()),
        );
      });

      test('throws AssertionError when depth larger than 1', () {
        // Arrange
        final arbFile = _getArbFile();

        // Act + Assert
        expect(
          () => arbFile.setValue(['a', 'b'], 1),
          throwsA(isA<AssertionError>()),
        );
      });
    });

    group('.exists()', () {
      test(
        'returns true when underlying file exists',
        withTempDir(() {
          // Arrange
          final arbFile = _getArbFile();
          File(arbFile.path).createSync(recursive: true);

          // Act + Assert
          expect(arbFile.exists(), true);
        }),
      );

      test(
        'returns false when underlying file does not exist',
        withTempDir(() {
          // Arrange
          final arbFile = _getArbFile();

          // Act + Assert
          expect(arbFile.exists(), false);
        }),
      );
    });

    group('.delete()', () {
      test(
        'deletes the file',
        withTempDir(() {
          // Arrange
          final arbFile = _getArbFile();
          final file = File(arbFile.path)..createSync(recursive: true);

          // Act
          arbFile.delete();

          // Assert
          expect(file.existsSync(), false);
        }),
      );
    });
  });
}
