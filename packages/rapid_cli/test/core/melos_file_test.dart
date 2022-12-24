import 'package:rapid_cli/src/core/melos_file.dart';
import 'package:test/test.dart';
import 'package:universal_io/io.dart';

const melosWithName = '''
name: example
''';

const melosWithoutName = '''
''';

void main() {
  group('MelosFile', () {
    final cwd = Directory.current;

    late MelosFile melosFile;

    setUp(() {
      Directory.current = Directory.systemTemp.createTempSync().path;

      melosFile = MelosFile();
    });

    tearDown(() {
      Directory.current = cwd;
    });

    group('path', () {
      test('is "melos.yaml"', () {
        // Assert
        expect(melosFile.path, 'melos.yaml');
      });
    });

    group('file', () {
      test('is "melos.yaml"', () {
        // Assert
        expect(melosFile.file.path, 'melos.yaml');
      });
    });

    group('name', () {
      test('returns the correct value', () {
        // Arrange
        final file = File('melos.yaml');
        file.createSync(recursive: true);
        file.writeAsStringSync(melosWithName);

        // Act
        final name = melosFile.name;

        // Assert
        expect(name, 'example');
      });

      test('throws MelosNameNotFound when no name found', () {
        // Arrange
        final file = File('melos.yaml');
        file.createSync(recursive: true);
        file.writeAsStringSync(melosWithoutName);

        // Act + Assert
        expect(() => melosFile.name, throwsA(isA<MelosNameNotFound>()));
      });
    });
  });
}
