import 'package:mocktail/mocktail.dart';
import 'package:rapid_cli/src/commands/runner.dart';
import 'package:test/test.dart';

import '../invocations.dart';
import '../mock_env.dart';
import '../mocks.dart';
import '../utils.dart';

void main() {
  setUpAll(() {
    registerFallbackValues();
  });

  group('end', () {
    test('throws NoActiveGroupException when no group is active', () async {
      final manager = MockProcessManager();
      final commandGroup = MockCommandGroup();
      when(() => commandGroup.isActive).thenReturn(false);
      final tool = MockRapidTool();
      when(() => tool.loadGroup()).thenReturn(commandGroup);
      final logger = MockRapidLogger();
      final melosBootstrapTaskInvocations = setupMelosBootstrapTask(
        manager,
        scope: [],
        logger: logger,
      );
      final codeGenTaskGroupInvocations =
          setupFlutterPubRunBuildRunnerBuildTaskGroup(
        manager,
        packages: [],
        logger: logger,
      );
      final rapid = getRapid(tool: tool, logger: logger);

      expect(
        withMockProcessManager(
          () async => rapid.end(),
          manager: manager,
        ),
        throwsA(isA<NoActiveGroupException>()),
      );
      verifyNeverMulti(melosBootstrapTaskInvocations);
      verifyNeverMulti(codeGenTaskGroupInvocations);
      verifyNever(() => logger.newLine());
      verifyNever(() => logger.commandSuccess(any()));
    });

    test('completes with no packages to bootstrap and no packages to codegen',
        () async {
      final manager = MockProcessManager();
      final commandGroup = MockCommandGroup();
      when(() => commandGroup.isActive).thenReturn(true);
      when(() => commandGroup.packagesToBootstrap).thenReturn([]);
      when(() => commandGroup.packagesToCodeGen).thenReturn([]);
      final tool = MockRapidTool();
      when(() => tool.loadGroup()).thenReturn(commandGroup);
      final logger = MockRapidLogger();
      final melosBootstrapTaskInvocations = setupMelosBootstrapTask(
        manager,
        scope: [],
        logger: logger,
      );
      final codeGenTaskGroupInvocations =
          setupFlutterPubRunBuildRunnerBuildTaskGroup(
        manager,
        packages: [],
        logger: logger,
      );
      final rapid = getRapid(tool: tool, logger: logger);

      await withMockProcessManager(
        () async => rapid.end(),
        manager: manager,
      );

      verifyInOrder([
        () => tool.deactivateCommandGroup(),
        () => logger.newLine(),
        () => logger.commandSuccess('Completed Command Group!'),
      ]);
      verifyNeverMulti(melosBootstrapTaskInvocations);
      verifyNeverMulti(codeGenTaskGroupInvocations);
    });

    test('completes with packages to bootstrap and no packages to codegen',
        () async {
      final manager = MockProcessManager();
      final commandGroup = MockCommandGroup();
      when(() => commandGroup.isActive).thenReturn(true);
      final packagesToBootstrap = [
        FakeDartPackage(packageName: 'package_a'),
        FakeDartPackage(packageName: 'package_b')
      ];
      when(() => commandGroup.packagesToBootstrap)
          .thenReturn(packagesToBootstrap);
      when(() => commandGroup.packagesToCodeGen).thenReturn([]);
      final tool = MockRapidTool();
      when(() => tool.loadGroup()).thenReturn(commandGroup);
      when(() => tool.deactivateCommandGroup()).thenAnswer((_) {
        when(() => commandGroup.isActive).thenReturn(false);
      });
      final logger = MockRapidLogger();
      final melosBootstrapTaskInvocations = setupMelosBootstrapTask(
        manager,
        scope: packagesToBootstrap,
        logger: logger,
      );
      final codeGenTaskGroupInvocations =
          setupFlutterPubRunBuildRunnerBuildTaskGroup(
        manager,
        packages: [],
        logger: logger,
      );
      final rapid = getRapid(
        tool: tool,
        logger: logger,
      );

      await withMockProcessManager(
        () async => rapid.end(),
        manager: manager,
      );

      verifyInOrder([
        () => tool.deactivateCommandGroup(),
        ...melosBootstrapTaskInvocations,
        () => logger.newLine(),
        () => logger.commandSuccess('Completed Command Group!'),
      ]);
      verifyNeverMulti(codeGenTaskGroupInvocations);
    });

    test('completes with no packages to bootstrap and packages to codegen',
        () async {
      final manager = MockProcessManager();
      final commandGroup = MockCommandGroup();
      when(() => commandGroup.isActive).thenReturn(true);
      final packagesToCodeGen = [
        FakeDartPackage(packageName: 'package_a'),
        FakeDartPackage(packageName: 'package_b')
      ];
      when(() => commandGroup.packagesToBootstrap).thenReturn([]);
      when(() => commandGroup.packagesToCodeGen).thenReturn(packagesToCodeGen);
      final tool = MockRapidTool();
      when(() => tool.loadGroup()).thenReturn(commandGroup);
      when(() => tool.deactivateCommandGroup()).thenAnswer((_) {
        when(() => commandGroup.isActive).thenReturn(false);
      });
      final logger = MockRapidLogger();
      final melosBootstrapTaskInvocations = setupMelosBootstrapTask(
        manager,
        scope: [],
        logger: logger,
      );
      final codeGenTaskGroupInvocations =
          setupFlutterPubRunBuildRunnerBuildTaskGroup(
        manager,
        packages: packagesToCodeGen,
        logger: logger,
      );
      final rapid = getRapid(tool: tool, logger: logger);

      await withMockProcessManager(
        () async => rapid.end(),
        manager: manager,
      );

      verifyInOrder([
        () => tool.deactivateCommandGroup(),
        ...codeGenTaskGroupInvocations,
        () => logger.newLine(),
        () => logger.commandSuccess('Completed Command Group!'),
      ]);
      verifyNeverMulti(melosBootstrapTaskInvocations);
    });

    test('completes with packages to bootstrap and packages to codegen',
        () async {
      final manager = MockProcessManager();
      final commandGroup = MockCommandGroup();
      when(() => commandGroup.isActive).thenReturn(true);
      final packagesToBootstrap = [
        FakeDartPackage(packageName: 'package_a'),
        FakeDartPackage(packageName: 'package_b')
      ];
      when(() => commandGroup.packagesToBootstrap)
          .thenReturn(packagesToBootstrap);
      final packagesToCodeGen = [
        FakeDartPackage(packageName: 'package_a'),
        FakeDartPackage(packageName: 'package_b')
      ];
      when(() => commandGroup.packagesToCodeGen).thenReturn(packagesToCodeGen);
      final tool = MockRapidTool();
      when(() => tool.loadGroup()).thenReturn(commandGroup);
      when(() => tool.deactivateCommandGroup()).thenAnswer((_) {
        when(() => commandGroup.isActive).thenReturn(false);
      });
      final logger = MockRapidLogger();
      final melosBootstrapTaskInvocations = setupMelosBootstrapTask(
        manager,
        scope: packagesToBootstrap,
        logger: logger,
      );
      final codeGenTaskGroupInvocations =
          setupFlutterPubRunBuildRunnerBuildTaskGroup(
        manager,
        packages: packagesToCodeGen,
        logger: logger,
      );
      final rapid = getRapid(
        tool: tool,
        logger: logger,
      );

      await withMockProcessManager(
        () async => rapid.end(),
        manager: manager,
      );

      verifyInOrder([
        () => tool.deactivateCommandGroup(),
        ...melosBootstrapTaskInvocations,
        ...codeGenTaskGroupInvocations,
        () => logger.newLine(),
        () => logger.commandSuccess('Completed Command Group!'),
      ]);
    });
  });
}
