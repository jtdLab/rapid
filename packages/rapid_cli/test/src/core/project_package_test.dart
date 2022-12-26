import 'package:mocktail/mocktail.dart';
import 'package:rapid_cli/src/core/project_package.dart';
import 'package:test/test.dart';
import 'package:universal_io/io.dart';

const pubspecInitial = '''
name: test_app

environment:
  sdk: ">=2.13.0 <3.0.0"

dependencies:
  a:
''';

const pubspecWithCustomDependency = '''
name: test_app

environment:
  sdk: ">=2.13.0 <3.0.0"

dependencies:
  a:
  my_dependency: ^1.0.0
''';

const pubspecPattern = '''
name: test_app

environment:
  sdk: ">=2.13.0 <3.0.0"

dependencies:
  a:
  pattern_1:
  pattern_2:
  xxx_pattern_xxx:
''';

class MockProjectPackage extends Mock implements ProjectPackage {}

void main() {
  group('PubspecFile', () {
    final cwd = Directory.current;

    late ProjectPackage package;
    late PubspecFile pubspecFile;

    const packagePath = 'packages/test_app/test_app';

    setUp(() {
      Directory.current = Directory.systemTemp.createTempSync().path;

      package = MockProjectPackage();
      when(() => package.path).thenReturn(packagePath);
      pubspecFile = PubspecFile(package: package);
    });

    tearDown(() {
      Directory.current = cwd;
    });

    group('addDependency', () {
      test('adds dependency', () {
        // Arrange
        final dir = Directory(packagePath);
        dir.createSync(recursive: true);
        final pubspec = File('$packagePath/pubspec.yaml');
        pubspec.createSync(recursive: true);
        pubspec.writeAsStringSync(pubspecInitial);

        // Act
        pubspecFile.addDependency('my_dependency', '^1.0.0');

        // Assert
        expect(pubspec.readAsStringSync(), pubspecWithCustomDependency);
      });
    });

    group('removeDependency', () {
      test('removes dependency', () {
        // Arrange
        final dir = Directory(packagePath);
        dir.createSync(recursive: true);
        final pubspec = File('$packagePath/pubspec.yaml');
        pubspec.createSync(recursive: true);
        pubspec.writeAsStringSync(pubspecWithCustomDependency);

        // Act
        pubspecFile.removeDependency('my_dependency');

        // Assert
        expect(pubspec.readAsStringSync(), pubspecInitial);
      });
    });

    group('removeDependencyByPattern', () {
      test('removes dependencies that contain specific pattern', () {
        // Arrange
        final dir = Directory(packagePath);
        dir.createSync(recursive: true);
        final pubspec = File('$packagePath/pubspec.yaml');
        pubspec.createSync(recursive: true);
        pubspec.writeAsStringSync(pubspecPattern);

        // Act
        pubspecFile.removeDependencyByPattern('pattern');

        // Assert
        expect(pubspec.readAsStringSync(), pubspecInitial);
      });
    });
  });
}
