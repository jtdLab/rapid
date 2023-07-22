import 'package:test/test.dart';
import 'package:{{project_name}}_infrastructure{{#has_sub_infrastructure_name}}_{{sub_infrastructure_name}}{{/has_sub_infrastructure_name}}/{{project_name}}_infrastructure{{#has_sub_infrastructure_name}}_{{sub_infrastructure_name}}{{/has_sub_infrastructure_name}}.dart';

{{name.pascalCase()}}{{service_interface_name.pascalCase()}}Service _{{name.camelCase()}}{{service_interface_name.pascalCase()}}Service() {
  return {{name.pascalCase()}}{{service_interface_name.pascalCase()}}Service();
}

void main() {
  group('{{name.pascalCase()}}{{service_interface_name.pascalCase()}}Service', () {
    test('.()', () {
      // Act
      final {{name.camelCase()}}{{service_interface_name.pascalCase()}}Service = _{{name.camelCase()}}{{service_interface_name.pascalCase()}}Service();

      // Assert
      expect({{name.camelCase()}}{{service_interface_name.pascalCase()}}Service, isNotNull);
    });

    // TODO: implement
  });
}
