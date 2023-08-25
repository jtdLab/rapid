import 'package:test/test.dart';
import 'package:{{project_name}}_domain{{#has_sub_domain_name}}_{{sub_domain_name}}{{/has_sub_domain_name}}/src{{^output_dir_is_cwd}}/{{{output_dir}}}{{/output_dir_is_cwd}}/{{name.snakeCase()}}.dart';

void main() {
  group('{{name.pascalCase()}}', () {
    group('.()', () {
      test('returns correct instance', () {
        // Arrange + Act
        const {{name.camelCase()}} = {{name.pascalCase()}}(id: 'some_id');

        // Assert
        expect({{name.camelCase()}}.id, 'some_id');
      });
    });

    group('.random()', () {
      test(
        'returns different instances',
        () {
          // Arrange + Act
          final instance1 = {{name.pascalCase()}}.random();
          final instance2 = {{name.pascalCase()}}.random();

          // Assert
          expect(instance1, isNot(instance2));
        },
        retry: 5,
      );
    });
  });
}
