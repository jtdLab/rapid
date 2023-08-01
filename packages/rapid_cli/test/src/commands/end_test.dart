import 'package:mocktail/mocktail.dart';
import 'package:rapid_cli/src/commands/runner.dart';
import 'package:rapid_cli/src/tool.dart';
import 'package:test/test.dart';

import '../mock_env.dart';
import '../mocks.dart';
import '../utils.dart';

void main() {
  late CommandGroup commandGroup;
  late RapidTool tool;

  setUpAll(() {
    registerFallbackValues();
  });

  setUp(() {
    commandGroup = MockCommandGroup();
    when(() => commandGroup.isActive).thenReturn(true);
    tool = MockRapidTool();
    when(() => tool.loadGroup()).thenReturn(commandGroup);
    when(() => tool.deactivateCommandGroup()).thenAnswer((_) {
      when(() => commandGroup.isActive).thenReturn(false);
    });
  });

  group('end', () {
    test(
      'throws NoActiveGroupException when no group is active',
      () async {
        when(() => commandGroup.isActive).thenReturn(false);
        final rapid = getRapid(tool: tool);

        expect(
          () async => rapid.end(),
          throwsA(isA<NoActiveGroupException>()),
        );
      },
    );

    test(
      'completes with no packages to bootstrap and no packages to codegen',
      withMockEnv((manager) async {
        when(() => commandGroup.packagesToBootstrap).thenReturn([]);
        when(() => commandGroup.packagesToCodeGen).thenReturn([]);
        final logger = MockRapidLogger();
        final rapid = getRapid(tool: tool, logger: logger);

        await rapid.end();

        verifyInOrder([
          () => logger.newLine(),
          () => tool.deactivateCommandGroup(),
          () => logger.commandSuccess('Completed Command Group!'),
        ]);
        verifyZeroInteractions(manager);
        verifyNoMoreInteractions(logger);
      }),
    );

    test(
      'completes with packages to bootstrap and no packages to codegen',
      withMockEnv((manager) async {
        final project = MockRapidProject(path: 'project_path');
        final packagesToBootstrap = [
          FakeDartPackage(packageName: 'package_a'),
          FakeDartPackage(packageName: 'package_b')
        ];
        when(() => commandGroup.packagesToBootstrap)
            .thenReturn(packagesToBootstrap);
        when(() => commandGroup.packagesToCodeGen).thenReturn([]);
        final (progress: progress, logger: logger) = setupLoggerWithoutGroup();
        final rapid = getRapid(
          project: project,
          tool: tool,
          logger: logger,
        );

        await rapid.end();

        verifyInOrder([
          () => logger.newLine(),
          () => tool.deactivateCommandGroup(),
          () => logger.progress(
              'Running "melos bootstrap --scope package_a,package_b"'),
          () => manager.runMelosBootstrap(
                ['package_a', 'package_b'],
                workingDirectory: 'project_path',
              ),
          () => progress.complete(),
          () => logger.newLine(),
          () => logger.commandSuccess('Completed Command Group!'),
        ]);
        verifyNoMoreInteractions(manager);
        verifyNoMoreInteractions(progress);
        verifyNoMoreInteractions(logger);
      }),
    );

    test(
      'completes with no packages to bootstrap and packages to codegen',
      withMockEnv((manager) async {
        final packagesToCodeGen = [
          FakeDartPackage(
            packageName: 'package_a',
            path: 'package_a_path',
          ),
          FakeDartPackage(
            packageName: 'package_b',
            path: 'package_b_path',
          )
        ];
        when(() => commandGroup.packagesToBootstrap).thenReturn([]);
        when(() => commandGroup.packagesToCodeGen)
            .thenReturn(packagesToCodeGen);
        final (
          progress: progress,
          groupableProgress: groupableProgress,
          progressGroup: progressGroup,
          logger: logger,
        ) = setupLogger();

        final rapid = getRapid(tool: tool, logger: logger);

        await rapid.end();

        verifyInOrder([
          () => logger.newLine(),
          () => tool.deactivateCommandGroup(),
          () => logger.progressGroup(null),
          () => progressGroup.progress('Running code generation in package_a'),
          () =>
              manager.runFlutterPubRunBuildRunnerBuildDeleteConflictingOutputs(
                workingDirectory: 'package_a_path',
              ),
          () => groupableProgress.complete(),
          () => progressGroup.progress('Running code generation in package_b'),
          () =>
              manager.runFlutterPubRunBuildRunnerBuildDeleteConflictingOutputs(
                workingDirectory: 'package_b_path',
              ),
          () => groupableProgress.complete(),
          () => logger.newLine(),
          () => logger.commandSuccess('Completed Command Group!'),
        ]);
        verifyNoMoreInteractions(manager);
        verifyNoMoreInteractions(progress);
        verifyNoMoreInteractions(groupableProgress);
        verifyNoMoreInteractions(progressGroup);
        verifyNoMoreInteractions(logger);
      }),
    );

    test(
      'completes with packages to bootstrap and packages to codegen',
      withMockEnv((manager) async {
        final project = MockRapidProject(path: 'project_path');
        final packagesToBootstrap = [
          FakeDartPackage(packageName: 'package_a'),
          FakeDartPackage(packageName: 'package_b')
        ];
        final packagesToCodeGen = [
          FakeDartPackage(
            packageName: 'package_c',
            path: 'package_c_path',
          ),
          FakeDartPackage(
            packageName: 'package_d',
            path: 'package_d_path',
          )
        ];
        when(() => commandGroup.packagesToBootstrap)
            .thenReturn(packagesToBootstrap);
        when(() => commandGroup.packagesToCodeGen)
            .thenReturn(packagesToCodeGen);
        final (
          progress: progress,
          groupableProgress: groupableProgress,
          progressGroup: progressGroup,
          logger: logger,
        ) = setupLogger();
        final rapid = getRapid(
          project: project,
          tool: tool,
          logger: logger,
        );

        await rapid.end();

        verifyInOrder([
          () => logger.newLine(),
          () => tool.deactivateCommandGroup(),
          () => logger.progress(
              'Running "melos bootstrap --scope package_a,package_b"'),
          () => manager.runMelosBootstrap(
                ['package_a', 'package_b'],
                workingDirectory: 'project_path',
              ),
          () => progress.complete(),
          () => logger.newLine(),
          () => logger.progressGroup(null),
          () => progressGroup.progress('Running code generation in package_c'),
          () =>
              manager.runFlutterPubRunBuildRunnerBuildDeleteConflictingOutputs(
                workingDirectory: 'package_c_path',
              ),
          () => groupableProgress.complete(),
          () => progressGroup.progress('Running code generation in package_d'),
          () =>
              manager.runFlutterPubRunBuildRunnerBuildDeleteConflictingOutputs(
                workingDirectory: 'package_d_path',
              ),
          () => groupableProgress.complete(),
          () => logger.newLine(),
          () => logger.commandSuccess('Completed Command Group!'),
        ]);
        verifyNoMoreInteractions(manager);
        verifyNoMoreInteractions(progress);
        verifyNoMoreInteractions(groupableProgress);
        verifyNoMoreInteractions(progressGroup);
        verifyNoMoreInteractions(logger);
      }),
    );
  });
}
