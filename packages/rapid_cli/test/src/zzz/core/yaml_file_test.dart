import 'dart:io';

import 'package:rapid_cli/src/core/yaml_file.dart';
import 'package:test/test.dart';

import '../../common.dart';

const yamlFileWithBlankValue = '''
a:
''';

const yamlFileWithValuesDepth4 = '''
a: 1
b:
  c: 2
d:
  e:
    f: 3
g:
  h:
    i:
      j: 4
''';

const yamlFileWithValuesDepth5 = '''
a: 1
b:
  c: 2
d:
  e:
    f: 3
g:
  h:
    i:
      j: 4
k:
  l:
    m:
      n:
        o: 5
''';

const yamlFileWithUpdatedDepth1Value = '''
a: 8
b:
  c: 2
d:
  e:
    f: 3
g:
  h:
    i:
      j: 4
k:
  l:
    m:
      n:
        o: 5
''';

const yamlFileWithUpdatedDepth3Value = '''
a: 1
b:
  c: 2
d:
  e:
    f: 888
g:
  h:
    i:
      j: 4
k:
  l:
    m:
      n:
        o: 5
''';

const yamlFileWithNullDepth1Value = '''
a: null
b:
  c: 2
d:
  e:
    f: 3
g:
  h:
    i:
      j: 4
k:
  l:
    m:
      n:
        o: 5
''';

const yamlFileWithNullDepth3Value = '''
a: 1
b:
  c: 2
d:
  e:
    f: null
g:
  h:
    i:
      j: 4
k:
  l:
    m:
      n:
        o: 5
''';

const yamlFileWithBlankDepth1Value = '''
a:
b:
  c: 2
d:
  e:
    f: 3
g:
  h:
    i:
      j: 4
k:
  l:
    m:
      n:
        o: 5
''';

const yamlFileWithBlankDepth3Value = '''
a: 1
b:
  c: 2
d:
  e:
    f:
g:
  h:
    i:
      j: 4
k:
  l:
    m:
      n:
        o: 5
''';

YamlFile _getYamlFile({
  String? path,
  String? name,
}) {
  return YamlFile(
    path: path ?? 'some/path',
    name: name ?? 'some',
  );
}

