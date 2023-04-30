import 'package:test/test.dart';
import 'package:{{project_name}}_infrastructure{{#has_subinfrastructure_name}}_{{subinfrastructure_name}}{{/has_subinfrastructure_name}}/{{project_name}}_infrastructure{{#has_subinfrastructure_name}}_{{subinfrastructure_name}}{{/has_subinfrastructure_name}}.dart';

{{name.pascalCase()}}{{service_name.pascalCase()}}Service _{{name.camelCase()}}{{service_name.pascalCase()}}Service() {
  return {{name.pascalCase()}}{{service_name.pascalCase()}}Service();
}

void main() {
  group('{{name.pascalCase()}}{{service_name.pascalCase()}}Service', () {
    test('.()', () {
      // Act
      final {{name.camelCase()}}{{service_name.pascalCase()}}Service = _{{name.camelCase()}}{{service_name.pascalCase()}}Service();

      // Assert
      expect({{name.camelCase()}}{{service_name.pascalCase()}}Service, isNotNull);
    });

    // TODO: implement
  });
}
