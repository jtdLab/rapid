import 'package:test/test.dart';
import 'package:{{project_name}}_infrastructure{{#has_subinfrastructure_name}}_{{subinfrastructure_name}}{{/has_subinfrastructure_name}}/src{{^output_dir_is_cwd}}/{{{output_dir}}}{{/output_dir_is_cwd}}/{{name.snakeCase()}}_{{service_name.snakeCase()}}_service.dart';

void main() {
  group('{{name.pascalCase()}}{{service_name.pascalCase()}}Service', () {
    test('.()', () {
      // Act
      final {{name.camelCase()}}{{service_name.pascalCase()}}Service = {{name.pascalCase()}}{{service_name.pascalCase()}}Service();

      // Assert
      expect({{name.camelCase()}}{{service_name.pascalCase()}}Service, isNotNull);
    });

    group('.myMethod()', () {
      test('TODO description', () {
        // TODO implement
      });
    });
  });
}
