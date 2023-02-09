import 'dart:io';

import 'package:mason/mason.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rapid_cli/src/cli/cli.dart';
import 'package:rapid_cli/src/core/generator_builder.dart';
import 'package:rapid_cli/src/project/infrastructure_package/infrastructure_package.dart';
import 'package:rapid_cli/src/project/project.dart';
import 'package:test/test.dart';

import '../../common.dart';
import '../../mocks.dart';

InfrastructurePackage _getInfrastructurePackage({
  Project? project,
  GeneratorBuilder? generator,
}) {
  return InfrastructurePackage(
    project: project ?? getProject(),
    generator: generator ?? (_) async => getMasonGenerator(),
  );
}

DataTransferObject _getDataTransferObject({
  required String entityName,
  required String dir,
  InfrastructurePackage? infrastructurePackage,
  DartFormatFixCommand? dartFormatFix,
  GeneratorBuilder? generator,
}) {
  return DataTransferObject(
    entityName: entityName,
    dir: dir,
    infrastructurePackage: infrastructurePackage ?? getInfrastructurePackage(),
    dartFormatFix: dartFormatFix ?? getDartFormatFix().call,
    generator: generator ?? (_) async => getMasonGenerator(),
  );
}

ServiceImplementation _getServiceImplementation({
  required String name,
  required String serviceName,
  required String dir,
  InfrastructurePackage? infrastructurePackage,
  DartFormatFixCommand? dartFormatFix,
  GeneratorBuilder? generator,
}) {
  return ServiceImplementation(
    name: name,
    serviceName: serviceName,
    dir: dir,
    infrastructurePackage: infrastructurePackage ?? getInfrastructurePackage(),
    dartFormatFix: dartFormatFix ?? getDartFormatFix().call,
    generator: generator ?? (_) async => getMasonGenerator(),
  );
}

