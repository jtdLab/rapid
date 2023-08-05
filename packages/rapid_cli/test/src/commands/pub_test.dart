import 'dart:convert';

import 'package:mocktail/mocktail.dart';
import 'package:rapid_cli/src/commands/runner.dart';
import 'package:rapid_cli/src/io/io.dart';
import 'package:rapid_cli/src/project/project.dart';
import 'package:rapid_cli/src/tool.dart';
import 'package:test/test.dart';

import '../mock_env.dart';
import '../mocks.dart';
import '../utils.dart';

void main() {
  late RapidProject project;
  late CommandGroup commandGroup;
  late RapidTool tool;

  setUpAll(() {
    registerFallbackValues();
  });

  setUp(() {
    project = MockRapidProject();
    commandGroup = MockCommandGroup();
    when(() => commandGroup.isActive).thenReturn(false);
    tool = MockRapidTool();
    when(() => tool.loadGroup()).thenReturn(commandGroup);
  });

  group('pubAdd', () {
    test('throws PackageNotFoundException when package is not found by name',
        () {
      when(() => project.findByPackageName('non_existing_package'))
          .thenThrow(Exception());
      final rapid = getRapid(project: project);

      expect(
        () async => rapid.pubAdd(
          packageName: 'non_existing_package',
          packages: ['package_a', 'package_b'],
        ),
        throwsA(isA<PackageNotFoundException>()),
      );
      verify(() => project.findByPackageName('non_existing_package')).called(1);
      verifyNever(() => project.findByCwd());
    });

    test(
      'throws PackageAtCwdNotFoundException when package is not found at current working directory',
      () {
        when(() => project.findByCwd()).thenThrow(Exception());
        final rapid = getRapid(project: project);

        expect(
          () async => rapid.pubAdd(
            packageName: null,
            packages: ['package_a', 'package_b'],
          ),
          throwsA(isA<PackageAtCwdNotFoundException>()),
        );
        verify(() => project.findByCwd()).called(1);
        verifyNever(() => project.findByPackageName(any()));
      },
    );

    group('given found package by name', () {
      late DartPackage package;

      setUp(() {
        package = MockDartPackage(
          packageName: 'example_package',
          path: 'example_package_path',
        );
        when(() => project.findByPackageName('example_package'))
            .thenReturn(package);
      });

      test(
        'adds dependencies using dart pub add',
        withMockEnv((manager) async {
          final (progress: progress, logger: logger) =
              setupLoggerWithoutGroup();
          final rapid = getRapid(project: project, tool: tool, logger: logger);

          await rapid.pubAdd(
            packageName: 'example_package',
            packages: ['package_a', 'package_b'],
          );

          verifyInOrder([
            () => logger.newLine(),
            () => logger.progress(
                'Running "dart pub add package_a package_b" in example_package'),
            () => manager.runDartPubAdd(
                  ['package_a', 'package_b'],
                  workingDirectory: 'example_package_path',
                ),
            () => progress.complete(),
            () => logger.newLine(),
            () => logger.commandSuccess('Added Dependencies!'),
          ]);
          verifyNoMoreInteractions(manager);
          verifyNoMoreInteractions(logger);
          verifyNoMoreInteractions(progress);
        }),
      );

      test(
        'when dart pub add fails run dart pub get',
        withMockEnv((manager) async {
          when(
            () => manager.run(
              ['dart', 'pub', 'add', 'package_a', 'package_b'],
              workingDirectory: any(named: 'workingDirectory'),
              runInShell: true,
              stderrEncoding: utf8,
              stdoutEncoding: utf8,
            ),
          ).thenAnswer((_) async => ProcessResult(0, 1, 'stdout', 'stderr'));
          final logger = MockRapidLogger();
          final rapid = getRapid(project: project, tool: tool, logger: logger);

          await rapid.pubAdd(
            packageName: 'example_package',
            packages: ['package_a', 'package_b'],
          );

          verifyInOrder([
            () => manager.runDartPubGet(
                  workingDirectory: 'example_package_path',
                ),
          ]);
        }),
      );

      test(
        'rebootstraps dependent packages',
        withMockEnv((manager) async {
          final dependentPackages = [
            FakeDartPackage(packageName: 'package_c'),
            FakeDartPackage(packageName: 'package_d'),
          ];
          when(() => project.dependentPackages(package))
              .thenReturn(dependentPackages);
          final (progress: progress, logger: logger) =
              setupLoggerWithoutGroup();
          final rapid = getRapid(project: project, tool: tool, logger: logger);

          await rapid.pubAdd(
            packageName: 'example_package',
            packages: ['package_a', 'package_b'],
          );

          verifyInOrder([
            () => logger.progress(
                'Running "melos bootstrap --scope package_c,package_d"'),
            () => manager.runMelosBootstrap(
                  ['package_c', 'package_d'],
                  workingDirectory: 'project_path',
                ),
            () => progress.complete(),
          ]);
        }),
      );

      test(
        'handles packages with empty constraints manually',
        withMockEnv((manager) async {
          final dependentPackages = [
            FakeDartPackage(packageName: 'package_c'),
            FakeDartPackage(packageName: 'package_d'),
          ];
          when(() => project.dependentPackages(package))
              .thenReturn(dependentPackages);
          final packagePubSpecFile = MockPubspecYamlFile();
          when(() => package.pubSpecFile).thenReturn(packagePubSpecFile);
          final (progress: progress, logger: logger) =
              setupLoggerWithoutGroup();
          final rapid = getRapid(project: project, tool: tool, logger: logger);

          await rapid.pubAdd(
            packageName: 'example_package',
            packages: ['package_a:', 'dev:package_b:'],
          );

          verifyInOrder([
            () => logger.newLine(),
            () => packagePubSpecFile.setDependency(
                  name: 'package_a',
                  dependency: HostedReference(VersionConstraint.empty),
                  dev: false,
                ),
            () => packagePubSpecFile.setDependency(
                  name: 'package_b',
                  dependency: HostedReference(VersionConstraint.empty),
                  dev: true,
                ),
            () => logger.progress(
                'Running "melos bootstrap --scope example_package,package_c,package_d"'),
            () => manager.runMelosBootstrap(
                  ['example_package', 'package_c', 'package_d'],
                  workingDirectory: 'project_path',
                ),
            () => progress.complete(),
          ]);
          verifyNever(
            () => logger.progress(
              'Running "dart pub add package_a package_b" in example_package',
            ),
          );
          verifyNever(
            () => manager.runDartPubAdd(
              ['package_a', 'package_b'],
              workingDirectory: 'example_package_path',
            ),
          );
        }),
      );

      group('and command group is active', () {
        setUp(() {
          when(() => commandGroup.isActive).thenReturn(true);
        });

        test(
          'marks dependent packages as need bootstrap',
          withMockEnv((manager) async {
            final dependentPackages = [
              FakeDartPackage(packageName: 'package_c'),
              FakeDartPackage(packageName: 'package_d'),
            ];
            when(() => project.dependentPackages(package))
                .thenReturn(dependentPackages);
            final logger = MockRapidLogger();
            final rapid =
                getRapid(project: project, tool: tool, logger: logger);

            await rapid.pubAdd(
              packageName: 'example_package',
              packages: ['package_a', 'package_b'],
            );

            verifyInOrder([
              () => tool.markAsNeedBootstrap(packages: dependentPackages),
            ]);
          }),
        );
      });
    });

    group('given found package by current working directory', () {
      late DartPackage package;

      setUp(() {
        package = MockDartPackage(
          packageName: 'example_package',
          path: 'example_package_path',
        );
        when(() => project.findByCwd()).thenReturn(package);
      });

      test(
        'adds dependencies using dart pub add',
        withMockEnv((manager) async {
          final (progress: progress, logger: logger) =
              setupLoggerWithoutGroup();
          final rapid = getRapid(project: project, tool: tool, logger: logger);

          await rapid.pubAdd(
            packageName: null,
            packages: ['package_a', 'package_b'],
          );

          verifyInOrder([
            () => logger.newLine(),
            () => logger.progress(
                'Running "dart pub add package_a package_b" in example_package'),
            () => manager.runDartPubAdd(
                  ['package_a', 'package_b'],
                  workingDirectory: 'example_package_path',
                ),
            () => progress.complete(),
            () => logger.newLine(),
            () => logger.commandSuccess('Added Dependencies!'),
          ]);
          verifyNoMoreInteractions(manager);
          verifyNoMoreInteractions(logger);
          verifyNoMoreInteractions(progress);
        }),
      );

      test(
        'when dart pub add fails run dart pub get',
        withMockEnv((manager) async {
          when(
            () => manager.run(
              ['dart', 'pub', 'add', 'package_a', 'package_b'],
              workingDirectory: any(named: 'workingDirectory'),
              runInShell: true,
              stderrEncoding: utf8,
              stdoutEncoding: utf8,
            ),
          ).thenAnswer((_) async => ProcessResult(0, 1, 'stdout', 'stderr'));
          final logger = MockRapidLogger();
          final rapid = getRapid(project: project, tool: tool, logger: logger);

          await rapid.pubAdd(
            packageName: null,
            packages: ['package_a', 'package_b'],
          );

          verifyInOrder([
            () => manager.runDartPubGet(
                  workingDirectory: 'example_package_path',
                ),
          ]);
        }),
      );

      test(
        'rebootstraps dependent packages',
        withMockEnv((manager) async {
          final dependentPackages = [
            FakeDartPackage(packageName: 'package_c'),
            FakeDartPackage(packageName: 'package_d'),
          ];
          when(() => project.dependentPackages(package))
              .thenReturn(dependentPackages);
          final (progress: progress, logger: logger) =
              setupLoggerWithoutGroup();
          final rapid = getRapid(project: project, tool: tool, logger: logger);

          await rapid.pubAdd(
            packageName: null,
            packages: ['package_a', 'package_b'],
          );

          verifyInOrder([
            () => logger.progress(
                'Running "melos bootstrap --scope package_c,package_d"'),
            () => manager.runMelosBootstrap(
                  ['package_c', 'package_d'],
                  workingDirectory: 'project_path',
                ),
            () => progress.complete(),
          ]);
        }),
      );

      test(
        'handles packages with empty constraints manually',
        withMockEnv((manager) async {
          final packagePubSpecFile = MockPubspecYamlFile();
          when(() => package.pubSpecFile).thenReturn(packagePubSpecFile);
          final logger = MockRapidLogger();
          final rapid = getRapid(project: project, tool: tool, logger: logger);

          await rapid.pubAdd(
            packageName: null,
            packages: ['package_a:', 'dev:package_b:'],
          );

          verifyInOrder([
            () => logger.newLine(),
            () => packagePubSpecFile.setDependency(
                  name: 'package_a',
                  dependency: HostedReference(VersionConstraint.empty),
                  dev: false,
                ),
            () => packagePubSpecFile.setDependency(
                  name: 'package_b',
                  dependency: HostedReference(VersionConstraint.empty),
                  dev: true,
                ),
          ]);
          verifyNever(
            () => logger.progress(
              'Running "dart pub add package_a package_b" in example_package',
            ),
          );
          verifyNever(
            () => manager.runDartPubAdd(
              ['package_a', 'package_b'],
              workingDirectory: 'example_package_path',
            ),
          );
        }),
      );

      group('and command group is active', () {
        setUp(() {
          when(() => commandGroup.isActive).thenReturn(true);
        });

        test(
          'marks dependent packages as need bootstrap',
          withMockEnv((manager) async {
            final dependentPackages = [
              FakeDartPackage(packageName: 'package_c'),
              FakeDartPackage(packageName: 'package_d'),
            ];
            when(() => project.dependentPackages(package))
                .thenReturn(dependentPackages);
            final logger = MockRapidLogger();
            final rapid =
                getRapid(project: project, tool: tool, logger: logger);

            await rapid.pubAdd(
              packageName: null,
              packages: ['package_a', 'package_b'],
            );

            verifyInOrder([
              () => tool.markAsNeedBootstrap(packages: dependentPackages),
            ]);
          }),
        );
      });
    });
  });

  group('pubGet', () {
    test(
      'throws PackageNotFoundException when package is not found by name',
      () {
        when(() => project.findByPackageName('non_existing_package'))
            .thenThrow(Exception());
        final rapid = getRapid(project: project);

        expect(
          () async => rapid.pubGet(
            packageName: 'non_existing_package',
          ),
          throwsA(isA<PackageNotFoundException>()),
        );
        verify(() => project.findByPackageName('non_existing_package'))
            .called(1);
        verifyNever(() => project.findByCwd());
      },
    );

    test(
      'throws PackageAtCwdNotFoundException when package is not found at current working directory',
      () {
        when(() => project.findByCwd()).thenThrow(Exception());
        final rapid = getRapid(project: project);

        expect(
          () async => rapid.pubGet(
            packageName: null,
          ),
          throwsA(isA<PackageAtCwdNotFoundException>()),
        );
        verify(() => project.findByCwd()).called(1);
        verifyNever(() => project.findByPackageName(any()));
      },
    );

    group('given found package by name', () {
      late DartPackage package;

      setUp(() {
        package = MockDartPackage(
          packageName: 'example_package',
          path: 'example_package_path',
        );
        when(() => project.findByPackageName('example_package'))
            .thenReturn(package);
      });

      test(
        'gets dependencies using dart pub get',
        withMockEnv((manager) async {
          final (progress: progress, logger: logger) =
              setupLoggerWithoutGroup();
          final rapid = getRapid(project: project, tool: tool, logger: logger);

          await rapid.pubGet(
            packageName: 'example_package',
          );

          verifyInOrder([
            () => logger.newLine(),
            () => manager.runDartPubGet(
                workingDirectory: 'example_package_path', dryRun: true),
            () => logger.progress('Running "dart pub get" in example_package'),
            () => manager.runDartPubGet(
                  workingDirectory: 'example_package_path',
                ),
            () => progress.complete(),
            () => logger.newLine(),
            () => logger.commandSuccess('Got Dependencies!'),
          ]);
          verifyNoMoreInteractions(manager);
          verifyNoMoreInteractions(logger);
          verifyNoMoreInteractions(progress);
        }),
      );

      test(
        'rebootstraps dependent packages',
        withMockEnv((manager) async {
          final dependentPackages = [
            FakeDartPackage(packageName: 'package_c'),
            FakeDartPackage(packageName: 'package_d'),
          ];
          when(() => project.dependentPackages(package))
              .thenReturn(dependentPackages);
          final (progress: progress, logger: logger) =
              setupLoggerWithoutGroup();
          final rapid = getRapid(project: project, tool: tool, logger: logger);

          await rapid.pubGet(
            packageName: 'example_package',
          );

          verifyInOrder([
            () => logger.progress(
                'Running "melos bootstrap --scope package_c,package_d"'),
            () => manager.runMelosBootstrap(
                  ['package_c', 'package_d'],
                  workingDirectory: 'project_path',
                ),
            () => progress.complete(),
          ]);
        }),
      );

      test(
        'does nothing when pub get would not change dependencies',
        withMockEnv((manager) async {
          when(
            () => manager.runDartPubGet(
                workingDirectory: 'example_package_path', dryRun: true),
          ).thenAnswer(
            (_) async =>
                ProcessResult(0, 0, 'No dependencies would change.', ''),
          );
          final logger = MockRapidLogger();
          final rapid = getRapid(project: project, tool: tool, logger: logger);

          await rapid.pubGet(
            packageName: 'example_package',
          );

          verifyInOrder([
            () => logger.newLine(),
            () => manager.runDartPubGet(
                workingDirectory: 'example_package_path', dryRun: true),
            () => logger.commandSuccess('Got Dependencies!'),
          ]);
          verifyNoMoreInteractions(manager);
          verifyNoMoreInteractions(logger);
        }),
      );

      group('and command group is active', () {
        setUp(() {
          when(() => commandGroup.isActive).thenReturn(true);
        });

        test(
          'marks package and dependent packages as need bootstrap',
          withMockEnv((manager) async {
            final dependentPackages = [
              FakeDartPackage(packageName: 'package_c'),
              FakeDartPackage(packageName: 'package_d'),
            ];
            when(() => project.dependentPackages(package))
                .thenReturn(dependentPackages);
            final logger = MockRapidLogger();
            final rapid =
                getRapid(project: project, tool: tool, logger: logger);

            await rapid.pubGet(
              packageName: 'example_package',
            );

            verifyInOrder([
              () => tool.markAsNeedBootstrap(packages: dependentPackages),
            ]);
          }),
        );
      });
    });

    group('given found package by current working directory', () {
      late DartPackage package;

      setUp(() {
        package = MockDartPackage(
          packageName: 'example_package',
          path: 'example_package_path',
        );
        when(() => project.findByCwd()).thenReturn(package);
      });

      test(
        'gets dependencies using dart pub get',
        withMockEnv((manager) async {
          final (progress: progress, logger: logger) =
              setupLoggerWithoutGroup();
          final rapid = getRapid(project: project, tool: tool, logger: logger);

          await rapid.pubGet(
            packageName: null,
          );

          verifyInOrder([
            () => logger.newLine(),
            () => manager.runDartPubGet(
                workingDirectory: 'example_package_path', dryRun: true),
            () => logger.progress('Running "dart pub get" in example_package'),
            () => manager.runDartPubGet(
                  workingDirectory: 'example_package_path',
                ),
            () => progress.complete(),
            () => logger.newLine(),
            () => logger.commandSuccess('Got Dependencies!'),
          ]);
          verifyNoMoreInteractions(manager);
          verifyNoMoreInteractions(logger);
          verifyNoMoreInteractions(progress);
        }),
      );

      test(
        'rebootstraps dependent packages',
        withMockEnv((manager) async {
          final dependentPackages = [
            FakeDartPackage(packageName: 'package_c'),
            FakeDartPackage(packageName: 'package_d'),
          ];
          when(() => project.dependentPackages(package))
              .thenReturn(dependentPackages);
          final (progress: progress, logger: logger) =
              setupLoggerWithoutGroup();
          final rapid = getRapid(project: project, tool: tool, logger: logger);

          await rapid.pubGet(
            packageName: null,
          );

          verifyInOrder([
            () => logger.progress(
                'Running "melos bootstrap --scope package_c,package_d"'),
            () => manager.runMelosBootstrap(
                  ['package_c', 'package_d'],
                  workingDirectory: 'project_path',
                ),
            () => progress.complete(),
          ]);
        }),
      );

      test(
        'does nothing when pub get would not change dependencies',
        withMockEnv((manager) async {
          when(
            () => manager.runDartPubGet(
                workingDirectory: 'example_package_path', dryRun: true),
          ).thenAnswer(
            (_) async =>
                ProcessResult(0, 0, 'No dependencies would change.', ''),
          );
          final logger = MockRapidLogger();
          final rapid = getRapid(project: project, tool: tool, logger: logger);

          await rapid.pubGet(
            packageName: null,
          );

          verifyInOrder([
            () => logger.newLine(),
            () => manager.runDartPubGet(
                workingDirectory: 'example_package_path', dryRun: true),
            () => logger.commandSuccess('Got Dependencies!'),
          ]);
          verifyNoMoreInteractions(manager);
          verifyNoMoreInteractions(logger);
        }),
      );

      group('and command group is active', () {
        setUp(() {
          when(() => commandGroup.isActive).thenReturn(true);
        });

        test(
          'marks package and dependent packages as need bootstrap',
          withMockEnv((manager) async {
            final dependentPackages = [
              FakeDartPackage(packageName: 'package_c'),
              FakeDartPackage(packageName: 'package_d'),
            ];
            when(() => project.dependentPackages(package))
                .thenReturn(dependentPackages);
            final logger = MockRapidLogger();
            final rapid =
                getRapid(project: project, tool: tool, logger: logger);

            await rapid.pubGet(
              packageName: null,
            );

            verifyInOrder([
              () => tool.markAsNeedBootstrap(packages: dependentPackages),
            ]);
          }),
        );
      });
    });
  });

  group('pubRemove', () {
    test(
      'throws PackageNotFoundException when package is not found by name',
      () {
        when(() => project.findByPackageName('non_existing_package'))
            .thenThrow(Exception());
        final rapid = getRapid(project: project);

        expect(
          () async => rapid.pubRemove(
            packageName: 'non_existing_package',
            packages: ['package_a', 'package_b'],
          ),
          throwsA(isA<PackageNotFoundException>()),
        );
        verify(() => project.findByPackageName('non_existing_package'))
            .called(1);
        verifyNever(() => project.findByCwd());
      },
    );

    test(
      'throws PackageAtCwdNotFoundException when package is not found at current working directory',
      () {
        when(() => project.findByCwd()).thenThrow(Exception());
        final rapid = getRapid(project: project);

        expect(
          () async => rapid.pubRemove(
            packageName: null,
            packages: ['package_a', 'package_b'],
          ),
          throwsA(isA<PackageAtCwdNotFoundException>()),
        );
        verify(() => project.findByCwd()).called(1);
        verifyNever(() => project.findByPackageName(any()));
      },
    );

    group('given found package by name', () {
      late DartPackage package;

      setUp(() {
        package = MockDartPackage(
          packageName: 'example_package',
          path: 'example_package_path',
        );
        when(() => project.findByPackageName('example_package'))
            .thenReturn(package);
      });

      test(
        'removes dependencies using dart pub remove',
        withMockEnv((manager) async {
          final (progress: progress, logger: logger) =
              setupLoggerWithoutGroup();
          final rapid = getRapid(project: project, tool: tool, logger: logger);

          await rapid.pubRemove(
            packageName: 'example_package',
            packages: ['package_a', 'package_b'],
          );

          verifyInOrder([
            () => logger.newLine(),
            () => logger.progress(
                'Running "dart pub remove package_a package_b" in example_package'),
            () => manager.runDartPubRemove(
                  ['package_a', 'package_b'],
                  workingDirectory: 'example_package_path',
                ),
            () => progress.complete(),
            () => logger.newLine(),
            () => logger.commandSuccess('Removed Dependencies!'),
          ]);
          verifyNoMoreInteractions(manager);
          verifyNoMoreInteractions(logger);
          verifyNoMoreInteractions(progress);
        }),
      );

      test(
        'rebootstraps dependent packages',
        withMockEnv((manager) async {
          final dependentPackages = [
            FakeDartPackage(packageName: 'package_c'),
            FakeDartPackage(packageName: 'package_d'),
          ];
          when(() => project.dependentPackages(package))
              .thenReturn(dependentPackages);
          final (progress: progress, logger: logger) =
              setupLoggerWithoutGroup();
          final rapid = getRapid(project: project, tool: tool, logger: logger);

          await rapid.pubRemove(
            packageName: 'example_package',
            packages: ['package_a', 'package_b'],
          );

          verifyInOrder([
            () => logger.progress(
                'Running "melos bootstrap --scope package_c,package_d"'),
            () => manager.runMelosBootstrap(
                  ['package_c', 'package_d'],
                  workingDirectory: 'project_path',
                ),
            () => progress.complete(),
          ]);
        }),
      );

      group('and command group is active', () {
        setUp(() {
          when(() => commandGroup.isActive).thenReturn(true);
        });

        test(
          'marks dependent packages as need bootstrap',
          withMockEnv((manager) async {
            final dependentPackages = [
              FakeDartPackage(packageName: 'package_c'),
              FakeDartPackage(packageName: 'package_d'),
            ];
            when(() => project.dependentPackages(package))
                .thenReturn(dependentPackages);
            final logger = MockRapidLogger();
            final rapid =
                getRapid(project: project, tool: tool, logger: logger);

            await rapid.pubRemove(
              packageName: 'example_package',
              packages: ['package_a', 'package_b'],
            );

            verifyInOrder([
              () => tool.markAsNeedBootstrap(packages: dependentPackages),
            ]);
          }),
        );
      });
    });

    group('given found package by current working directory', () {
      late DartPackage package;

      setUp(() {
        package = MockDartPackage(
          packageName: 'example_package',
          path: 'example_package_path',
        );
        when(() => project.findByCwd()).thenReturn(package);
      });

      test(
        'removes dependencies using dart pub remove',
        withMockEnv((manager) async {
          final (progress: progress, logger: logger) =
              setupLoggerWithoutGroup();
          final rapid = getRapid(project: project, tool: tool, logger: logger);

          await rapid.pubRemove(
            packageName: null,
            packages: ['package_a', 'package_b'],
          );

          verifyInOrder([
            () => logger.newLine(),
            () => logger.progress(
                'Running "dart pub remove package_a package_b" in example_package'),
            () => manager.runDartPubRemove(
                  ['package_a', 'package_b'],
                  workingDirectory: 'example_package_path',
                ),
            () => progress.complete(),
            () => logger.newLine(),
            () => logger.commandSuccess('Removed Dependencies!'),
          ]);
          verifyNoMoreInteractions(manager);
          verifyNoMoreInteractions(logger);
          verifyNoMoreInteractions(progress);
        }),
      );

      test(
        'rebootstraps dependent packages',
        withMockEnv((manager) async {
          final dependentPackages = [
            FakeDartPackage(packageName: 'package_c'),
            FakeDartPackage(packageName: 'package_d'),
          ];
          when(() => project.dependentPackages(package))
              .thenReturn(dependentPackages);
          final (progress: progress, logger: logger) =
              setupLoggerWithoutGroup();
          final rapid = getRapid(project: project, tool: tool, logger: logger);

          await rapid.pubRemove(
            packageName: null,
            packages: ['package_a', 'package_b'],
          );

          verifyInOrder([
            () => logger.progress(
                'Running "melos bootstrap --scope package_c,package_d"'),
            () => manager.runMelosBootstrap(
                  ['package_c', 'package_d'],
                  workingDirectory: 'project_path',
                ),
            () => progress.complete(),
          ]);
        }),
      );

      group('and command group is active', () {
        setUp(() {
          when(() => commandGroup.isActive).thenReturn(true);
        });

        test(
          'marks dependent packages as need bootstrap',
          withMockEnv((manager) async {
            final dependentPackages = [
              FakeDartPackage(packageName: 'package_c'),
              FakeDartPackage(packageName: 'package_d'),
            ];
            when(() => project.dependentPackages(package))
                .thenReturn(dependentPackages);
            final logger = MockRapidLogger();
            final rapid =
                getRapid(project: project, tool: tool, logger: logger);

            await rapid.pubRemove(
              packageName: null,
              packages: ['package_a', 'package_b'],
            );

            verifyInOrder([
              () => tool.markAsNeedBootstrap(packages: dependentPackages),
            ]);
          }),
        );
      });
    });
  });
}
