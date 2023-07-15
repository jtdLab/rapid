import 'package:mocktail/mocktail.dart';
import 'package:rapid_cli/src/commands/runner.dart';
import 'package:test/test.dart';

import '../invocations.dart';
import '../mock_env.dart';
import '../mocks.dart';
import '../utils.dart';

void main() {
  group('end', () {
    test('throws NoActiveGroupException when no group is active', () async {
      final manager = MockProcessManager();
      final commandGroup = MockCommandGroup();
      when(() => commandGroup.isActive).thenReturn(false);
      final tool = MockRapidTool();
      when(() => tool.loadGroup()).thenReturn(commandGroup);
      final logger = MockRapidLogger();
      final rapid = getRapid(tool: tool, logger: logger);

      expect(
        withMockProcessManager(
          () async => rapid.end(),
          manager: manager,
        ),
        throwsA(isA<NoActiveGroupException>()),
      );
      verifyNeverMulti(melosBootstrapTask(manager, scope: []));
      verifyNeverMulti(flutterPubRunBuildRunnerBuildTask(manager));
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
      verifyNeverMulti(melosBootstrapTask(manager, scope: []));
      verifyNeverMulti(
        flutterPubRunBuildRunnerBuildTaskGroup(manager, packages: []),
      );
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
      final logger = MockRapidLogger();
      final rapid = getRapid(tool: tool, logger: logger);

      await withMockProcessManager(
        () async => rapid.end(),
        manager: manager,
      );

      verifyInOrder([
        () => tool.deactivateCommandGroup(),
        ...melosBootstrapTask(manager, scope: packagesToBootstrap),
        () => logger.newLine(),
        () => logger.commandSuccess('Completed Command Group!'),
      ]);
      verifyNeverMulti(
        flutterPubRunBuildRunnerBuildTaskGroup(manager, packages: []),
      );
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
      final logger = MockRapidLogger();
      final rapid = getRapid(tool: tool, logger: logger);

      await withMockProcessManager(
        () async => rapid.end(),
        manager: manager,
      );

      verifyInOrder([
        () => tool.deactivateCommandGroup(),
        ...flutterPubRunBuildRunnerBuildTaskGroup(
          manager,
          packages: packagesToCodeGen,
        ),
        () => logger.newLine(),
        () => logger.commandSuccess('Completed Command Group!'),
      ]);
      verifyNeverMulti(melosBootstrapTask(manager, scope: []));
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
      final logger = MockRapidLogger();
      final rapid = getRapid(tool: tool, logger: logger);

      await withMockProcessManager(
        () async => rapid.end(),
        manager: manager,
      );

      verifyInOrder([
        () => tool.deactivateCommandGroup(),
        ...melosBootstrapTask(manager, scope: packagesToBootstrap),
        ...flutterPubRunBuildRunnerBuildTaskGroup(
          manager,
          packages: packagesToCodeGen,
        ),
        () => logger.newLine(),
        () => logger.commandSuccess('Completed Command Group!'),
      ]);
    });
  });
}