void main() {
  group('InfrastructurePackage', () {
    setUpAll(() {
      registerFallbackValue(FakeDirectoryGeneratorTarget());
    });

    test('.path', () {
      // Arrange
      final project = getProject();
      when(() => project.path).thenReturn('project/path');
      when(() => project.name()).thenReturn('my_project');
      final infrastructurePackage = _getInfrastructurePackage(project: project);

      // Act + Assert
      expect(
        infrastructurePackage.path,
        'project/path/packages/my_project/my_project_infrastructure',
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
          final infrastructurePackage = _getInfrastructurePackage(
            project: project,
            generator: (_) async => generator,
          );

          // Act
          final logger = FakeLogger();
          await infrastructurePackage.create(
            logger: logger,
          );

          // Assert
          verify(
            () => generator.generate(
              any(
                that: isA<DirectoryGeneratorTarget>().having(
                  (g) => g.dir.path,
                  'dir',
                  'project/path/packages/my_project/my_project_infrastructure',
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

    test('.dataTransferObject()', () {
      // Arrange
      final infrastructurePackage = _getInfrastructurePackage();

      // Act + Assert
      expect(
        infrastructurePackage.dataTransferObject(
          entityName: 'Cool',
          dir: 'data_transfer_object/path',
        ),
        isA<DataTransferObject>()
            .having((dto) => dto.entityName, 'entityName', 'Cool')
            .having((dto) => dto.dir, 'dir', 'data_transfer_object/path')
            .having(
              (dto) => dto.infrastructurePackage,
              'infrastructurePackage',
              infrastructurePackage,
            ),
      );
    });

    test('.serviceImplementation()', () {
      // Arrange
      final infrastructurePackage = _getInfrastructurePackage();

      // Act + Assert
      expect(
        infrastructurePackage.serviceImplementation(
          name: 'Fake',
          serviceName: 'MyService',
          dir: 'service_implementation/path',
        ),
        isA<ServiceImplementation>()
            .having((si) => si.serviceName, 'serviceName', 'MyService')
            .having(
              (si) => si.dir,
              'dir',
              'service_implementation/path',
            )
            .having(
              (si) => si.infrastructurePackage,
              'infrastructurePackage',
              infrastructurePackage,
            ),
      );
    });
  });

  group('DataTransferObject', () {
    setUpAll(() {
      registerFallbackValue(FakeLogger());
      registerFallbackValue(FakeDirectoryGeneratorTarget());
    });

    test('.entityName', () {
      // Arrange
      final dataTransferObject = _getDataTransferObject(
        entityName: 'MyEntity',
        dir: '.',
      );

      // Act + Assert
      expect(dataTransferObject.entityName, 'MyEntity');
    });

    test('.dir', () {
      // Arrange
      final dataTransferObject = _getDataTransferObject(
        entityName: 'MyEntity',
        dir: 'data_transfer_object/path',
      );

      // Act + Assert
      expect(dataTransferObject.dir, 'data_transfer_object/path');
    });

    test('.infrastructurePackage', () {
      // Arrange
      final infrastructurePackage = getInfrastructurePackage();
      final dataTransferObject = _getDataTransferObject(
        entityName: 'MyEntity',
        dir: '.',
        infrastructurePackage: infrastructurePackage,
      );

      // Act + Assert
      expect(dataTransferObject.infrastructurePackage, infrastructurePackage);
    });

    group('create', () {
      test(
        'completes successfully with correct output',
        withTempDir(() async {
          // Arrange
          final project = getProject();
          when(() => project.name()).thenReturn('my_project');
          final infrastructurePackage = getInfrastructurePackage();
          when(() => infrastructurePackage.path)
              .thenReturn('infrastructure_package/path');
          when(() => infrastructurePackage.project).thenReturn(project);
          final dartFormatFix = getDartFormatFix();
          final generator = getMasonGenerator();
          final dataTransferObject = _getDataTransferObject(
            entityName: 'MyEntity',
            dir: 'data_transfer_object/path',
            infrastructurePackage: infrastructurePackage,
            dartFormatFix: dartFormatFix,
            generator: (_) async => generator,
          );

          // Act
          final logger = FakeLogger();
          await dataTransferObject.create(
            logger: logger,
          );

          // Assert
          verify(
            () => generator.generate(
              any(
                that: isA<DirectoryGeneratorTarget>().having(
                  (g) => g.dir.path,
                  'dir',
                  'infrastructure_package/path',
                ),
              ),
              vars: <String, dynamic>{
                'project_name': 'my_project',
                'entity_name': 'MyEntity',
                'output_dir': 'data_transfer_object/path',
              },
              logger: logger,
            ),
          ).called(1);
          verify(
            () => dartFormatFix(
              cwd: 'infrastructure_package/path',
              logger: logger,
            ),
          ).called(1);
        }),
      );
    });

    group('.delete()', () {
      test(
        'deletes all related files',
        withTempDir(() async {
          // Arrange
          final infrastructurePackage = getInfrastructurePackage();
          when(() => infrastructurePackage.path)
              .thenReturn('infrastructure_package/path');
          final dataTransferObject = _getDataTransferObject(
            entityName: 'Cool',
            dir: '.',
            infrastructurePackage: infrastructurePackage,
          );
          final dataTransferObjectDir =
              Directory('infrastructure_package/path/lib/src/cool')
                ..createSync(recursive: true);
          final dataTransferObjectTestDir =
              Directory('infrastructure_package/path/test/src/cool')
                ..createSync(recursive: true);

          // Act
          final logger = FakeLogger();
          dataTransferObject.delete(logger: logger);

          // Assert
          expect(dataTransferObjectDir.existsSync(), false);
          expect(dataTransferObjectTestDir.existsSync(), false);
        }),
      );
    });
  });

  group('ServiceImplementation', () {
    setUpAll(() {
      registerFallbackValue(FakeLogger());
      registerFallbackValue(FakeDirectoryGeneratorTarget());
    });

    test('.serviceName', () {
      // Arrange
      final serviceImplementation = _getServiceImplementation(
        name: 'Fake',
        serviceName: 'MyService',
        dir: '.',
      );

      // Act + Assert
      expect(serviceImplementation.serviceName, 'MyService');
    });

    test('.dir', () {
      // Arrange
      final serviceImplementation = _getServiceImplementation(
        name: 'Fake',
        serviceName: 'MyService',
        dir: 'service_implementation/path',
      );

      // Act + Assert
      expect(serviceImplementation.dir, 'service_implementation/path');
    });

    test('.infrastructurePackage', () {
      // Arrange
      final infrastructurePackage = getInfrastructurePackage();
      final serviceImplementation = _getServiceImplementation(
        name: 'Fake',
        serviceName: 'MyService',
        dir: '.',
        infrastructurePackage: infrastructurePackage,
      );

      // Act + Assert
      expect(
        serviceImplementation.infrastructurePackage,
        infrastructurePackage,
      );
    });

    group('create', () {
      test(
        'completes successfully with correct output',
        withTempDir(() async {
          // Arrange
          final project = getProject();
          when(() => project.name()).thenReturn('my_project');
          final infrastructurePackage = getInfrastructurePackage();
          when(() => infrastructurePackage.path)
              .thenReturn('infrastructure_package/path');
          when(() => infrastructurePackage.project).thenReturn(project);
          final dartFormatFix = getDartFormatFix();
          final generator = getMasonGenerator();
          final serviceImplementation = _getServiceImplementation(
            name: 'Fake',
            serviceName: 'MyService',
            dir: 'service_implementation/path',
            infrastructurePackage: infrastructurePackage,
            dartFormatFix: dartFormatFix,
            generator: (_) async => generator,
          );

          // Act
          final logger = FakeLogger();
          await serviceImplementation.create(
            logger: logger,
          );

          // Assert
          verify(
            () => generator.generate(
              any(
                that: isA<DirectoryGeneratorTarget>().having(
                  (g) => g.dir.path,
                  'dir',
                  'infrastructure_package/path',
                ),
              ),
              vars: <String, dynamic>{
                'project_name': 'my_project',
                'name': 'Fake',
                'service_name': 'MyService',
                'output_dir': 'service_implementation/path',
              },
              logger: logger,
            ),
          ).called(1);
          verify(
            () => dartFormatFix(
              cwd: 'infrastructure_package/path',
              logger: logger,
            ),
          ).called(1);
        }),
      );
    });

    test(
      'deletes all related files',
      withTempDir(() async {
        // Arrange
        final infrastructurePackage = getInfrastructurePackage();
        when(() => infrastructurePackage.path)
            .thenReturn('infrastructure_package/path');
        final serviceImplementation = _getServiceImplementation(
          name: 'Fake',
          serviceName: 'MyService',
          dir: '.',
          infrastructurePackage: infrastructurePackage,
        );
        final serviceImplementationDir =
            Directory('infrastructure_package/path/lib/src/my_service')
              ..createSync(recursive: true);
        final serviceImplementationTestDir =
            Directory('infrastructure_package/path/test/src/my_service')
              ..createSync(recursive: true);

        // Act
        final logger = FakeLogger();
        serviceImplementation.delete(logger: logger);

        // Assert
        expect(serviceImplementationDir.existsSync(), false);
        expect(serviceImplementationTestDir.existsSync(), false);
      }),
    );
  });
}
