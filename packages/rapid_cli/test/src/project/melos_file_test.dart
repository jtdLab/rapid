import 'package:rapid_cli/src/project/melos_file.dart';
import 'package:test/test.dart';
import 'package:universal_io/io.dart';

const melosWithName = '''
name: foo_bar
''';

const melosWithoutName = '''
some: value
''';

void main() {
  group('MelosFile', () {
    final cwd = Directory.current;

    late MelosFile melosFile;

    setUp(() {
      Directory.current = Directory.systemTemp.createTempSync().path;

      melosFile = MelosFile();
      File(melosFile.path).createSync(recursive: true);
    });

    tearDown(() {
      Directory.current = cwd;
    });

    group('path', () {
      test('is correct', () {
        // Assert
        expect(melosFile.path, 'melos.yaml');
      });
    });

    group('exists', () {
      test('returns true when the file exists', () {
        // Act
        final exists = melosFile.exists();

        // Assert
        expect(exists, true);
      });

      test('returns false when the file does not exists', () {
        // Arrange
        File(melosFile.path).deleteSync(recursive: true);

        // Act
        final exists = melosFile.exists();

        // Assert
        expect(exists, false);
      });
    });

    group('name', () {
      test('returns name', () {
        // Arrange
        final file = File(melosFile.path);
        file.writeAsStringSync(melosWithName);

        // Act + Assert
        expect(melosFile.name(), 'foo_bar');
      });

      test('throws when name is not present', () {
        // Arrange
        final file = File(melosFile.path);
        file.writeAsStringSync(melosWithoutName);

        // Act + Assert
        expect(() => melosFile.name(), throwsA(isA<ReadNameFailure>()));
      });
    });
  });
}
