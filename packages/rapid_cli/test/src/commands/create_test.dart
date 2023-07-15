void main() {
  // TODO impl
}

/* import 'package:path/path.dart' as p;
import 'package:rapid_cli/src/commands/runner.dart';
import 'package:rapid_cli/src/io.dart';
import 'package:rapid_cli/src/project/language.dart';
import 'package:test/test.dart';

import '../mock_fs.dart';
import '../utils.dart';

void main() {
  group('create', () {
    test(
      'throws OutputDirNotEmptyException when output directory is not empty',
      withMockFs(() async {
        final outputDir = 'some/path';
        // simulate non empty output dir
        File(p.join(outputDir, 'foo')).absolute.createSync(recursive: true);
        final rapid = getRapid();

        expect(
          rapid.create(
            projectName: 'test_app',
            outputDir: outputDir,
            description: 'Some desc.',
            orgName: 'test.example',
            language: Language(languageCode: 'fr'),
            platforms: {},
          ),
          throwsA(isA<OutputDirNotEmptyException>()),
        );
/*         verifyNever(() => tool.loadGroup());
        verifyNever(() => tool.activateCommandGroup());
        verifyNever(() => logger.commandSuccess(any())); */
      }),
    );

/*     test('creates project and activates platforms', () async {
      final commandGroup = MockCommandGroup();
      final commandGroupIsActive = false;
      when(() => tool.loadGroup()).thenReturn(commandGroup);
      when(() => commandGroup.isActive).thenReturn(commandGroupIsActive);

      await rapid.create(
        projectName: projectName,
        outputDir: outputDir,
        description: description,
        orgName: orgName,
        language: language,
        platforms: platforms,
      );

      verify(() => logger.newLine()).called(1);
      verify(() => tool.activateCommandGroup()).called(1);
      verify(() => logger.newLine()).called(1);
      verify(() => logger.commandSuccess('Started Command Group!')).called(1);
    });
  */
  });
}
 */
