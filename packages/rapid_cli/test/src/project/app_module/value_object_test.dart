import 'package:mocktail/mocktail.dart';
import 'package:rapid_cli/src/mason.dart';
import 'package:rapid_cli/src/project/bundles/bundles.dart';
import 'package:rapid_cli/src/project/project.dart';
import 'package:test/test.dart';

import '../../matchers.dart';
import '../../mock_env.dart';
import '../../mocks.dart';

ValueObject _getValueObject({
  String? projectName,
  String? path,
  String? name,
  String? subDomainName,
}) {
  return ValueObject(
    projectName: projectName ?? 'projectName',
    path: path ?? 'path',
    name: name ?? 'Name',
    subDomainName: subDomainName,
  );
}

void main() {
  setUpAll(registerFallbackValues);

  group('ValueObject', () {
    test('file', () {
      final valueObject = _getValueObject(
        projectName: 'test_project',
        path: '/path/to/domain_package',
        name: 'EmailAddress',
      );

      expect(
        valueObject.file.path,
        '/path/to/domain_package/lib/src/email_address.dart',
      );
    });

    test('freezedFile', () {
      final valueObject = _getValueObject(
        projectName: 'test_project',
        path: '/path/to/domain_package',
        name: 'EmailAddress',
      );

      expect(
        valueObject.freezedFile.path,
        '/path/to/domain_package/lib/src/email_address.freezed.dart',
      );
    });

    test('testFile', () {
      final valueObject = _getValueObject(
        projectName: 'test_project',
        path: '/path/to/domain_package',
        name: 'EmailAddress',
      );

      expect(
        valueObject.testFile.path,
        '/path/to/domain_package/test/src/email_address_test.dart',
      );
    });

    test('entities', () {
      final valueObject = _getValueObject(
        projectName: 'test_project',
        path: '/path/to/domain_package',
        name: 'EmailAddress',
      );

      expect(
        valueObject.entities,
        entityEquals([
          valueObject.file,
          valueObject.freezedFile,
          valueObject.testFile,
        ]),
      );
    });

    test(
      'generate',
      withMockFs(() async {
        final generator = MockMasonGenerator();
        final generatorBuilder = MockMasonGeneratorBuilder(
          generator: generator,
        );
        generatorOverrides = generatorBuilder.call;
        final valueObject = _getValueObject(
          projectName: 'test_project',
          path: '/path/to/domain_package',
          name: 'EmailAddress',
          subDomainName: 'sub_domain',
        );

        await valueObject.generate(
          type: 'String',
          generics: '<String>',
        );

        verifyInOrder([
          () => generatorBuilder(valueObjectBundle),
          () => generator.generate(
                any(
                  that: isA<DirectoryGeneratorTarget>().having(
                    (e) => e.dir.path,
                    'path',
                    '/path/to/domain_package',
                  ),
                ),
                vars: <String, dynamic>{
                  'project_name': 'test_project',
                  'name': 'EmailAddress',
                  'type': 'String',
                  'generics': '<String>',
                  'output_dir': '.',
                  'output_dir_is_cwd': true,
                  'sub_domain_name': 'sub_domain',
                  'has_sub_domain_name': true,
                },
              ),
        ]);
      }),
    );
  });
}
