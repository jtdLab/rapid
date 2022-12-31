import 'package:rapid_cli/src/core/yaml_file.dart';
import 'package:test/test.dart';
import 'package:universal_io/io.dart';

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

void main() {
  group('YamlFile', () {
    final cwd = Directory.current;

    late YamlFile yamlFile;

    setUp(() {
      Directory.current = Directory.systemTemp.createTempSync().path;

      yamlFile = YamlFile(name: 'foo');
      File(yamlFile.path).createSync(recursive: true);
    });

    tearDown(() {
      Directory.current = cwd;
    });

    group('path', () {
      test('is correct', () {
        // Assert
        expect(yamlFile.path, 'foo.yaml');
      });
    });

    group('readValue', () {
      test('returns correct value (depth = 1)', () {
        // Arrange
        final file = File(yamlFile.path);
        file.writeAsStringSync(yamlFileWithValuesDepth4);

        // Act
        final value = yamlFile.readValue(['a']);

        // Assert
        expect(value, 1);
      });

      test('returns correct value (depth = 2)', () {
        // Arrange
        final file = File(yamlFile.path);
        file.writeAsStringSync(yamlFileWithValuesDepth4);

        // Act
        final value = yamlFile.readValue(['b', 'c']);

        // Assert
        expect(value, 2);
      });

      test('returns correct value (depth = 3)', () {
        // Arrange
        final file = File(yamlFile.path);
        file.writeAsStringSync(yamlFileWithValuesDepth4);

        // Act
        final value = yamlFile.readValue(['d', 'e', 'f']);

        // Assert
        expect(value, 3);
      });

      test('returns correct value (depth = 4)', () {
        // Arrange
        final file = File(yamlFile.path);
        file.writeAsStringSync(yamlFileWithValuesDepth4);

        // Act
        final value = yamlFile.readValue(['g', 'h', 'i', 'j']);

        // Assert
        expect(value, 4);
      });

      test('returns null when value is blank', () {
        // Arrange
        final file = File(yamlFile.path);
        file.writeAsStringSync(yamlFileWithBlankValue);

        // Act
        final value = yamlFile.readValue(['a']);

        // Assert
        expect(value, null);
      });

      test('throws AssertionError when depth is 0', () {
        // Arrange
        final file = File(yamlFile.path);
        file.writeAsStringSync(yamlFileWithValuesDepth4);

        // Act & Assert
        expect(
          () => yamlFile.readValue([]),
          throwsA(isA<AssertionError>()),
        );
      });

      test('throws AssertionError when depth is larger than 4', () {
        // Arrange
        final file = File(yamlFile.path);
        file.writeAsStringSync(yamlFileWithValuesDepth4);

        // Act & Assert
        expect(
          () => yamlFile.readValue(['k', 'l', 'm', 'n', 'o']),
          throwsA(isA<AssertionError>()),
        );
      });

      test('throws InvalidPath when path is invalid', () {
        // Arrange
        final file = File(yamlFile.path);
        file.writeAsStringSync(yamlFileWithValuesDepth5);

        // Act & Assert
        expect(
          () => yamlFile.readValue(['z', 'z']),
          throwsA(isA<InvalidPath>()),
        );
      });
    });

    group('removeValue', () {
      test('removes value correctly', () {
        // Arrange
        final file = File(yamlFile.path);
        file.writeAsStringSync(yamlFileWithValuesDepth5);

        // Act
        yamlFile.removeValue(['k']);

        // Assert
        final contents = file.readAsStringSync();
        expect(contents, yamlFileWithValuesDepth4);
      });

      test('does nothing when path does not exist', () {
        // Arrange
        final file = File(yamlFile.path);
        file.writeAsStringSync(yamlFileWithValuesDepth4);

        // Act
        yamlFile.removeValue(['k', 'l', 'm', 'n', 'o']);

        // Assert
        final contents = file.readAsStringSync();
        expect(contents, yamlFileWithValuesDepth4);
      });
    });

    group('setValue', () {
      test('set the value correctly', () {
        // Arrange
        final file = File(yamlFile.path);
        file.writeAsStringSync(yamlFileWithValuesDepth5);

        // Act
        yamlFile.setValue(['a'], 8);

        // Assert
        final contents = file.readAsStringSync();
        expect(contents, yamlFileWithUpdatedDepth1Value);
      });

      test('set the value correctly (deep)', () {
        // Arrange
        final file = File(yamlFile.path);
        file.writeAsStringSync(yamlFileWithValuesDepth5);

        // Act
        yamlFile.setValue(['d', 'e', 'f'], 888);

        // Assert
        final contents = file.readAsStringSync();
        expect(contents, yamlFileWithUpdatedDepth3Value);
      });

      test('set null correctly', () {
        // Arrange
        final file = File(yamlFile.path);
        file.writeAsStringSync(yamlFileWithValuesDepth5);

        // Act
        yamlFile.setValue(['a'], null);

        // Assert
        final contents = file.readAsStringSync();
        expect(contents, yamlFileWithNullDepth1Value);
      });

      test('set null correctly (deep)', () {
        // Arrange
        final file = File(yamlFile.path);
        file.writeAsStringSync(yamlFileWithValuesDepth5);

        // Act
        yamlFile.setValue(['d', 'e', 'f'], null);

        // Assert
        final contents = file.readAsStringSync();
        expect(contents, yamlFileWithNullDepth3Value);
      });

      test('set null correctly (blank)', () {
        // Arrange
        final file = File(yamlFile.path);
        file.writeAsStringSync(yamlFileWithValuesDepth5);

        // Act
        yamlFile.setValue(['a'], null, blankIfValueNull: true);

        // Assert
        final contents = file.readAsStringSync();
        expect(contents, yamlFileWithBlankDepth1Value);
      });

      test('set null correctly (deep) (blank)', () {
        // Arrange
        final file = File(yamlFile.path);
        file.writeAsStringSync(yamlFileWithValuesDepth5);

        // Act
        yamlFile.setValue(['d', 'e', 'f'], null, blankIfValueNull: true);

        // Assert
        final contents = file.readAsStringSync();
        expect(contents, yamlFileWithBlankDepth3Value);
      });
    });
  });
}
