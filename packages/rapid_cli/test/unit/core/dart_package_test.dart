import 'dart:io';

import 'package:mocktail/mocktail.dart';
import 'package:rapid_cli/src/core/dart_package.dart';
import 'package:test/test.dart';

import '../common.dart';
import '../mocks.dart';

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

const pubspecWithName = '''
name: foo_bar
''';

const pubspecWithoutName = '''
some: value
''';

DartPackage _getDartPackage({
  String? path,
  PubspecFile? pubspecFile,
}) {
  return DartPackage(
    path: path ?? 'some/path', // TODO needed some/path
  )..pubspecFileOverrides = pubspecFile;
}

PubspecFile _getPubspecFile({
  String? path,
}) {
  return PubspecFile(
    path: path ?? 'some/path', // TODO needed some/path
  );
}

void main() {
  group('DartPackage', () {
    group('.delete()', () {
      test(
        'deletes the directory',
        withTempDir(() {
          // Arrange
          final dartPackage = _getDartPackage();
          final directory = Directory(dartPackage.path)
            ..createSync(recursive: true);

          // Act
          dartPackage.delete(logger: FakeLogger());

          // Assert
          expect(directory.existsSync(), false);
        }),
      );
    });

    group('.exists()', () {
      test(
        'returns true when the directory exists',
        withTempDir(() {
          // Act
          final dartPackage = _getDartPackage();
          Directory(dartPackage.path).createSync(recursive: true);

          // Act + Assert
          expect(dartPackage.exists(), true);
        }),
      );

      test(
        'returns false when the directory does not exists',
        withTempDir(() {
          // Arrange
          final dartPackage = _getDartPackage();

          // Act + Assert
          expect(dartPackage.exists(), false);
        }),
      );
    });

    test('.path', () {
      // Arrange
      final dartPackage = _getDartPackage(path: 'dart_package/path');

      // Act + Assert
      expect(dartPackage.path, 'dart_package/path');
    });

    test('.pubspecFile', () {
      // Arrange
      final dartPackage = _getDartPackage(path: 'dart_package/path');

      // Act + Assert
      expect(
        dartPackage.pubspecFile,
        isA<PubspecFile>().having(
          (pubspec) => pubspec.path,
          'path',
          'dart_package/path/pubspec.yaml',
        ),
      );
    });

    test('.packageName()', () {
      // Arrange
      final pubspecFile = getPubspecFile();
      when(() => pubspecFile.readName()).thenReturn('my_project');
      final dartPackage = _getDartPackage(pubspecFile: pubspecFile);

      // Act + Assert
      expect(dartPackage.packageName(), 'my_project');
    });
  });

  group('PubspecFile', () {
    group('.readName()', () {
      test(
        'returns name',
        withTempDir(() {
          // Arrange
          final pubspecFile = _getPubspecFile();
          File(pubspecFile.path)
            ..createSync(recursive: true)
            ..writeAsStringSync(pubspecWithName);

          // Act + Assert
          expect(pubspecFile.readName(), 'foo_bar');
        }),
      );

      test(
        'throws when name is not present',
        withTempDir(() {
          // Arrange
          final pubspecFile = _getPubspecFile();
          File(pubspecFile.path)
            ..createSync(recursive: true)
            ..writeAsStringSync(pubspecWithoutName);

          // Act + Assert
          expect(() => pubspecFile.readName(), throwsA(isA<ReadNameFailure>()));
        }),
      );
    });

    test('.path', () {
      // Arrange
      final pubspecFile = _getPubspecFile(path: 'pubspec/path');

      // Act + Assert
      expect(pubspecFile.path, 'pubspec/path/pubspec.yaml');
    });

    group('.removeDependency()', () {
      test(
        'removes dependency correctly',
        withTempDir(() {
          // Arrange
          final pubspecFile = _getPubspecFile();
          final file = File(pubspecFile.path)
            ..createSync(recursive: true)
            ..writeAsStringSync(pubspecWithAdditionalDependencyWithVersion);

          // Act
          pubspecFile.removeDependency('my_dependency');

          // Assert
          expect(file.readAsStringSync(), pubspecWithDependencies);
        }),
      );
    });

    group('.removeDependencyByPattern()', () {
      test(
        'removes dependencies that match the pattern correctly',
        withTempDir(() {
          // Arrange
          final pubspecFile = _getPubspecFile();
          final file = File(pubspecFile.path)
            ..createSync(recursive: true)
            ..writeAsStringSync(pubspecWithAdditionalPatternDependencies);

          // Act
          pubspecFile.removeDependencyByPattern('my_pattern');

          // Assert
          expect(file.readAsStringSync(), pubspecWithDependencies);
        }),
      );

      test(
        'does nothing when no dependencies that match pattern exist',
        withTempDir(() {
          // Arrange
          final pubspecFile = _getPubspecFile();
          final file = File(pubspecFile.path)
            ..createSync(recursive: true)
            ..writeAsStringSync(pubspecWithDependencies);

          // Act
          pubspecFile.removeDependencyByPattern('my_pattern');

          // Assert
          final contents = file.readAsStringSync();
          expect(contents, pubspecWithDependencies);
        }),
      );
    });

    group('.setDependency()', () {
      test(
        'adds dependency with version correctly',
        withTempDir(() {
          // Arrange
          final pubspecFile = _getPubspecFile();
          final file = File(pubspecFile.path)
            ..createSync(recursive: true)
            ..writeAsStringSync(pubspecWithDependencies);

          // Act
          pubspecFile.setDependency('my_dependency', version: '1.1.1');

          // Assert
          final contents = file.readAsStringSync();
          expect(contents, pubspecWithAdditionalDependencyWithVersion);
        }),
      );

      test(
        'adds dependency without version correctly',
        withTempDir(() {
          // Arrange
          final pubspecFile = _getPubspecFile();
          final file = File(pubspecFile.path)
            ..createSync(recursive: true)
            ..writeAsStringSync(pubspecWithDependencies);

          // Act
          pubspecFile.setDependency('my_dependency');

          // Assert
          final contents = file.readAsStringSync();
          expect(contents, pubspecWithAdditionalDependencyWithoutVersion);
        }),
      );

      test(
        'updates dependency version correctly',
        withTempDir(() {
          // Arrange
          final pubspecFile = _getPubspecFile();
          final file = File(pubspecFile.path)
            ..createSync(recursive: true)
            ..writeAsStringSync(pubspecWithDependencies);

          // Act
          pubspecFile.setDependency('baz', version: '^5.0.0');

          // Assert
          final contents = file.readAsStringSync();
          expect(contents, pubspecWithDependenciesUpdated);
        }),
      );
    });
  });
}
