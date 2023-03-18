import 'package:test/test.dart';
import 'package:{{project_name}}_{{#pathCase}}domain/{{{output_dir}}}{{/pathCase}}/{{name.snakeCase()}}/{{name.snakeCase()}}.dart';

void main() {
  group('{{name.pascalCase()}}', () {
    group('.()', () {
      test('', () {
        // Arrange + Act
        final {{name.camelCase()}} = {{name.pascalCase()}}(id: 'some_id');

        // Assert
        expect({{name.camelCase()}}.id, 'some_id');
      });
    });

    group('.random()', () {
      test('', () {
        // Arrange + Act
        final {{name.camelCase()}} = {{name.pascalCase()}}.random();

        // Assert
        expect({{name.camelCase()}}.id, isNotNull);
      });

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
