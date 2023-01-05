import 'package:rapid_cli/src/core/dart_package.dart';
import 'package:test/test.dart';
import 'package:universal_io/io.dart';

const pubspecWithDependencies = '''
name: foo_bar
description: Foo bar
version: 0.0.1

dependencies:
  foo: ^1.0.3
  bar:
  bis: null
  baz: ^3.2.0
''';

const pubspecWithDependenciesUpdated = '''
name: foo_bar
description: Foo bar
version: 0.0.1

dependencies:
  foo: ^1.0.3
  bar:
  bis: null
  baz: ^5.0.0
''';

const pubspecWithAdditionalDependencyWithVersion = '''
name: foo_bar
description: Foo bar
version: 0.0.1

dependencies:
  foo: ^1.0.3
  bar:
  bis: null
  baz: ^3.2.0
  my_dependency: 1.1.1
''';

const pubspecWithAdditionalDependencyWithoutVersion = '''
name: foo_bar
description: Foo bar
version: 0.0.1

dependencies:
  foo: ^1.0.3
  bar:
  bis: null
  baz: ^3.2.0
  my_dependency:
''';

const pubspecWithAdditionalPatternDependencies = '''
name: foo_bar
description: Foo bar
version: 0.0.1

dependencies:
  foo: ^1.0.3
  my_pattern_a: ^1.0.0
  bar:
  bis: null
  baz: ^3.2.0
  my_pattern_b: 1.2.1
  my_pattern_c: ^3.1.0
''';

void main() {
  group('DartPackage', () {
    final cwd = Directory.current;

    const path = 'foo';
    late DartPackage dartPackage;

    setUp(() {
      Directory.current = Directory.systemTemp.createTempSync();

      dartPackage = DartPackage(path: path);
      Directory(dartPackage.path).createSync(recursive: true);
    });

    tearDown(() {
      Directory.current = cwd;
    });

    group('delete', () {
      test('deletes the directory', () {
        // Arrange
        final directory = Directory(dartPackage.path);

        // Act
        dartPackage.delete();

        // Assert
        expect(directory.existsSync(), false);
      });
    });

    group('exists', () {
      test('returns true when the directory exists', () {
        // Act
        final exists = dartPackage.exists();

        // Assert
        expect(exists, true);
      });

      test('returns false when the directory does not exists', () {
        // Arrange
        Directory(dartPackage.path).deleteSync(recursive: true);

        // Act
        final exists = dartPackage.exists();

        // Assert
        expect(exists, false);
      });
    });

    group('path', () {
      test('is correct', () {
        // Assert
        expect(dartPackage.path, path);
      });

      test('is correct (no path)', () {
        // Arrange
        dartPackage = DartPackage();

        // Assert
        expect(dartPackage.path, '.');
      });
    });

    group('pubspecFile', () {
      test('returns correct pubspec file', () {
        // Act
        final pubspecFile = dartPackage.pubspecFile;

        // Assert
        expect(pubspecFile.path, '$path/pubspec.yaml');
      });
    });
  });

  group('PubspecFile', () {
    final cwd = Directory.current;

    late PubspecFile pubspecFile;

    setUp(() {
      Directory.current = Directory.systemTemp.createTempSync();

      pubspecFile = PubspecFile();
      File(pubspecFile.path).createSync(recursive: true);
    });

    tearDown(() {
      Directory.current = cwd;
    });

    group('path', () {
      test('is correct', () {
        // Assert
        expect(pubspecFile.path, 'pubspec.yaml');
      });
    });

    group('removeDependency', () {
      test('removes dependency correctly', () {
        // Arrange
        final file = File(pubspecFile.path);
        file.writeAsStringSync(pubspecWithAdditionalDependencyWithVersion);

        // Act
        pubspecFile.removeDependency('my_dependency');

        // Assert
        final contents = file.readAsStringSync();
        expect(contents, pubspecWithDependencies);
      });
    });

    group('removeDependencyByPattern', () {
      test('removes dependencies that match the pattern correctly', () {
        // Arrange
        final file = File(pubspecFile.path);
        file.writeAsStringSync(pubspecWithAdditionalPatternDependencies);

        // Act
        pubspecFile.removeDependencyByPattern('my_pattern');

        // Assert
        final contents = file.readAsStringSync();
        expect(contents, pubspecWithDependencies);
      });

      test('does nothing when no dependencies that match pattern exist', () {
        // Arrange
        final file = File(pubspecFile.path);
        file.writeAsStringSync(pubspecWithDependencies);

        // Act
        pubspecFile.removeDependencyByPattern('my_pattern');

        // Assert
        final contents = file.readAsStringSync();
        expect(contents, pubspecWithDependencies);
      });
    });

    group('setDependency', () {
      test('adds dependency with version correctly', () {
        // Arrange
        final file = File(pubspecFile.path);
        file.writeAsStringSync(pubspecWithDependencies);

        // Act
        pubspecFile.setDependency('my_dependency', version: '1.1.1');

        // Assert
        final contents = file.readAsStringSync();
        expect(contents, pubspecWithAdditionalDependencyWithVersion);
      });

      test('adds dependency without version correctly', () {
        // Arrange
        final file = File(pubspecFile.path);
        file.writeAsStringSync(pubspecWithDependencies);

        // Act
        pubspecFile.setDependency('my_dependency');

        // Assert
        final contents = file.readAsStringSync();
        expect(contents, pubspecWithAdditionalDependencyWithoutVersion);
      });

      test('updates dependency version correctly', () {
        // Arrange
        final file = File(pubspecFile.path);
        file.writeAsStringSync(pubspecWithDependencies);

        // Act
        pubspecFile.setDependency('baz', version: '^5.0.0');

        // Assert
        final contents = file.readAsStringSync();
        expect(contents, pubspecWithDependenciesUpdated);
      });
    });
  });
}
