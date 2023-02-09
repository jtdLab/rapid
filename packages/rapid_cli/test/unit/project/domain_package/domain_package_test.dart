import 'dart:io';

import 'package:mason/mason.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rapid_cli/src/cli/cli.dart';
import 'package:rapid_cli/src/core/generator_builder.dart';
import 'package:rapid_cli/src/project/domain_package/domain_package.dart';
import 'package:rapid_cli/src/project/project.dart';
import 'package:test/test.dart';

import '../../common.dart';
import '../../mocks.dart';

DomainPackage _getDomainPackage({
  required Project project,
  GeneratorBuilder? generator,
}) {
  return DomainPackage(
    project: project,
    generator: generator ?? (_) async => getMasonGenerator(),
  );
}

Entity _getEntity({
  required String name,
  required String dir,
  DomainPackage? domainPackage,
  DartFormatFixCommand? dartFormatFix,
  GeneratorBuilder? generator,
}) {
  return Entity(
    name: name,
    dir: dir,
    domainPackage: domainPackage ?? getDomainPackage(),
    dartFormatFix: dartFormatFix ?? getDartFormatFix().call,
    generator: generator ?? (_) async => getMasonGenerator(),
  );
}

ServiceInterface _getServiceInterface({
  required String name,
  required String dir,
  DomainPackage? domainPackage,
  DartFormatFixCommand? dartFormatFix,
  GeneratorBuilder? generator,
}) {
  return ServiceInterface(
    name: name,
    dir: dir,
    domainPackage: domainPackage ?? getDomainPackage(),
    dartFormatFix: dartFormatFix ?? getDartFormatFix().call,
    generator: generator ?? (_) async => getMasonGenerator(),
  );
}

ValueObject _getValueObject({
  required String name,
  required String dir,
  DomainPackage? domainPackage,
  FlutterPubRunBuildRunnerBuildDeleteConflictingOutputsCommand?
      flutterPubRunBuildRunnerBuildDeleteConflictingOutputs,
  DartFormatFixCommand? dartFormatFix,
  GeneratorBuilder? generator,
}) {
  return ValueObject(
    name: name,
    dir: dir,
    domainPackage: domainPackage ?? getDomainPackage(),
    flutterPubRunBuildRunnerBuildDeleteConflictingOutputs:
        flutterPubRunBuildRunnerBuildDeleteConflictingOutputs ??
            getFlutterPubRunBuildRunnerBuildDeleteConflictingOutputs().call,
    dartFormatFix: dartFormatFix ?? getDartFormatFix().call,
    generator: generator ?? (_) async => getMasonGenerator(),
  );
}

