import 'package:mocktail/mocktail.dart';
import 'package:rapid_cli/src/project/app_package.dart';
import 'package:rapid_cli/src/project/melos_file.dart';
import 'package:rapid_cli/src/project/project.dart';
import 'package:test/test.dart';
import 'package:universal_io/io.dart';

class MockMelosFile extends Mock implements MelosFile {}

class MockProject extends Mock implements Project {}

void main() {
  group('AppPackage', () {
    final cwd = Directory.current;

    const projectName = 'foo_bar';
    late MelosFile melosFile;
    late Project project;
    late AppPackage appPackage;

    setUp(() {
      Directory.current = Directory.systemTemp.createTempSync().path;

      melosFile = MockMelosFile();
      when(() => melosFile.name()).thenReturn(projectName);
      project = MockProject();
      when(() => project.melosFile).thenReturn(melosFile);
      appPackage = AppPackage(project: project);
      Directory(appPackage.path).createSync(recursive: true);
    });

    tearDown(() {
      Directory.current = cwd;
    });

    group('mainFiles', () {
      test(
          'returns correct three main files with env development, test and production',
          () {
        // Act
        final mainFiles = appPackage.mainFiles;

        // Assert
        expect(mainFiles, hasLength(3));
        final mainFileDev = mainFiles.first;
        expect(mainFileDev.env, Environment.development);
        expect(mainFileDev.path,
            'packages/$projectName/$projectName/lib/main_development.dart');
        final mainFileTest = mainFiles.elementAt(1);
        expect(mainFileTest.env, Environment.test);
        expect(mainFileTest.path,
            'packages/$projectName/$projectName/lib/main_test.dart');
        final mainFileProd = mainFiles.last;
        expect(mainFileProd.env, Environment.production);
        expect(mainFileProd.path,
            'packages/$projectName/$projectName/lib/main_production.dart');
      });
    });

    group('path', () {
      test('is correct', () {
        // Assert
        expect(appPackage.path, 'packages/$projectName/$projectName');
      });
    });
  });

  group('MainFile', () {
    group('addSetupCodeForPlatform', () {
      // TODO
    });

    group('removeSetupCodeForPlatform', () {
      // TODO
    });
  });
}
