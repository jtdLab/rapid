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

void main() {
  group('DartPackage', () {
    final cwd = Directory.current;

    late DartPackage dartPackage;

    setUp(() {
      Directory.current = Directory.systemTemp.createTempSync().path;

      dartPackage = DartPackage();
      Directory(dartPackage.path).createSync(recursive: true);
    });

    tearDown(() {
      Directory.current = cwd;
    });

    group('path', () {
      test('is correct', () {
        // Assert
        expect(dartPackage.path, '.');
      });

      test('is correct with path', () {
        // Arrange
        final path = 'foo';
        dartPackage = DartPackage(path: path);
        Directory(dartPackage.path).createSync(recursive: true);

        // Assert
        expect(dartPackage.path, path);
      });
    });

    group('pubspecFile', () {
      // TODO
    });

    group('delete', () {
      // TODO
    });

    group('exists', () {
      // TODO
    });
  });

  group('PubspecFile', () {
    final cwd = Directory.current;

    late PubspecFile pubspecFile;

    setUp(() {
      Directory.current = Directory.systemTemp.createTempSync().path;

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
