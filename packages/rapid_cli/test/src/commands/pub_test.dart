import 'dart:convert';

import 'package:mocktail/mocktail.dart';
import 'package:rapid_cli/src/commands/runner.dart';
import 'package:rapid_cli/src/io.dart';
import 'package:test/test.dart';

import '../invocations.dart';
import '../mock_env.dart';
import '../mocks.dart';
import '../utils.dart';

// TODO maybe test package resolving better (more neat)

void main() {
  setUpAll(() {
    registerFallbackValues();
  });

  group('pubAdd', () {
    test('finds package by package name', () async {
      final project = getProject();
      when(() => project.findByPackageName('example_package'))
          .thenReturn(FakeDartPackage());
      final rapid = getRapid(project: project);

      await withMockProcessManager(
        () async => rapid.pubAdd(
          packageName: 'example_package',
          packages: ['package_a', 'package_b'],
        ),
      );

      verify(() => project.findByPackageName('example_package')).called(1);
      verifyNever(() => project.findByCwd());
    });

    test('finds package by current working directory', () async {
      final project = getProject();
      when(() => project.findByCwd()).thenReturn(FakeDartPackage());
      final rapid = getRapid(project: project);

      await withMockProcessManager(
        () async => rapid.pubAdd(
          packageName: null,
          packages: ['package_a', 'package_b'],
        ),
      );

      verifyNever(() => project.findByPackageName(any()));
      verify(() => project.findByCwd()).called(1);
    });

    test('throws PackageNotFoundException when package is not found by name',
        () {
      final project = getProject();
      when(() => project.findByPackageName('non_existing_package'))
          .thenThrow(Exception());
      final rapid = getRapid(project: project);

      expect(
        () async => withMockProcessManager(
          () async => rapid.pubAdd(
            packageName: 'non_existing_package',
            packages: ['package_a', 'package_b'],
          ),
        ),
        throwsA(isA<PackageNotFoundException>()),
      );
      verify(() => project.findByPackageName('non_existing_package')).called(1);
      verifyNever(() => project.findByCwd());
    });

    test(
        'throws PackageAtCwdNotFoundException when package is not found at current working directory',
        () {
      final project = getProject();
      when(() => project.findByCwd()).thenThrow(Exception());
      final rapid = getRapid(project: project);

      expect(
        () async => withMockProcessManager(
          () async => rapid.pubAdd(
            packageName: null,
            packages: ['package_a', 'package_b'],
          ),
        ),
        throwsA(isA<PackageAtCwdNotFoundException>()),
      );
      verify(() => project.findByCwd()).called(1);
      verifyNever(() => project.findByPackageName(any()));
    });

    test('adds dependencies using flutter pub add', () async {
      final manager = MockProcessManager();
      final package = FakeDartPackage(packageName: 'example_package');
      final dependentPackages = [
        FakeDartPackage(packageName: 'package_c'),
        FakeDartPackage(packageName: 'package_d'),
      ];
      final project = getProject();
      when(() => project.dependentPackages(package))
          .thenReturn(dependentPackages);
      when(() => project.findByPackageName('example_package'))
          .thenReturn(package);
      final logger = MockRapidLogger();
      final rapid = getRapid(project: project, logger: logger);

      await withMockProcessManager(
        () async => rapid.pubAdd(
          packageName: 'example_package',
          packages: ['package_a', 'package_b'],
        ),
        manager: manager,
      );
      verifyInOrder([
        () => logger.newLine(),
        ...flutterPubAddTask(
          manager,
          package: package,
          dependenciesToAdd: ['package_a', 'package_b'],
        ),
        ...melosBootstrapTask(manager, scope: dependentPackages),
        () => logger.newLine(),
        () => logger.commandSuccess('Added Dependencies!'),
      ]);
    });

    test('handles packages with empty constraints manually', () async {
      final manager = MockProcessManager();
      final pubSpecFile = MockPubspecYamlFile();
      final package = FakeDartPackage(
        packageName: 'example_package',
        pubSpecFile: pubSpecFile,
      );
      final dependentPackages = [
        FakeDartPackage(packageName: 'package_c'),
        FakeDartPackage(packageName: 'package_d'),
      ];
      final project = getProject();
      when(() => project.dependentPackages(package))
          .thenReturn(dependentPackages);
      when(() => project.findByPackageName('example_package'))
          .thenReturn(package);
      final logger = MockRapidLogger();
      final rapid = getRapid(project: project, logger: logger);

      await withMockProcessManager(
        () async => rapid.pubAdd(
          packageName: 'example_package',
          packages: ['package_a:', 'dev:package_b:'],
        ),
        manager: manager,
      );

      verifyInOrder([
        () => logger.newLine(),
        () => pubSpecFile.setDependency(
              name: 'package_a',
              dependency: HostedReference(VersionConstraint.empty),
              dev: false,
            ),
        () => pubSpecFile.setDependency(
              name: 'package_b',
              dependency: HostedReference(VersionConstraint.empty),
              dev: true,
            ),
        ...melosBootstrapTask(manager, scope: dependentPackages),
        () => logger.newLine(),
        () => logger.commandSuccess('Added Dependencies!'),
      ]);
      verifyNeverMulti(
        flutterPubAddTask(
          manager,
          package: package,
          dependenciesToAdd: ['package_a', 'dev:package_b'],
        ),
      );
    });
  });

  group('pubGet', () {
    test('finds package by package name', () async {
      final project = getProject();
      when(() => project.findByPackageName('example_package'))
          .thenReturn(FakeDartPackage());
      final rapid = getRapid(project: project);

      await withMockProcessManager(
        () async => rapid.pubGet(
          packageName: 'example_package',
        ),
      );

      verify(() => project.findByPackageName('example_package')).called(1);
      verifyNever(() => project.findByCwd());
    });

    test('finds package by current working directory', () async {
      final project = getProject();
      when(() => project.findByCwd()).thenReturn(FakeDartPackage());
      final rapid = getRapid(project: project);

      await withMockProcessManager(
        () async => rapid.pubGet(
          packageName: null,
        ),
      );

      verifyNever(() => project.findByPackageName(any()));
      verify(() => project.findByCwd()).called(1);
    });

    test('throws PackageNotFoundException when package is not found by name',
        () {
      final project = getProject();
      when(() => project.findByPackageName('non_existing_package'))
          .thenThrow(Exception());
      final rapid = getRapid(project: project);

      expect(
        () async => withMockProcessManager(
          () async => rapid.pubGet(
            packageName: 'non_existing_package',
          ),
        ),
        throwsA(isA<PackageNotFoundException>()),
      );
      verify(() => project.findByPackageName('non_existing_package')).called(1);
      verifyNever(() => project.findByCwd());
    });

    test(
        'throws PackageAtCwdNotFoundException when package is not found at current working directory',
        () {
      final project = getProject();
      when(() => project.findByCwd()).thenThrow(Exception());
      final rapid = getRapid(project: project);

      expect(
        () async => withMockProcessManager(
          () async => rapid.pubGet(
            packageName: null,
          ),
        ),
        throwsA(isA<PackageAtCwdNotFoundException>()),
      );
      verify(() => project.findByCwd()).called(1);
      verifyNever(() => project.findByPackageName(any()));
    });

    test('completes', () async {
      final package = FakeDartPackage();
      final manager = MockProcessManager();
      when(
        () => manager.run(
          [
            'flutter',
            'pub',
            'get',
            '--dry-run',
          ],
          workingDirectory: package.path,
          runInShell: true,
          stderrEncoding: utf8,
          stdoutEncoding: utf8,
        ),
      ).thenAnswer(
        (_) async => ProcessResult(0, 0, 'stdout', 'stderr'),
      );
      final dependentPackages = [
        FakeDartPackage(packageName: 'package_c'),
        FakeDartPackage(packageName: 'package_d'),
      ];
      final project = getProject();
      when(() => project.dependentPackages(package))
          .thenReturn(dependentPackages);
      when(() => project.findByPackageName('example_package'))
          .thenReturn(package);
      final logger = MockRapidLogger();
      final rapid = getRapid(project: project, logger: logger);

      await withMockProcessManager(
        () async => rapid.pubGet(packageName: 'example_package'),
        manager: manager,
      );

      verifyInOrder([
        () => logger.newLine(),
        ...flutterPubGet(manager, package: package, dryRun: true),
        ...melosBootstrapTask(manager, scope: dependentPackages),
        () => logger.newLine(),
        () => logger.commandSuccess('Got Dependencies!'),
      ]);
    });

    test('skips melos bootstrap if no dependency changes', () async {
      final package = FakeDartPackage();
      final manager = MockProcessManager();
      when(
        () => manager.run(
          [
            'flutter',
            'pub',
            'get',
            '--dry-run',
          ],
          workingDirectory: package.path,
          runInShell: true,
          stderrEncoding: utf8,
          stdoutEncoding: utf8,
        ),
      ).thenAnswer(
        (_) async =>
            ProcessResult(0, 0, 'No dependencies would change.', 'stderr'),
      );
      final dependentPackages = [
        FakeDartPackage(packageName: 'package_c'),
        FakeDartPackage(packageName: 'package_d'),
      ];
      final project = getProject();
      when(() => project.dependentPackages(package))
          .thenReturn(dependentPackages);
      when(() => project.findByPackageName('example_package'))
          .thenReturn(package);
      final logger = MockRapidLogger();
      final rapid = getRapid(project: project, logger: logger);

      await withMockProcessManager(
        () async => rapid.pubGet(packageName: 'example_package'),
        manager: manager,
      );

      verifyInOrder([
        () => logger.newLine(),
        ...flutterPubGet(manager, package: package, dryRun: true),
        () => logger.commandSuccess('Got Dependencies!'),
      ]);
      verifyNeverMulti(melosBootstrapTask(manager, scope: dependentPackages));
    });
  });

  group('pubRemove', () {
    test('finds package by package name', () async {
      final project = getProject();
      when(() => project.findByPackageName('example_package'))
          .thenReturn(FakeDartPackage());
      final rapid = getRapid(project: project);

      await withMockProcessManager(
        () async => rapid.pubRemove(
          packageName: 'example_package',
          packages: ['package_a', 'package_b'],
        ),
      );

      verify(() => project.findByPackageName('example_package')).called(1);
      verifyNever(() => project.findByCwd());
    });

    test('finds package by current working directory', () async {
      final project = getProject();
      when(() => project.findByCwd()).thenReturn(FakeDartPackage());
      final rapid = getRapid(project: project);

      await withMockProcessManager(
        () async => rapid.pubRemove(
          packageName: null,
          packages: ['package_a', 'package_b'],
        ),
      );

      verifyNever(() => project.findByPackageName(any()));
      verify(() => project.findByCwd()).called(1);
    });

    test('throws PackageNotFoundException when package is not found by name',
        () {
      final project = getProject();
      when(() => project.findByPackageName('non_existing_package'))
          .thenThrow(Exception());
      final rapid = getRapid(project: project);

      expect(
        () async => withMockProcessManager(
          () async => rapid.pubRemove(
            packageName: 'non_existing_package',
            packages: ['package_a', 'package_b'],
          ),
        ),
        throwsA(isA<PackageNotFoundException>()),
      );
      verify(() => project.findByPackageName('non_existing_package')).called(1);
      verifyNever(() => project.findByCwd());
    });

    test(
        'throws PackageAtCwdNotFoundException when package is not found at current working directory',
        () {
      final project = getProject();
      when(() => project.findByCwd()).thenThrow(Exception());
      final rapid = getRapid(project: project);

      expect(
        () async => withMockProcessManager(
          () async => rapid.pubRemove(
            packageName: null,
            packages: ['package_a', 'package_b'],
          ),
        ),
        throwsA(isA<PackageAtCwdNotFoundException>()),
      );
      verify(() => project.findByCwd()).called(1);
      verifyNever(() => project.findByPackageName(any()));
    });

    test('removes dependencies using flutter pub remove', () async {
      final manager = MockProcessManager();
      final package = FakeDartPackage();
      final dependentPackages = [
        FakeDartPackage(packageName: 'package_c'),
        FakeDartPackage(packageName: 'package_d'),
      ];
      final project = getProject();
      when(() => project.dependentPackages(package))
          .thenReturn(dependentPackages);
      when(() => project.findByPackageName('example_package'))
          .thenReturn(package);
      final logger = MockRapidLogger();
      final rapid = getRapid(project: project, logger: logger);

      await withMockProcessManager(
        () async => rapid.pubRemove(
          packageName: 'example_package',
          packages: ['package_a', 'package_b'],
        ),
        manager: manager,
      );

      verifyInOrder([
        () => logger.newLine(),
        ...flutterPubRemoveTask(
          manager,
          package: package,
          packagesToRemove: ['package_a', 'package_b'],
        ),
        ...melosBootstrapTask(manager, scope: dependentPackages),
        () => logger.newLine(),
        () => logger.commandSuccess('Removed Dependencies!'),
      ]);
    });
  });
}