void main() {
  group('DomainPackage', () {
    setUpAll(() {
      registerFallbackValue(FakeDirectoryGeneratorTarget());
    });

    test('.path', () {
      // Arrange
      final project = getProject();
      when(() => project.path).thenReturn('project/path');
      when(() => project.name()).thenReturn('my_project');
      final domainPackage = _getDomainPackage(project: project);

      // Act + Assert
      expect(
        domainPackage.path,
        'project/path/packages/my_project/my_project_domain',
      );
    });

    group('.create()', () {
      test(
        'completes successfully with correct output',
        withTempDir(() async {
          // Arrange
          final project = getProject();
          when(() => project.path).thenReturn('project/path');
          when(() => project.name()).thenReturn('my_project');
          final generator = getMasonGenerator();
          final domainPackage = _getDomainPackage(
            project: project,
            generator: (_) async => generator,
          );

          // Act
          final logger = FakeLogger();
          await domainPackage.create(
            logger: logger,
          );

          // Assert
          verify(
            () => generator.generate(
              any(
                that: isA<DirectoryGeneratorTarget>().having(
                  (g) => g.dir.path,
                  'dir',
                  'project/path/packages/my_project/my_project_domain',
                ),
              ),
              vars: <String, dynamic>{
                'project_name': 'my_project',
              },
              logger: logger,
            ),
          ).called(1);
        }),
      );
    });
  });

  group('Entity', () {
    setUpAll(() {
      registerFallbackValue(FakeLogger());
      registerFallbackValue(FakeDirectoryGeneratorTarget());
    });

    test('.name', () {
      // Arrange
      final entity = _getEntity(name: 'my_entity', dir: '.');

      // Act + Assert
      expect(entity.name, 'my_entity');
    });

    test('.dir', () {
      // Arrange
      final entity = _getEntity(name: 'my_entity', dir: 'entity/path');

      // Act + Assert
      expect(entity.dir, 'entity/path');
    });

    test('.domainPackage', () {
      // Arrange
      final domainPackage = getDomainPackage();
      final entity = _getEntity(
        name: 'my_entity',
        dir: '.',
        domainPackage: domainPackage,
      );

      // Act + Assert
      expect(entity.domainPackage, domainPackage);
    });

    group('create', () {
      test(
        'completes successfully with correct output',
        withTempDir(() async {
          // Arrange
          final project = getProject();
          when(() => project.name()).thenReturn('my_project');
          final domainPackage = getDomainPackage();
          when(() => domainPackage.path).thenReturn('domain_package/path');
          when(() => domainPackage.project).thenReturn(project);
          final dartFormatFix = getDartFormatFix();
          final generator = getMasonGenerator();
          final entity = _getEntity(
            name: 'my_entity',
            dir: 'entity/path',
            domainPackage: domainPackage,
            dartFormatFix: dartFormatFix,
            generator: (_) async => generator,
          );

          // Act
          final logger = FakeLogger();
          await entity.create(
            logger: logger,
          );

          // Assert
          verify(
            () => generator.generate(
              any(
                that: isA<DirectoryGeneratorTarget>().having(
                  (g) => g.dir.path,
                  'dir',
                  'domain_package/path',
                ),
              ),
              vars: <String, dynamic>{
                'project_name': 'my_project',
                'name': 'my_entity',
                'output_dir': 'entity/path',
              },
              logger: logger,
            ),
          ).called(1);
          verify(
            () => dartFormatFix(cwd: 'domain_package/path', logger: logger),
          ).called(1);
        }),
      );
    });

    group('.delete()', () {
      test(
        'deletes all related files',
        withTempDir(() async {
          // Arrange
          final domainPackage = getDomainPackage();
          when(() => domainPackage.path).thenReturn('domain_package/path');
          final entity = _getEntity(
            name: 'Cool',
            dir: '.',
            domainPackage: domainPackage,
          );
          final entityDir = Directory('domain_package/path/lib/cool')
            ..createSync(recursive: true);
          final entityTestDir = Directory('domain_package/path/test/cool')
            ..createSync(recursive: true);

          // Act
          final logger = FakeLogger();
          entity.delete(logger: logger);

          // Assert
          expect(entityDir.existsSync(), false);
          expect(entityTestDir.existsSync(), false);
        }),
      );
    });
  });

  group('ServiceInterface', () {
    setUpAll(() {
      registerFallbackValue(FakeLogger());
      registerFallbackValue(FakeDirectoryGeneratorTarget());
    });

    test('.name', () {
      // Arrange
      final serviceInterface = _getServiceInterface(
        name: 'my_service_interface',
        dir: '.',
      );

      // Act + Assert
      expect(serviceInterface.name, 'my_service_interface');
    });

    test('.dir', () {
      // Arrange
      final serviceInterface = _getEntity(
        name: 'my_service_interface',
        dir: 'service_interface/path',
      );

      // Act + Assert
      expect(serviceInterface.dir, 'service_interface/path');
    });

    test('.domainPackage', () {
      // Arrange
      final domainPackage = getDomainPackage();
      final serviceInterface = _getEntity(
        name: 'my_service_interface',
        dir: '.',
        domainPackage: domainPackage,
      );

      // Act + Assert
      expect(serviceInterface.domainPackage, domainPackage);
    });

    group('create', () {
      test(
        'completes successfully with correct output',
        withTempDir(() async {
          // Arrange
          final project = getProject();
          when(() => project.name()).thenReturn('my_project');
          final domainPackage = getDomainPackage();
          when(() => domainPackage.path).thenReturn('domain_package/path');
          when(() => domainPackage.project).thenReturn(project);
          final dartFormatFix = getDartFormatFix();
          final generator = getMasonGenerator();
          final serviceInterface = _getEntity(
            name: 'my_service_interface',
            dir: 'service_interface/path',
            domainPackage: domainPackage,
            dartFormatFix: dartFormatFix,
            generator: (_) async => generator,
          );

          // Act
          final logger = FakeLogger();
          await serviceInterface.create(
            logger: logger,
          );

          // Assert
          verify(
            () => generator.generate(
              any(
                that: isA<DirectoryGeneratorTarget>().having(
                  (g) => g.dir.path,
                  'dir',
                  'domain_package/path',
                ),
              ),
              vars: <String, dynamic>{
                'project_name': 'my_project',
                'name': 'my_service_interface',
                'output_dir': 'service_interface/path',
              },
              logger: logger,
            ),
          ).called(1);
          verify(
            () => dartFormatFix(cwd: 'domain_package/path', logger: logger),
          ).called(1);
        }),
      );
    });

    group('.delete()', () {
      test(
        'deletes all related files',
        withTempDir(() async {
          // Arrange
          final domainPackage = getDomainPackage();
          when(() => domainPackage.path).thenReturn('domain_package/path');
          final serviceInterface = _getServiceInterface(
            name: 'Cool',
            dir: '.',
            domainPackage: domainPackage,
          );
          final serviceInterfaceDir = Directory('domain_package/path/lib/cool')
            ..createSync(recursive: true);

          // Act
          final logger = FakeLogger();
          serviceInterface.delete(logger: logger);

          // Assert
          expect(serviceInterfaceDir.existsSync(), false);
        }),
      );
    });
  });

  group('ValueObject', () {
    setUpAll(() {
      registerFallbackValue(FakeLogger());
      registerFallbackValue(FakeDirectoryGeneratorTarget());
    });

    test('.name', () {
      // Arrange
      final valueObject = _getValueObject(
        name: 'my_value_object',
        dir: '.',
      );

      // Act + Assert
      expect(valueObject.name, 'my_value_object');
    });

    test('.dir', () {
      // Arrange
      final valueObject = _getValueObject(
        name: 'my_value_object',
        dir: 'value_object/path',
      );

      // Act + Assert
      expect(valueObject.dir, 'value_object/path');
    });

    test('.domainPackage', () {
      // Arrange
      final domainPackage = getDomainPackage();
      final valueObject = _getValueObject(
        name: 'my_value_object',
        dir: '.',
        domainPackage: domainPackage,
      );

      // Act + Assert
      expect(valueObject.domainPackage, domainPackage);
    });

    group('create', () {
      test(
        'completes successfully with correct output',
        withTempDir(() async {
          // Arrange
          final project = getProject();
          when(() => project.name()).thenReturn('my_project');
          final domainPackage = getDomainPackage();
          when(() => domainPackage.path).thenReturn('domain_package/path');
          when(() => domainPackage.project).thenReturn(project);
          final flutterPubRunBuildRunnerBuildDeleteConflictingOutputs =
              getFlutterPubRunBuildRunnerBuildDeleteConflictingOutputs();
          final dartFormatFix = getDartFormatFix();
          final generator = getMasonGenerator();
          final valueObject = _getValueObject(
            name: 'my_value_object',
            dir: 'value_object/path',
            domainPackage: domainPackage,
            flutterPubRunBuildRunnerBuildDeleteConflictingOutputs:
                flutterPubRunBuildRunnerBuildDeleteConflictingOutputs,
            dartFormatFix: dartFormatFix,
            generator: (_) async => generator,
          );

          // Act
          final logger = FakeLogger();
          await valueObject.create(
            logger: logger,
            type: 'Pair<#A, #B>',
            generics: '<A, B>',
          );

          // Assert
          verify(
            () => generator.generate(
              any(
                that: isA<DirectoryGeneratorTarget>().having(
                  (g) => g.dir.path,
                  'dir',
                  'domain_package/path',
                ),
              ),
              vars: <String, dynamic>{
                'project_name': 'my_project',
                'name': 'my_value_object',
                'output_dir': 'value_object/path',
                'type': 'Pair<#A, #B>',
                'generics': '<A, B>',
              },
              logger: logger,
            ),
          ).called(1);
          verify(
            () => flutterPubRunBuildRunnerBuildDeleteConflictingOutputs(
              cwd: 'domain_package/path',
              logger: logger,
            ),
          ).called(1);
          verify(
            () => dartFormatFix(cwd: 'domain_package/path', logger: logger),
          ).called(1);
        }),
      );
    });

    group('.delete()', () {
      test(
        'deletes all related files',
        withTempDir(() async {
          // Arrange
          final domainPackage = getDomainPackage();
          when(() => domainPackage.path).thenReturn('domain_package/path');
          final valueObject = _getValueObject(
            name: 'Cool',
            dir: '.',
            domainPackage: domainPackage,
          );
          final valueObjectDir = Directory('domain_package/path/lib/cool')
            ..createSync(recursive: true);
          final valueObjectTestDir = Directory('domain_package/path/test/cool')
            ..createSync(recursive: true);

          // Act
          final logger = FakeLogger();
          valueObject.delete(logger: logger);

          // Assert
          expect(valueObjectDir.existsSync(), false);
          expect(valueObjectTestDir.existsSync(), false);
        }),
      );
    });
  });
}
