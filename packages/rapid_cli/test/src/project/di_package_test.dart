import 'package:mocktail/mocktail.dart';
import 'package:rapid_cli/src/project/di_package.dart';
import 'package:rapid_cli/src/project/melos_file.dart';
import 'package:rapid_cli/src/project/project.dart';
import 'package:test/test.dart';
import 'package:universal_io/io.dart';

class MockMelosFile extends Mock implements MelosFile {}

class MockProject extends Mock implements Project {}

void main() {
  group('DiPackage', () {
    final cwd = Directory.current;

    const projectName = 'foo_bar';

    late MelosFile melosFile;
    late Project project;
    late DiPackage diPackage;

    setUp(() {
      Directory.current = Directory.systemTemp.createTempSync().path;

      melosFile = MockMelosFile();
      when(() => melosFile.name()).thenReturn(projectName);
      project = MockProject();
      when(() => project.melosFile).thenReturn(melosFile);
      diPackage = DiPackage(project: project);
      Directory(diPackage.path).createSync(recursive: true);
    });

    tearDown(() {
      Directory.current = cwd;
    });

    group('injectionFile', () {
      test('returns correct injection file', () {
        // Act
        final injectionFile = diPackage.injectionFile;

        // Assert
        expect(injectionFile.path,
            'packages/$projectName/${projectName}_di/lib/src/injection.dart');
      });
    });

    group('path', () {
      test('is correct', () {
        // Assert
        expect(diPackage.path, 'packages/$projectName/${projectName}_di');
      });
    });
  });

  group('InjectionFile', () {
    // TODO
  });
}
