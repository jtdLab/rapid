import 'package:test/test.dart';
import 'package:{{project_name}}_infrastructure{{#has_sub_infrastructure_name}}_{{sub_infrastructure_name}}{{/has_sub_infrastructure_name}}/{{project_name}}_infrastructure{{#has_sub_infrastructure_name}}_{{sub_infrastructure_name}}{{/has_sub_infrastructure_name}}.dart';

void main() {
  group('{{name.pascalCase()}}{{service_interface_name.pascalCase()}}Service', () {
    test('.()', () {
      // Act
      final {{name.camelCase()}}{{service_interface_name.pascalCase()}}Service = {{name.pascalCase()}}{{service_interface_name.pascalCase()}}Service();

      // Assert
      expect({{name.camelCase()}}{{service_interface_name.pascalCase()}}Service, isNotNull);
    });

    // TODO: implement tests for service methods here
  });
}
