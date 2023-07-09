import 'dart:convert';

import 'package:mocktail/mocktail.dart';
import 'package:rapid_cli/src/commands/runner.dart';
import 'package:rapid_cli/src/io.dart';
import 'package:rapid_cli/src/logging.dart';
import 'package:rapid_cli/src/project/project.dart';
import 'package:rapid_cli/src/project_config.dart';
import 'package:test/test.dart';

import '../mock_env.dart';
import '../mock_fs.dart';
import '../mocks.dart';
import '../project/mock_project.dart';

Rapid _getRapid({
  required RapidProject project,
  RapidLogger? logger,
}) {
  return Rapid(project: project, logger: logger ?? RapidLogger());
}

void main() {
  group('pubAdd', () {
    test('completes', () async {
      final processManager = MockProcessManager();
      when(
        () => processManager.run(
          any(),
          workingDirectory: any(named: 'workingDirectory'),
          runInShell: true,
          stderrEncoding: utf8,
          stdoutEncoding: utf8,
        ),
      ).thenAnswer((_) async => ProcessResult(0, 0, null, null));

      await withMockProcess(
        () async {
          final project = RapidProject.fromConfig(
            RapidProjectConfig(
              name: 'my_app',
              path: '/rapid_project',
            ),
          );

          final rapid = _getRapid(project: project);

          await rapid.pubAdd(
            packageName: 'my_app_ui',
            packages: ['foo', 'dev:bar'],
          );
        },
        manager: processManager,
      )();

      verify(
        () => processManager.run(
          [
            'dart',
            'pub',
            'add',
            'foo',
            'dev:bar',
          ],
          runInShell: true,
          stderrEncoding: utf8,
          stdoutEncoding: utf8,
        ),
      ).called(1);
    });
  });

  group('pubGet', () {
    test(
      'hyep',
      withMockFs(
        () async {
          await createProjectFs();
          print(Directory.current.listSync(recursive: true));
        },
      ),
    );
  });

  group('pubRemove', () {});
}