void main() {
  group('YamlFile', () {
    test('.path', () {
      // Arrange
      final yamlFile = _getYamlFile(path: 'yaml_file/path', name: 'foo');

      // Assert
      expect(yamlFile.path, 'yaml_file/path/foo.yaml');
    });

    group('.exists()', () {
      test(
        'returns true when the file exists',
        withTempDir(() {
          // Arrange
          final yamlFile = _getYamlFile();
          File(yamlFile.path).createSync(recursive: true);

          // Act + Assert
          expect(yamlFile.exists(), true);
        }),
      );

      test(
        'returns false when the file does not exists',
        withTempDir(() {
          // Arrange
          final yamlFile = _getYamlFile();

          // Act + Assert
          expect(yamlFile.exists(), false);
        }),
      );
    });

    group('.readValue()', () {
      test(
        'returns correct value when depth is 1',
        withTempDir(() {
          // Arrange
          final yamlFile = _getYamlFile();
          File(yamlFile.path)
            ..createSync(recursive: true)
            ..writeAsStringSync(yamlFileWithValuesDepth4);

          // Act + Assert
          expect(yamlFile.readValue(['a']), 1);
        }),
      );

      test(
        'returns null when value is blank',
        withTempDir(() {
          // Arrange
          final yamlFile = _getYamlFile();
          File(yamlFile.path)
            ..createSync(recursive: true)
            ..writeAsStringSync(yamlFileWithBlankValue);

          // Act + Assert
          expect(yamlFile.readValue(['a']), null);
        }),
      );

      test(
        'throws AssertionError when depth is 0',
        withTempDir(() {
          // Arrange
          final yamlFile = _getYamlFile();
          File(yamlFile.path)
            ..createSync(recursive: true)
            ..writeAsStringSync(yamlFileWithValuesDepth4);

          // Act + Assert
          expect(
            () => yamlFile.readValue([]),
            throwsA(isA<AssertionError>()),
          );
        }),
      );

      test(
        'throws AssertionError when depth is larger than 1',
        withTempDir(() {
          // Arrange
          final yamlFile = _getYamlFile();
          File(yamlFile.path)
            ..createSync(recursive: true)
            ..writeAsStringSync(yamlFileWithValuesDepth4);

          // Act + Assert
          expect(
            () => yamlFile.readValue(['a', 'b']),
            throwsA(isA<AssertionError>()),
          );
        }),
      );
    });

    group('.removeValue()', () {
      test(
        'removes value correctly',
        withTempDir(() {
          // Arrange
          final yamlFile = _getYamlFile();
          final file = File(yamlFile.path)
            ..createSync(recursive: true)
            ..writeAsStringSync(yamlFileWithValuesDepth5);

          // Act
          yamlFile.removeValue(['k']);

          // Assert
          expect(file.readAsStringSync(), yamlFileWithValuesDepth4);
        }),
      );

      test(
        'does nothing when path does not exist',
        withTempDir(() {
          // Arrange
          final yamlFile = _getYamlFile();
          final file = File(yamlFile.path)
            ..createSync(recursive: true)
            ..writeAsStringSync(yamlFileWithValuesDepth4);

          // Act
          yamlFile.removeValue(['k', 'l', 'm', 'n', 'o']);

          // Assert
          expect(file.readAsStringSync(), yamlFileWithValuesDepth4);
        }),
      );
    });

    group('.setValue()', () {
      test(
        'set the value correctly',
        withTempDir(() {
          // Arrange
          final yamlFile = _getYamlFile();
          final file = File(yamlFile.path)
            ..createSync(recursive: true)
            ..writeAsStringSync(yamlFileWithValuesDepth5);

          // Act
          yamlFile.setValue(['a'], 8);

          // Assert

          expect(file.readAsStringSync(), yamlFileWithUpdatedDepth1Value);
        }),
      );

      test(
        'set the value correctly (deep)',
        withTempDir(() {
          // Arrange
          final yamlFile = _getYamlFile();
          final file = File(yamlFile.path)
            ..createSync(recursive: true)
            ..writeAsStringSync(yamlFileWithValuesDepth5);

          // Act
          yamlFile.setValue(['d', 'e', 'f'], 888);

          // Assert
          expect(file.readAsStringSync(), yamlFileWithUpdatedDepth3Value);
        }),
      );

      test(
        'set null correctly',
        withTempDir(() {
          // Arrange
          final yamlFile = _getYamlFile();
          final file = File(yamlFile.path)
            ..createSync(recursive: true)
            ..writeAsStringSync(yamlFileWithValuesDepth5);

          // Act
          yamlFile.setValue(['a'], null);

          // Assert
          expect(file.readAsStringSync(), yamlFileWithNullDepth1Value);
        }),
      );

      test(
        'set null correctly (deep)',
        withTempDir(() {
          // Arrange
          final yamlFile = _getYamlFile();
          final file = File(yamlFile.path)
            ..createSync(recursive: true)
            ..writeAsStringSync(yamlFileWithValuesDepth5);

          // Act
          yamlFile.setValue(['d', 'e', 'f'], null);

          // Assert
          expect(file.readAsStringSync(), yamlFileWithNullDepth3Value);
        }),
      );

      test(
        'set null correctly (blank)',
        withTempDir(() {
          // Arrange
          final yamlFile = _getYamlFile();
          final file = File(yamlFile.path)
            ..createSync(recursive: true)
            ..writeAsStringSync(yamlFileWithValuesDepth5);

          // Act
          yamlFile.setValue(['a'], null, blankIfValueNull: true);

          // Assert
          expect(file.readAsStringSync(), yamlFileWithBlankDepth1Value);
        }),
      );

      test(
        'set null correctly (deep) (blank)',
        withTempDir(() {
          // Arrange
          final yamlFile = _getYamlFile();
          final file = File(yamlFile.path)
            ..createSync(recursive: true)
            ..writeAsStringSync(yamlFileWithValuesDepth5);

          // Act
          yamlFile.setValue(['d', 'e', 'f'], null, blankIfValueNull: true);

          // Assert

          expect(file.readAsStringSync(), yamlFileWithBlankDepth3Value);
        }),
      );
    });
  });
}
